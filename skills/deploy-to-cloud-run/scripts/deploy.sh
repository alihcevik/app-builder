#!/bin/bash
set -e

# Capture the absolute path of the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Usage: ./deploy.sh <project_path> <project_id> <region> <service_name> [key_file_path]

PROJECT_PATH=$1
PROJECT_ID=$2
REGION=$3
SERVICE_NAME=$4
KEY_FILE_PATH=$5

if [ -z "$PROJECT_PATH" ]; then
  echo "Usage: ./deploy.sh <project_path> [project_id] [region] [service_name] [key_file_path]"
  exit 1
fi

# 1. Authenticate if key provided
if [ -n "$KEY_FILE_PATH" ] && [ -f "$KEY_FILE_PATH" ]; then
  echo "Authenticating with service account key..."
  # Convert to absolute path before cd-ing
  KEY_FILE_PATH=$(realpath "$KEY_FILE_PATH")
  
  # Normalize JSON to handle any escaping issues (e.g. \n in private keys)
  CLEAN_KEY=$(mktemp)
  if jq . "$KEY_FILE_PATH" > "$CLEAN_KEY" 2>/dev/null; then
    gcloud auth activate-service-account --key-file="$CLEAN_KEY" --quiet
    rm "$CLEAN_KEY"
  else
    echo "Warning: Key file is not valid JSON, attempting authentication with original file..."
    gcloud auth activate-service-account --key-file="$KEY_FILE_PATH" --quiet
    rm "$CLEAN_KEY"
  fi
  
  # If project_id is empty or "auto", extract it from the key
  if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" = "auto" ]; then
    echo "Extracting Project ID from service account key..."
    PROJECT_ID=$(jq -r '.project_id' "$KEY_FILE_PATH")
    if [ -z "$PROJECT_ID" ] || [ "$PROJECT_ID" = "null" ]; then
       echo "Error: Could not find project_id in JSON key."
       exit 1
    fi
  fi
fi

if [ -z "$PROJECT_ID" ]; then
  echo "Error: Project ID is required (either as an argument or in the JSON key)."
  exit 1
fi

REGION=${REGION:-"us-central1"}
SERVICE_NAME=${SERVICE_NAME:-$(basename "$PROJECT_PATH")}

cd "$PROJECT_PATH"

# 2. Set project
echo "Setting project to $PROJECT_ID..."
gcloud config set project "$PROJECT_ID" --quiet

# 2.5 Prepare Next.js for standalone build
if [ -f "next.config.ts" ] || [ -f "next.config.js" ] || [ -f "next.config.mjs" ]; then
  echo "Detected Next.js project. Ensuring standalone output..."
  for f in next.config.ts next.config.js next.config.mjs; do
    if [ -f "$f" ]; then
      if ! grep -q "output: ['\"]standalone['\"]" "$f"; then
        echo "Updating $f to include output: 'standalone'..."
        # Portable replacement for adding output: 'standalone'
        TMP_FILE=$(mktemp)
        if grep -q "nextConfig: NextConfig = {" "$f"; then
          sed 's/nextConfig: NextConfig = {/nextConfig: NextConfig = {\n  output: "standalone",/' "$f" > "$TMP_FILE" && mv "$TMP_FILE" "$f"
        elif grep -q "const nextConfig = {" "$f"; then
          sed "s/const nextConfig = {/const nextConfig = {\n  output: 'standalone',/" "$f" > "$TMP_FILE" && mv "$TMP_FILE" "$f"
        else
          # Fallback for other patterns or if specific match fails
          rm "$TMP_FILE"
        fi
      fi
    fi
  done
fi

if [ ! -f "Dockerfile" ]; then
  echo "Dockerfile not found. Copying template..."
  cp "$SCRIPT_DIR/../assets/Dockerfile" .
fi

# 3. Enable necessary services
echo "Enabling required services (run.googleapis.com, cloudbuild.googleapis.com, artifactregistry.googleapis.com)..."
gcloud services enable run.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com --quiet

# 4. Deploy using Cloud Build (via --source)
# This will automatically pick up the Dockerfile in the project root.
echo "Deploying to Cloud Run..."
gcloud run deploy "$SERVICE_NAME" \
  --source . \
  --region "$REGION" \
  --platform managed \
  --allow-unauthenticated \
  --quiet

# 5. Get the URL
URL=$(gcloud run services describe "$SERVICE_NAME" --region "$REGION" --format 'value(status.url)')
echo "SUCCESS: Deployed to $URL"
