# ArchiveTeam Warrior — pinned snapshot of the official image.
# This digest equals the registry's `latest` as of 2026-09-13 (the 2026-09-10 push).
# To update: get the current digest with
#   curl -sI -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
#     https://atdr.meo.ws/v2/archiveteam/warrior-dockerfile/manifests/latest | grep -i docker-content-digest
FROM atdr.meo.ws/archiveteam/warrior-dockerfile@sha256:972495c60ab7f43d8abfd494ada86581398067e0cb5c66cfff1caeca01d9f6fb

EXPOSE 8001
