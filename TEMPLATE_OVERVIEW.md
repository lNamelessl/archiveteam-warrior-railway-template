# ArchiveTeam Warrior — donate idle bandwidth to web preservation, one click

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.app/new?github_url=https://github.com/lNamelessl/archiveteam-warrior-railway-template)

Websites die every day — Geocities, forums, news articles, entire social platforms — and [ArchiveTeam](https://archiveteam.org) is the volunteer swarm racing to save them. The **Warrior** is their turnkey archiving client: deploy it once, and it joins whichever preservation project currently needs workers, grabbing and archiving pages around the clock. This template turns it into a genuine one-click deploy: **deploy → set your leaderboard nickname → open the UI.** No Docker CLI, no config files, no reading wikis.

**What you get in one click:**

- The **official ArchiveTeam warrior image** (`atdr.meo.ws/archiveteam/warrior-dockerfile`), pinned by digest, served through a Railway-managed build from this repo — updatable, ejectable, yours.
- **Auth enforced by default.** A public, unauthenticated warrior lets any stranger on the internet burn your bandwidth and click around your dashboard. This template auto-generates `HTTP_USERNAME` / `HTTP_PASSWORD` per deployment — the deploy form never asks, and anonymous access is rejected.
- **A persistent volume** at `/home/warrior/projects`. Your nickname, project selection, and settings live in `config.json` on that volume, so they survive redeploys.
- **Auto-assignment out of the box.** `SELECTED_PROJECT=auto` means ArchiveTeam's tracker points your warrior at whichever project needs help most right now. Prefer a specific project? Change it in the UI in two clicks.

## Setup: 3 steps

1. **Deploy** — click the button above; the only prompt is `DOWNLOADER`, your nickname on the [ArchiveTeam leaderboard](https://archiveteam.org/index.php?title=Warrior).
2. **Get your credentials** — open your new service's **Variables** tab and copy the auto-generated `HTTP_USERNAME` / `HTTP_PASSWORD`.
3. **Open the UI** — visit the Railway domain, log in, and watch your warrior pick up a project and start capturing.

## ⚠️ Before you deploy: this template consumes bandwidth

Archiving is a bandwidth job. While a project is active, your warrior **continuously downloads and uploads web data 24/7**, and on Railway that traffic is usage-based billing (egress + ingress) — typically several GB per day, sometimes tens of GB on heavy projects. That is the #1 surprise for new deployers, so decide deliberately: leave `CONCURRENT_ITEMS=3` (the gentle default), pause the service in the Railway dashboard whenever you're not actively donating, or pick a lighter project in the UI. The CPU/RAM footprint is small; bandwidth is the real cost.

# Deploy and Host

## About Hosting

Hosting the ArchiveTeam Warrior on Railway provisions a single **Warrior service** built from this repo's Dockerfile, which wraps the official `atdr.meo.ws/archiveteam/warrior-dockerfile` image pinned by digest. The warrior's web UI listens on port 8001 and is exposed on your Railway public domain behind HTTP basic auth (`HTTP_USERNAME` / `HTTP_PASSWORD`, generated per deployment via Railway's `secret()`). A **Railway volume** is mounted at `/home/warrior/projects` so the warrior's `config.json` — nickname, selected project, and UI settings — persists across redeploys. First-boot behavior is seeded from image defaults (`SELECTED_PROJECT=auto`, `CONCURRENT_ITEMS=3`, `SHARED_RSYNC_THREADS=20`); afterwards the warrior reads its configuration from `config.json` on the volume, which is exactly what makes your settings survive restarts.

## Why Deploy

Deploying the warrior manually means running Docker commands on a machine you keep awake, remembering to add auth, and losing your configuration every time the container is replaced. On Railway you get a one-click deploy with auth already enforced, a volume that keeps your identity and project selection across redeploys, automatic restarts (`restartPolicyType: ALWAYS`), a public URL with TLS, and an observable dashboard with logs and usage metrics. You can pause the warrior whenever you don't want it working — something a home server doesn't make as easy.

## Common Use Cases

- **Digital preservation volunteering** — join the ArchiveTeam swarm and help archive at-risk websites, tracked on the public leaderboard under your nickname.
- **Self-hosted archiving rig** — run a warrior in the cloud instead of a spare laptop or Raspberry Pi at home, with restart-on-failure and remote access via the auth-gated web UI.
- **Team or community contribution** — a shared, credentialed warrior instance for a community that wants its nickname on the leaderboard without everyone installing Docker.
- **On-and-off donating** — pause the service during bandwidth-costly periods and resume with all settings intact thanks to the persistent volume.

## Dependencies for

The template has **zero external service dependencies** — the warrior talks directly to ArchiveTeam's tracker and rsync servers from the public internet, and all state lives in its own Railway volume.

### Deployment Dependencies

- **Warrior service** — built from this repo (Dockerfile pinning `atdr.meo.ws/archiveteam/warrior-dockerfile` by digest). Public domain on port 8001. Variables: `DOWNLOADER` (your leaderboard nickname, asked at deploy time), `HTTP_USERNAME` and `HTTP_PASSWORD` (auto-generated per deployment — view them in the Variables tab).
- **Volume** — mounted at `/home/warrior/projects`, stores `projects/config.json` (nickname, project selection, UI credentials) so settings survive redeploys.

⚠️ **Running cost note:** the warrior's job is moving web data. Expect usage-based bandwidth charges (egress + ingress) while a project is active — see the cost warning above for how to keep them under control.
