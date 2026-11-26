#!/usr/bin/env bash
# Runner host has docker, no make. Run make in a docker CLI image on the host socket, same-path mount.
# The image is built once per Dockerfile.ci content and reused from the host's local docker cache.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
if command -v sha256sum >/dev/null; then sum="$(sha256sum "$here/Dockerfile.ci")"; else sum="$(shasum -a 256 "$here/Dockerfile.ci")"; fi
CI_IMAGE="thesada-hw-ci:${sum:0:12}"
if ! docker image inspect "$CI_IMAGE" >/dev/null 2>&1; then
  docker build -q --network host -t "$CI_IMAGE" -f "$here/Dockerfile.ci" "$here" >/dev/null
fi
uid="$(id -u)"; gid="$(id -g)"
exec docker run --rm --network host -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$PWD":"$PWD" -w "$PWD" -e HOST_IDS="$uid:$gid" "$CI_IMAGE" sh -c '
    rc=0
    make "$@" || rc=$?
    [ ! -e build ] || chown -R "$HOST_IDS" build
    find . -name __pycache__ -type d -exec chown -R "$HOST_IDS" {} +
    exit $rc' ci-run "$@"
