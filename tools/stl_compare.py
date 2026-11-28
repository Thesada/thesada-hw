#!/usr/bin/env python3
"""usage: stl_compare.py <fresh-dir> <committed-dir> <name.stl>...

Exit 1 when a committed STL is not the geometry a fresh render gives. OpenSCAD
output is not byte-stable (triangle order and planar triangulation vary between
runs and hosts), so this compares geometry: bounding box, volume, surface area
and the vertex set, each within TOL mm.
"""
import math
import struct
import sys

TOL = 1e-3


def load(path):
    with open(path, "rb") as fh:
        data = fh.read()
    if len(data) < 84:
        raise ValueError(f"{path}: not a binary STL")
    n = struct.unpack_from("<I", data, 80)[0]
    if len(data) != 84 + 50 * n:
        raise ValueError(f"{path}: binary STL size does not match {n} triangles")
    return [struct.unpack_from("<9f", data, 84 + 50 * i + 12) for i in range(n)]


def stats(tris):
    vol = area = 0.0
    lo = [math.inf] * 3
    hi = [-math.inf] * 3
    verts = set()
    for t in tris:
        a, b, c = t[0:3], t[3:6], t[6:9]
        for p in (a, b, c):
            verts.add(p)
            for k in range(3):
                lo[k] = min(lo[k], p[k])
                hi[k] = max(hi[k], p[k])
        u = [b[k] - a[k] for k in range(3)]
        v = [c[k] - a[k] for k in range(3)]
        cr = (u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0])
        area += 0.5 * math.sqrt(sum(x * x for x in cr))
        vol += (a[0] * (b[1] * c[2] - b[2] * c[1]) - a[1] * (b[0] * c[2] - b[2] * c[0])
                + a[2] * (b[0] * c[1] - b[1] * c[0])) / 6.0
    return vol, area, lo, hi, verts


def grid(verts):
    cells = {}
    for p in verts:
        cells.setdefault(tuple(math.floor(x / TOL) for x in p), []).append(p)
    return cells


def missing(src, dst_cells):
    """Vertices of src with no vertex of dst within TOL on every axis."""
    out = 0
    for p in src:
        c = [math.floor(x / TOL) for x in p]
        near = (q for dx in (-1, 0, 1) for dy in (-1, 0, 1) for dz in (-1, 0, 1)
                for q in dst_cells.get((c[0] + dx, c[1] + dy, c[2] + dz), ()))
        if not any(all(abs(p[k] - q[k]) <= TOL for k in range(3)) for q in near):
            out += 1
    return out


def compare(fresh, committed):
    fv, fa, flo, fhi, fverts = stats(load(fresh))
    cv, ca, clo, chi, cverts = stats(load(committed))
    why = []
    if any(abs(x - y) > TOL for x, y in zip(flo + fhi, clo + chi)):
        why.append(f"bounding box {flo}..{fhi} vs {clo}..{chi}")
    if abs(fv - cv) > max(TOL, 1e-6 * abs(cv)):
        why.append(f"volume {fv:.4f} vs {cv:.4f}")
    if abs(fa - ca) > max(TOL, 1e-6 * abs(ca)):
        why.append(f"area {fa:.4f} vs {ca:.4f}")
    m1 = missing(fverts, grid(cverts))
    m2 = missing(cverts, grid(fverts))
    if m1 or m2:
        why.append(f"{m1} fresh vertices not in the committed file, {m2} the other way")
    return why


def main(argv):
    if len(argv) < 3:
        sys.exit(__doc__)
    fresh_dir, committed_dir, names = argv[0], argv[1], argv[2:]
    bad = 0
    for name in names:
        try:
            why = compare(f"{fresh_dir}/{name}", f"{committed_dir}/{name}")
        except (OSError, ValueError) as e:
            why = [str(e)]
        if why:
            bad += 1
            print(f"STALE {committed_dir}/{name}: " + "; ".join(why))
    print(f"stl freshness: {len(names) - bad}/{len(names)} match")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
