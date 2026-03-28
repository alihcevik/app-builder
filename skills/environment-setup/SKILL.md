---
name: environment-setup
description: Set up the development and deployment environment for Next.js apps. Use when tools like 'vercel' or 'create-next-app' are missing, or when asked to "prepare the environment" for app building.
user-invocable: true
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

### 1. Environment Initialization
Run the bundled setup script to ensure necessary global CLI tools (like 'vercel') are present:

```bash
bash skills/environment-setup/scripts/setup.sh
```

### 2. Manual Scaffolding (Recommended)
In many restricted or sandbox environments, `create-next-app` fails because it tries to access protected system files (like `/etc/passwd`). Use the manual scaffolding script instead:

```bash
bash skills/environment-setup/scripts/scaffold.sh [app-name]
```

This script will:
- Initialize `package.json` and install core Next.js, React, and dev dependencies.
- Configure Tailwind CSS 4, PostCSS, and TypeScript.
- Set up `next.config.ts` with `output: 'standalone'` for Cloud Run compatibility.
- Create a standard `app/` directory structure with layout and home page.

## Troubleshooting

- **Permissions Error**: If `npm install` fails, the environment might require `sudo`.
- **System Errors**: If you encounter `uv_os_get_passwd` errors, you are likely using `create-next-app` in a restricted environment. Switch to `scaffold.sh`.
- **Vercel Deployment**: Always use a token with `--token <token> -y` for non-interactive environments to avoid interactive login prompts.
