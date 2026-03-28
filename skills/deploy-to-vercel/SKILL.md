---
name: deploy-to-vercel
description: Deploy applications and websites to Vercel using a token or fallback script. Never uses interactive login.
metadata:
  author: vercel
  version: "5.0.0"
---

# Deploy to Vercel (Non-Interactive)

Deploy any project to Vercel using the CLI with a token or the fallback scripts. **Never** attempt to log in interactively or use `vercel login`.

## Deployment Methods

### 1. Using VERCEL_TOKEN (Preferred)

If a `VERCEL_TOKEN` (starts with `vcp_`) is provided, use the CLI directly:

```bash
vercel deploy [path] -y --no-wait --token <token> [--scope <team-slug>]
```

- Always include `-y` (or `--yes`) to bypass confirmation prompts.
- Always include `--token <token>`.
- Use `--scope` if the user specifies a team.

### 2. Fallback Scripts (No Token)

In environments where no token is available and CLI login is impossible, use the fallback scripts.

#### Codex sandbox
```bash
bash "skills/deploy-to-vercel/resources/deploy-codex.sh" [path]
```

#### claude.ai sandbox
```bash
bash "skills/deploy-to-vercel/resources/deploy.sh" [path]
```

## Workflow

1.  **Skip Auth Checks**: Do not run `vercel whoami` or `vercel login`.
2.  **Deploy**: Use the CLI with a token or the appropriate fallback script.
3.  **Output**: Always show the user the deployment URL returned by the tool.

## Troubleshooting

### Interactive Prompts
If any command triggers an interactive prompt (e.g., "Log in with..."), **abort immediately**. This environment does not support interactivity.
