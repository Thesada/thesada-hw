#!/usr/bin/env bash
# usage: tools/check-dco.sh <base> <email>. Every non-merge commit in base..HEAD is
# authored as <email> and carries a Signed-off-by line with that address.
set -euo pipefail
base="$1"; email="$2"
git rev-parse --verify -q "$base^{commit}" >/dev/null || { echo "FAIL dco: base $base not found, fetch it"; exit 1; }
fail=0; n=0
for c in $(git rev-list --no-merges "$base..HEAD"); do
  n=$((n + 1))
  author="$(git log -1 --format=%ae "$c")"
  subject="$(git log -1 --format=%s "$c")"
  if [ "$author" != "$email" ]; then
    echo "FAIL dco: $c author $author, want $email ($subject)"; fail=1
  fi
  if ! git log -1 --format=%B "$c" | grep -qE "^Signed-off-by: .+ <${email//+/\\+}>\$"; then
    echo "FAIL dco: $c has no Signed-off-by for $email ($subject)"; fail=1
  fi
done
echo "dco: $n commit(s) since $base"
exit "$fail"
