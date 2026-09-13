# ArchiveTeam Warrior — pinned snapshot of the official image.
# This digest equals the registry's `latest` as of 2026-09-13 (the 2026-09-10 push).
# To update: get the current digest with
#   docker manifest inspect --verbose atdr.meo.ws/archiveteam/warrior-dockerfile:latest
FROM atdr.meo.ws/archiveteam/warrior-dockerfile@sha256:972495c60ab7f43d8abfd494ada86581398067e0cb5c66cfff1caeca01d9f6fb

# Railway volumes mount root-owned, but the image's default USER is UID 1000 —
# start.py must write projects/config.json on the volume at first boot.
USER root

# First-boot seed settings for projects/config.json. Set here instead of as
# template variables so a one-click deploy needs no extra input; Railway service
# variables still override these if a deployer wants different values.
ENV SELECTED_PROJECT=auto \
    CONCURRENT_ITEMS=3 \
    SHARED_RSYNC_THREADS=20

EXPOSE 8001
