---
name: deploy-vps
description: Deploy the current project to Allan's Hetzner VPS using the project's own deploy scripts, then health-check and report. Use when user says "/deploy-vps", "deploy", "ship this to the VPS", "deploy my latest changes", or asks to pull/build/restart on the server.
---

# Deploy to the Hetzner VPS

The VPS is `ssh hetzner` (alias in `~/.ssh/config`: root@89.167.94.110, key `id_rsa`). Never type the raw IP; if the alias is missing, stop and say so.

## Workflow

1. **Read the project's deploy setup first.** Check the repo's `CLAUDE.md` and `deploy/` directory. Known projects:
   - **calton**: app at `/opt/calton`, systemd service `calton.service`, env `/etc/calton.env`. Deploy = `deploy/pull-build-restart.sh`; data import = `deploy/import-prod.sh`. See `deploy/README.md`.
   - **glide**: pm2 via `deploy/ecosystem.config.js`, nginx via `deploy/nginx-glideapp.conf`. Deploy = `deploy/deploy.sh`.
   - Anything else: read its `deploy/` scripts before improvising; if there are none, stop and ask rather than inventing a procedure.

2. **Confirm what's being deployed.** `git log --oneline -5` and `git status` locally; make sure the work is committed and pushed to the branch the server pulls (ask if unclear). Nothing to push and server already current → say so and stop.

3. **Run the project's deploy script** (locally if it wraps ssh, otherwise over `ssh hetzner`). Use the existing script; do not hand-roll pull/build/restart unless no script exists, and if you must, do exactly: pull `--ff-only`, install deps, build, restart the service (systemd or pm2 per project).

4. **Health-check.** Confirm the service is up (`systemctl status <svc>` / `pm2 list`), then hit the app's URL or port with `curl -sf -o /dev/null -w '%{http_code}'` and check the log tail for startup errors.

5. **Report.** Deployed commit (sha + subject), what restarted, health-check result, and the one URL Allan should open to eyeball it. If anything failed, the exact error and the state the server was left in.

## Rules

- Never run destructive server commands (rm, db drops, config rewrites) as part of a deploy; that is a separate, explicit request.
- Merge conflicts on the server mean the server has local edits it shouldn't have. Surface it; don't resolve on the box without asking.
- Secrets live in the server env files; never print their values into chat.
