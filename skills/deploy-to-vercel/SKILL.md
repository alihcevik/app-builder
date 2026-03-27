---
name: deploy-to-vercel
description: Deploy applications and websites to Vercel. Use when the user requests deployment actions like "deploy my app", "deploy and give me the link", "push this live", or "create a preview deployment".
metadata:
  author: vercel
  version: "4.0.0"
---

# Deploy to Vercel

Deploy any project to Vercel. **Always deploy as preview** (not production) unless the user explicitly asks for production.

## Non-Interactive / API-First Deployment

If you are running in a non-interactive environment (API, sandbox, or CI) or have a `VERCEL_TOKEN`, **never** use `vercel login`. Use the token directly with the CLI or fall back to the deployment scripts.

### Using VERCEL_TOKEN with CLI

If a `VERCEL_TOKEN` is available:
```bash
vercel deploy [path] -y --no-wait --token <token>
```
Pass `--scope <team-slug>` if a specific team is required.

## Step 1: Gather Project State

Run these checks to decide which method to use:

```bash
# 1. Check for a git remote
git remote get-url origin 2>/dev/null

# 2. Check if locally linked to a Vercel project (either file means linked)
cat .vercel/project.json 2>/dev/null || cat .vercel/repo.json 2>/dev/null

# 3. Check if the Vercel CLI is installed and authenticated
vercel whoami 2>/dev/null

# 4. List available teams (if authenticated)
vercel teams list --format json 2>/dev/null
```

### Team selection

If the user belongs to multiple teams, present all available team slugs as a bulleted list and ask which one to deploy to. Once the user picks a team, proceed immediately to the next step — do not ask for additional confirmation.

Pass the team slug via `--scope` on all subsequent CLI commands (`vercel deploy`, `vercel link`, `vercel inspect`, etc.):

```bash
vercel deploy [path] -y --no-wait --scope <team-slug>
```

If the project is already linked (`.vercel/project.json` or `.vercel/repo.json` exists), the `orgId` in those files determines the team.

## Step 2: Choose a Deploy Method

### Linked (`.vercel/` exists) + has git remote → Git Push

1. **Ask the user before pushing.**
2. **Commit and push:**
   ```bash
   git add .
   git commit -m "deploy: <description of changes>"
   git push
   ```
3. **Retrieve the preview URL.** Use `vercel ls --format json` if authenticated.

---

### CLI is authenticated or Token is provided → `vercel deploy`

Deploy directly with the CLI using `--yes` to skip prompts.

```bash
vercel deploy [path] -y --no-wait [--token <token>] [--scope <team-slug>]
```

Use `vercel inspect <deployment-url>` to check status.

---

### Not authenticated + No token → Fallback Scripts

In environments where `vercel login` is impossible (e.g. sandboxes), use the fallback scripts. **Never** attempt `vercel login` in these environments.

#### Codex sandbox
```bash
bash "<path-to-skill>/resources/deploy-codex.sh" [path]
```

#### claude.ai sandbox
```bash
bash "/mnt/skills/user/deploy-to-vercel/resources/deploy.sh" [path]
```

---

## Output

Always show the user the deployment URL.

- **CLI deploy:** Show the URL returned by `vercel deploy`.
- **Fallback script:** Show both the **Preview URL** and the **Claim URL**.

---

## Troubleshooting

### CLI Auth Failure / Interactive Prompt
If any `vercel` command triggers an interactive prompt (e.g. "Log in with..."), **abort immediately** and switch to using a token or the fallback scripts.
