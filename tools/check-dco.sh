#!/usr/bin/env bash
# usage: tools/check-dco.sh <base> <email>. Every non-merge commit in base..HEAD is
# authored as <email> and carries a Signed-off-by trailer with exactly that address.
set -euo pipefail
base="$1"; email="$2"
git rev-parse --verify -q "$base^{commit}" >/dev/null || { echo "FAIL dco: base $base not found, fetch it"; exit 1; }
commits="$(git rev-list --no-merges "$base..HEAD")" || { echo "FAIL dco: cannot list $base..HEAD"; exit 1; }
fail=0; n=0
for c in $commits; do
  n=$((n + 1))
  author="$(git log -1 --format=%ae "$c")"
  subject="$(git log -1 --format=%s "$c")"
  if [ "$author" != "$email" ]; then
    echo "FAIL dco: $c author $author, want $email ($subject)"; fail=1
  fi
  signed=0
  while IFS= read -r v; do
    addr="${v##*<}"; addr="${addr%>}"
    [ "$v" != "$addr" ] && [ "$addr" = "$email" ] && signed=1
  done < <(git log -1 --format='%(trailers:key=Signed-off-by,valueonly,unfold)' "$c")
  if [ "$signed" = 0 ]; then
    echo "FAIL dco: $c has no Signed-off-by trailer for $email ($subject)"; fail=1
  fi
done
echo "dco: $n commit(s) since $base"
exit "$fail"
