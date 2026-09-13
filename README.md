# ArchiveTeam Warrior on Railway

One-click deploy of the [ArchiveTeam Warrior](https://wiki.archiveteam.org/index.php?title=Warrior) — the virtual archiving appliance that joins the internet's most crucial archiving efforts (formerly GeoCities, Google+, and currently whatever [ArchiveTeam's Choice](https://archiveteam.org) picks). Deploy it, enter a leaderboard nickname, open the UI: your warrior claims work from the tracker and starts preserving the web.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.app/new?github_url=https://github.com/lNamelessl/archiveteam-warrior-railway-template)

## What you get

- One `warrior` service built from the **official** `atdr.meo.ws/archiveteam/warrior-dockerfile` image, **pinned by digest** so rebuilds are reproducible.
- A persistent volume at `/home/warrior/projects` — your settings, selected project, and history survive redeploys and updates.
- Auto-generated basic-auth credentials: the deploy form asks only for your leaderboard nickname; username and password are generated as Railway variables.
- Sensible defaults baked in: `SELECTED_PROJECT=auto` (ArchiveTeam's Choice), `CONCURRENT_ITEMS=3`, `SHARED_RSYNC_THREADS=20` — overridable as service variables without editing anything.

## After deploying

1. **Enter your nickname** on the deploy form (`DOWNLOADER`) — it identifies you on the [leaderboard](https://www.archiveteam.org/index.php?title=Template:TrackerStatsDashboard).
2. **Open the public URL** Railway creates. Log in with `HTTP_USERNAME` / `HTTP_PASSWORD` from the service's **Variables** tab.
3. **That's it.** The warrior runs whatever ArchiveTeam's Choice (`SELECTED_PROJECT=auto`) considers most urgent and starts downloading items automatically.

## Variables

| Variable | Default | Meaning |
|---|---|---|
| `DOWNLOADER` | *(set at deploy)* | Your nickname on the ArchiveTeam leaderboard |
| `SELECTED_PROJECT` | `auto` | Project to run; `auto` = ArchiveTeam's Choice. Browse available slugs at `<your-domain>/available_projects/` |
| `CONCURRENT_ITEMS` | `3` | Items worked in parallel (1–6 shown in the UI; more = more CPU/RAM/ban risk) |
| `HTTP_USERNAME` | auto-generated | Basic-auth username for the web UI |
| `HTTP_PASSWORD` | auto-generated | Basic-auth password for the web UI |
| `SHARED_RSYNC_THREADS` | `20` | Parallel rsync threads used when a project uploads |
| `WARRIOR_ID` | *(empty)* | Optional stable warrior identifier |

**Important — envs seed once.** These variables write `/home/warrior/projects/config.json` on the **first boot only**. Once the config file exists (immediately after your first deploy), later changes to these variables are **ignored**. Change settings in the warrior's own web UI instead (Your settings / Available projects), or delete the volume and redeploy to re-seed from variables.

## ⚠️ Bandwidth warning — read before deploying

The warrior **uploads and downloads continuously, 24/7, without any built-in bandwidth limit** while a project is running — commonly tens to hundreds of GB per day depending on the project and concurrency. Railway charges for egress, so treat this like donating bandwidth, not hosting a website. If cost matters:

- Set `CONCURRENT_ITEMS` low (`1–2`), and
- Monitor usage under **Usage** in your Railway dashboard, and
- Stop or pause the service whenever you want (progress is uploaded in chunks; stopping loses nothing significant).

## Troubleshooting

- **401 in the browser** — you need the auto-generated credentials: service → **Variables** tab → `HTTP_USERNAME` / `HTTP_PASSWORD`.
- **Changed a variable, nothing happened** — expected after first boot (see the seeding note above). Use the warrior UI, or delete the volume + redeploy to re-seed.
- **No items / "waiting"** — the tracker may be between queues, or the project just started. Check the **Projects** tab in the UI; with `auto` a project is picked within minutes.
- **IP bans / captchas** — lower `CONCURRENT_ITEMS`. Never run the warrior through a proxy/VPN; the connection must be clean.
- **ARM not supported** — the official image is x86_64-only; Railway's x86_64 builders are fine.

## Updating the image

The `Dockerfile` pins the official image by digest for reproducibility. To update, replace the digest with the current `latest` (instructions in the Dockerfile comment) and push — Railway rebuilds, and the volume keeps your configuration. ArchiveTeam's warrior self-updates its project code roughly hourly, so pinning the base image does not freeze the archiving projects themselves.
