# Google Cloud Platform Setup for Cloud Run Deployment

To use the `deploy-to-cloud-run` skill, you'll need:
1.  **GCP Project ID**.
2.  **Service Account** with the following roles:
    - `roles/run.admin`
    - `roles/storage.admin`
    - `roles/cloudbuild.builds.editor`
    - `roles/artifactregistry.admin`
    - `roles/iam.serviceAccountUser`
3.  **Service Account JSON Key**.

## How to Get the Key
1.  Go to the [IAM & Admin > Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts) page in your GCP Console.
2.  Select your service account and click **Manage keys**.
3.  Click **Add Key > Create new key** and choose **JSON**.
4.  Download the key and provide its path to Gemini CLI when requested.
