---
name: environment-setup
description: Set up the development and deployment environment for Next.js apps. Use when tools like 'vercel' or 'create-next-app' are missing, or when asked to "prepare the environment" for app building.
metadata:
  author: vercel
  version: "1.0.0"
---

# Environment Setup

Ensure the host environment is ready for building and deploying Next.js applications.

## Prerequisites
- **Node.js**: >= 18.x
- **npm**: (bundled with Node)
- **git**: (required for many build and deploy processes)

## Usage

### Automating with Script
Run the bundled setup script to ensure all global CLI tools are installed and in the PATH:

```bash
bash skills/environment-setup/scripts/setup.sh
```

This script will:
- Verify Node.js, npm, and git are present.
- Install `vercel` and `create-next-app` globally.
- Confirm they are available for use.

### Manual Verification
If the script cannot be run, manually ensure these tools are available:

1. **Vercel CLI**: `npm install -g vercel` (for deployments).
2. **create-next-app**: `npm install -g create-next-app` (for scaffolding).
3. **git**: (via your platform's package manager like `apt`, `brew`, or `yum`).

## Troubleshooting

- **Permissions Error**: If `npm install -g` fails, the environment might require `sudo` or be configured with a prefix.
- **npx Fallback**: If global installation is not possible, fall back to `npx <tool>` for execution, though it will be slower as it downloads each time.
