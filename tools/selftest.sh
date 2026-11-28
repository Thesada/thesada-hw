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
[ -s "$work/stale/gasket.stl" ] || { echo "BAD  fresh-stale seed render wrote nothing"; fails=1; }
has '^STALE ' fresh-stale || { echo "BAD  fresh-stale failed for another reason"; fails=1; }

# Case Makefile: a render that writes nothing fails over a stale STL, fresh never compares stl/ with itself
mkdir -p "$work/mk" && printf 'stale' > "$work/mk/gasket.stl" && touch -t 200001010000 "$work/mk/gasket.stl"
expect fail stl-no-output make -s -C "$case_dir" OUT="$work/mk" OPENSCAD=true "$work/mk/gasket.stl"
expect fail fresh-self make -s -C "$case_dir" fresh
expect fail fresh-self-dot make -s -C "$case_dir" fresh OUT=./stl

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
# 2000 sloped facets of 0.00045 mm2 each add up to 0.9 mm2, over the 0.5 limit
python3 - "$work/tiny.stl" "$work/collapsed.stl" <<'PY'
import struct, sys
def write(path, tris):
    with open(path, "wb") as f:
        f.write(b"\0" * 80 + struct.pack("<I", len(tris)))
        for t in tris:
            f.write(struct.pack("<12fH", 0, 0, 0, *[c for v in t for c in v], 0))
floor = ((0, 0, 0), (100, 0, 0), (0, 100, 0))
write(sys.argv[1], [floor] + [((x * 0.1, 0, 5), (x * 0.1, 0.02, 5), (x * 0.1 + 0.04, 0, 5.02)) for x in range(2000)])
# a ceiling edge shorter than the 0.001 mm vertex key, shared with a wall
write(sys.argv[2], [floor, ((0, 0, 10), (0, 10, 10), (0.0004, 0, 10)), ((0, 0, 10), (0.0004, 0, 10), (0, 0, 0))])
PY
expect fail overhang-tiny-facets python3 "$case_dir/check_overhang.py" "$work/tiny.stl"
expect pass overhang-collapsed-edge python3 "$case_dir/check_overhang.py" "$work/collapsed.stl"
! has Traceback overhang-collapsed-edge || { echo "BAD  overhang-collapsed-edge crashed"; fails=1; }

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
git commit -q --allow-empty -m "chore: sign-off in the body" -m "Signed-off-by: dhumpf <$ok_mail>" -m "Not a trailer."
expect fail dco-body-signoff "$root/tools/check-dco.sh" base "$ok_mail"
git reset -q --hard HEAD~1
# a range git cannot list fails, it never counts as zero commits
fakebin="$work/fakebin"; mkdir -p "$fakebin"; realgit="$(command -v git)"
printf '#!/bin/sh\n[ "$1" = rev-list ] && exit 128\nexec "%s" "$@"\n' "$realgit" > "$fakebin/git"; chmod +x "$fakebin/git"
expect fail dco-rev-list env PATH="$fakebin:$PATH" "$root/tools/check-dco.sh" base "$ok_mail"

d=Develop
seeds=(
  "private IP|host 10.2$(printf .)3.4"
  "internal host|see git$(printf .)o""ps.example$(printf .)ca"
  "local path|/Us""ers/someone/$d""ment/x"
  "private key|-----BEGIN RSA PRIVATE ""KEY-----"
  "token shape|ghp_$(printf 'a%.0s' {1..36})"
  "secret assignment|pass""word = hunter2hunter2xx"
)
for s in "${seeds[@]}"; do
  label="${s%%|*}"; line="${s#*|}"; name="sanitize-${label// /-}"
  printf '%s\n' "$line" > seed.txt && git add seed.txt && git commit -q -s -m "chore: seed"
  expect fail "$name" python3 "$root/tools/sanitize.py" base
  has "\[$label\]" "$name" || { echo "BAD  $name did not name [$label]"; fails=1; }
  git reset -q --hard HEAD~1
done
git commit -q --allow-empty -s -m "chore: seed" -m "Reviewed-By: someone"
expect fail sanitize-trailer python3 "$root/tools/sanitize.py" base
has "\[trailer\]" sanitize-trailer || { echo "BAD  sanitize-trailer did not name [trailer]"; fails=1; }
git reset -q --hard HEAD~1
extra=$(mktemp); printf 'zzseedzz\n' > "$extra"
printf 'zzseedzz\n' > seed.txt && git add seed.txt && git commit -q -s -m "chore: seed"
SANITIZE_EXTRA="$extra" expect fail sanitize-extra python3 "$root/tools/sanitize.py" base
git reset -q --hard HEAD~1; rm -f "$extra"
# an added line that starts with ++ is content, not a file header; a quoted (non-ASCII) path is still scanned
secret="pass""word = hunter2hunter2xx"
printf '%s\n' "++ counter;" "$secret" > seed.c && git add seed.c && git commit -q -s -m "chore: seed"
expect fail sanitize-plusplus python3 "$root/tools/sanitize.py" base
has "\[secret assignment\]" sanitize-plusplus || { echo "BAD  sanitize-plusplus did not name [secret assignment]"; fails=1; }
git reset -q --hard HEAD~1
printf '%s\n' "$secret" > "caf$(printf '\303\251').txt" && git add . && git commit -q -s -m "chore: seed"
expect fail sanitize-quoted-path python3 "$root/tools/sanitize.py" base
has "\[secret assignment\]" sanitize-quoted-path || { echo "BAD  sanitize-quoted-path did not name [secret assignment]"; fails=1; }
git reset -q --hard HEAD~1
# a form feed inside an added line must not split it off from its "+" prefix
printf 'note\f%s\n' "$secret" > seed.txt && git add seed.txt && git commit -q -s -m "chore: seed"
expect fail sanitize-formfeed python3 "$root/tools/sanitize.py" base
has "\[secret assignment\]" sanitize-formfeed || { echo "BAD  sanitize-formfeed did not name [secret assignment]"; fails=1; }
git reset -q --hard HEAD~1
# same for a carriage return, which text-mode reads would turn into a newline
printf 'note\r%s\n' "$secret" > seed.txt && git add seed.txt && git commit -q -s -m "chore: seed"
expect fail sanitize-cr python3 "$root/tools/sanitize.py" base
has "\[secret assignment\]" sanitize-cr || { echo "BAD  sanitize-cr did not name [secret assignment]"; fails=1; }
git reset -q --hard HEAD~1

cd "$root"
[ "$fails" = 0 ] && echo "selftest: every check fires" || { echo "selftest: FAILED"; exit 1; }
