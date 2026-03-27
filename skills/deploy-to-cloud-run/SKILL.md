---
name: deploy-to-cloud-run
description: Deploy applications and websites to Google Cloud Run. Use when the user requests deployment actions like "deploy to cloud run", "push to GCP", or provides a Google Cloud Service Account key for deployment.
---

# Deploy to Cloud Run

Deploy any Next.js (or containerized) project to Google Cloud Run with automated configuration.

## Workflow

### 1. Gather Configuration
The `deploy.sh` script is designed to be highly automated:
- **Service Account Key**: A JSON key file. 
    - **Note:** If the user provides the *content* of the key, save it to `.gcp-key.json` first.
    - **Expert Tip:** To avoid formatting errors with `\n` in the JSON, use a Python script to write the key file: `python3 -c "import json; json.dump(<KEY_JSON>, open('.gcp-key.json', 'w'))"`.
- **Project ID**: Extracted automatically from the key.
- **Region**: Defaults to `us-central1`.
- **Service Name**: Defaults to the folder name.

### 2. Execution & Automation
Run the `deploy.sh` script. It will automatically:
1.  **Authenticate** using the provided key.
2.  **Enable necessary APIs** (Run, Cloud Build, Artifact Registry).
3.  **Detect Next.js projects** and ensure `next.config.js/ts` is set to `output: 'standalone'`.
4.  **Inject the optimized Dockerfile** if one doesn't exist.
5.  **Build & Deploy** the container to Cloud Run.
6.  **Set IAM Policy** to allow public access (requires the Service Account to have `Project IAM Admin` permissions).

```bash
# Automated deployment (from project root):
bash "skills/deploy-to-cloud-run/scripts/deploy.sh" "." "" "" "" ".gcp-key.json"
```

## Troubleshooting
- **Permissions**: The Service Account needs specific roles (Run Admin, Storage Admin, Cloud Build Editor, IAM Service Account User). Refer the user to `references/gcp-setup.md`.
- **Quota/Billing**: Cloud Build and Cloud Run require an active billing account on the GCP project.
- **API Errors**: If services cannot be enabled, the user may need `Service Usage Admin` permissions.

## Output
Always share the final service URL found in the "SUCCESS: Deployed to..." output line.
