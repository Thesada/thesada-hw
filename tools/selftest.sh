#!/usr/bin/env bash
# Each repo check must fail on a seeded bad input and pass the clean one, else this fails.
# Seeds are built from pieces so this file does not trip the sanitize scan itself.
set -euo pipefail
: "${OPENSCAD:?OPENSCAD not set, run through make}"
root="$(pwd -P)"; case_dir="$root/enclosure/node"; work="$root/build/selftest"
rm -rf "$work"; mkdir -p "$work"
fails=0
expect() { # expect <pass|fail> <name> <cmd...>
  local want="$1" name="$2"; shift 2
  if "$@" >"$work/$name.log" 2>&1; then got=pass; else got=fail; fi
  if [ "$got" = "$want" ]; then echo "ok   $name ($got)"; else echo "BAD  $name: wanted $want, got $got"; cat "$work/$name.log"; fails=1; fi
}
scad() { (cd "$case_dir" && $OPENSCAD --backend=manifold --quiet --export-format binstl -D 'part="gasket"' "$@" node-case.scad); }
has() { grep -q "$1" "$work/$2.log"; }

# OpenSCAD: a failing assert fails the render
expect pass assert-clean scad -o "$work/gasket.stl"
expect fail assert-seeded scad -D wall=1 -o "$work/gasket-wall1.stl"
has 'walls under 2 mm' assert-seeded || { echo "BAD  assert-seeded failed for another reason"; fails=1; }

# STL freshness: a render with other parameters is stale, a reordered copy is not
mkdir -p "$work/fresh" "$work/stale" "$work/shuffled"
cp "$work/gasket.stl" "$work/fresh/gasket.stl"
scad -D tpu_shore=85 -o "$work/stale/gasket.stl" >/dev/null 2>&1
python3 - "$work/fresh/gasket.stl" "$work/shuffled/gasket.stl" <<'PY'
import sys
d = open(sys.argv[1], "rb").read()
t = [d[84 + 50 * i:134 + 50 * i] for i in range((len(d) - 84) // 50)]
open(sys.argv[2], "wb").write(d[:84] + b"".join(reversed(t)))
PY
expect pass fresh-clean python3 tools/stl_compare.py "$work/fresh" "$case_dir/stl" gasket.stl
expect pass fresh-shuffled python3 tools/stl_compare.py "$work/fresh" "$work/shuffled" gasket.stl
expect fail fresh-stale python3 tools/stl_compare.py "$work/fresh" "$work/stale" gasket.stl

# Overhang: a floating ceiling fails, the committed gasket passes
python3 - "$work/float.stl" <<'PY'
import struct, sys
tris = [((0, 0, 10), (0, 10, 10), (10, 0, 10)), ((0, 0, 0), (10, 0, 0), (0, 10, 0))]
with open(sys.argv[1], "wb") as f:
    f.write(b"\0" * 80 + struct.pack("<I", len(tris)))
    for t in tris:
        f.write(struct.pack("<12fH", 0, 0, 0, *[c for v in t for c in v], 0))
PY
expect pass overhang-clean python3 "$case_dir/check_overhang.py" "$case_dir/stl/gasket.stl"
expect fail overhang-seeded python3 "$case_dir/check_overhang.py" "$work/float.stl"

# DCO and sanitize in a scratch repo
repo="$work/repo"; mkdir -p "$repo"; cd "$repo"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
ok_mail="65317274+dhumpf@users.noreply.github.com"
git init -q -b main . && git config user.name dhumpf && git config user.email "$ok_mail"
git commit -q --allow-empty -m base && git tag base
echo clean > clean.txt && git add clean.txt && git commit -q -s -m "chore: clean"
expect pass dco-clean "$root/tools/check-dco.sh" base "$ok_mail"
expect pass sanitize-clean python3 "$root/tools/sanitize.py" base
git commit -q --allow-empty -m "chore: no sign-off"
expect fail dco-unsigned "$root/tools/check-dco.sh" base "$ok_mail"
git reset -q --hard HEAD~1
git -c user.email=someone@example.com commit -q --allow-empty -s -m "chore: other author"
expect fail dco-author "$root/tools/check-dco.sh" base "$ok_mail"
git reset -q --hard HEAD~1

d=Develop; a=anth
seeds=(
  "private IP|host 10.2$(printf .)3.4"
  "internal host|see git$(printf .)o""ps.example$(printf .)ca"
  "local path|/Us""ers/someone/$d""ment/x"
  "private key|-----BEGIN RSA PRIVATE ""KEY-----"
  "token shape|ghp_$(printf 'a%.0s' {1..36})"
  "secret assignment|pass""word = hunter2hunter2xx"
  "AI trace|Co-Authored""-By: bot <noreply@$a""ropic.com>"
)
for s in "${seeds[@]}"; do
  label="${s%%|*}"; line="${s#*|}"; name="sanitize-${label// /-}"
  printf '%s\n' "$line" > seed.txt && git add seed.txt && git commit -q -s -m "chore: seed"
  expect fail "$name" python3 "$root/tools/sanitize.py" base
  has "\[$label\]" "$name" || { echo "BAD  $name did not name [$label]"; fails=1; }
  git reset -q --hard HEAD~1
done
git commit -q --allow-empty -s -m "chore: seed" -m "Generated with Clau""de Code"
expect fail sanitize-commit-message python3 "$root/tools/sanitize.py" base

cd "$root"
[ "$fails" = 0 ] && echo "selftest: every check fires" || { echo "selftest: FAILED"; exit 1; }
