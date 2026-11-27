#!/usr/bin/env python3
# SPDX-License-Identifier: CERN-OHL-P-2.0
"""Overhang check on an STL in print orientation. Exit 1 on a down-facing slope over 45 deg,
or on a flat ceiling that is not a bridge: a ceiling with a hole in it (the ring round a
screw hole), or one with no wall under any edge. Real bridges are listed with their span."""
import math, struct, sys
from collections import defaultdict

def facets(path):
    data = open(path, 'rb').read()
    if data[:5] == b'solid' and b'facet' in data[:300]:
        v = []
        for line in data.decode().splitlines():
            t = line.split()
            if t and t[0] == 'vertex':
                v.append(tuple(map(float, t[1:4])))
                if len(v) == 3:
                    yield v
                    v = []
    else:
        n = struct.unpack('<I', data[80:84])[0]
        for i in range(n):
            o = 84 + i * 50
            f = struct.unpack('<12f', data[o:o + 48])
            yield [f[3:6], f[6:9], f[9:12]]

def key(p):
    return (round(p[0], 3), round(p[1], 3), round(p[2], 3))

def ceilings(tris, ceil_ids, zmin):
    """Group flat ceiling facets by height and connectivity, classify their boundary edges.
    An edge is anchored when the facet across it runs down (a wall below holds it), free when
    it runs up (a hole continues above). A boundary loop that is free all round is a hole in
    the ceiling, which no bridge can span."""
    edge_f = defaultdict(list)
    for i, t in enumerate(tris):
        for a, b in ((0, 1), (1, 2), (2, 0)):
            edge_f[frozenset((key(t[a]), key(t[b])))].append(i)
    ceil = set(ceil_ids)
    seen, out = set(), []
    for s in ceil_ids:
        if s in seen:
            continue
        comp, stack = [], [s]
        seen.add(s)
        while stack:
            i = stack.pop()
            comp.append(i)
            t = tris[i]
            for a, b in ((0, 1), (1, 2), (2, 0)):
                for j in edge_f[frozenset((key(t[a]), key(t[b])))]:
                    if j in ceil and j not in seen and abs(tris[j][0][2] - t[0][2]) < 1e-3:
                        seen.add(j)
                        stack.append(j)
        z = tris[comp[0]][0][2]
        cs = set(comp)
        bnd = {}
        for i in comp:
            t = tris[i]
            for a, b in ((0, 1), (1, 2), (2, 0)):
                e = frozenset((key(t[a]), key(t[b])))
                if len(e) < 2:
                    continue
                others = [j for j in edge_f[e] if j not in cs]
                if not others:
                    continue
                dz = 0.0
                for j in others:
                    for p in tris[j]:
                        if key(p) not in e:
                            dz = p[2] - z if abs(p[2] - z) > abs(dz) else dz
                bnd[e] = dz < -1e-4
        adj = defaultdict(list)
        for e in bnd:
            if len(e) < 2:
                continue
            u, v = tuple(e)
            adj[u].append(e)
            adj[v].append(e)
        done, loops = set(), []
        for e0 in bnd:
            if e0 in done:
                continue
            loop, st = [], [e0]
            done.add(e0)
            while st:
                e = st.pop()
                loop.append(e)
                for p in e:
                    for f in adj[p]:
                        if f not in done:
                            done.add(f)
                            st.append(f)
            loops.append(loop)
        pts = [p for i in comp for p in tris[i]]
        xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
        area = sum(tri_area(tris[i]) for i in comp)
        hole = any(not any(bnd[e] for e in lp) for lp in loops) and any(any(bnd[e] for e in lp) for lp in loops)
        floating = not any(bnd.values())
        out.append((z - zmin, min(xs), max(xs), min(ys), max(ys), area, hole, floating))
    return out

def tri_area(t):
    u = [t[1][i] - t[0][i] for i in range(3)]
    w = [t[2][i] - t[0][i] for i in range(3)]
    n = [u[1] * w[2] - u[2] * w[1], u[2] * w[0] - u[0] * w[2], u[0] * w[1] - u[1] * w[0]]
    return math.sqrt(sum(x * x for x in n)) / 2

def main(path, limit=45.0):
    tris = list(facets(path))
    zmin = min(p[2] for f in tris for p in f)
    cos_l = math.cos(math.radians(limit))
    slopes, ceil_ids = [], []
    for i, (a, b, c) in enumerate(tris):
        u = [b[k] - a[k] for k in range(3)]
        w = [c[k] - a[k] for k in range(3)]
        n = [u[1] * w[2] - u[2] * w[1], u[2] * w[0] - u[0] * w[2], u[0] * w[1] - u[1] * w[0]]
        ln = math.sqrt(sum(x * x for x in n))
        if ln < 1e-12:
            continue
        nz = n[2] / ln
        if nz >= -cos_l - 1e-3:
            continue
        if max(a[2], b[2], c[2]) <= zmin + 0.01:
            continue
        if nz < -0.9999:
            ceil_ids.append(i)
        else:
            ang = math.degrees(math.acos(-nz))
            slopes.append((90 - ang, min(a[2], b[2], c[2]) - zmin, ln / 2))
    bad = 0
    for z, x0, x1, y0, y1, ar, hole, fl in sorted(ceilings(tris, ceil_ids, zmin)):
        if ar < 0.05:
            continue
        tag = "HOLE IN CEILING" if hole else "FLOATING" if fl else "bridge"
        if hole or fl:
            bad += 1
        print(f"{tag} z={z:.2f} at x {x0:.1f}..{x1:.1f} y {y0:.1f}..{y1:.1f} span {min(x1 - x0, y1 - y0):.1f} area {ar:.1f}")
    tot = sum(s[2] for s in slopes)
    print(f"sloped overhangs over {limit:.0f} deg: {len(slopes)} facets, {tot:.2f} mm2")
    for s in sorted(slopes, key=lambda s: -s[2])[:8]:
        print(f"  overhang {s[0]:.1f} deg from vertical at z={s[1]:.2f} area {s[2]:.3f}")
    return 1 if tot > 0.5 or bad else 0

if __name__ == '__main__':
    sys.exit(main(sys.argv[1]))
