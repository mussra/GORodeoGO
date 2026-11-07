#!/usr/bin/env python3
"""Riderless wild-horse base frames + extended masks (Ant 7-nov 12:00: use the
existing horse sprites). The recolor mask defines the horse's recolorable shape
and the runtime recolors everything kept by genetics, so this only fixes SHAPE:
  1. keep every mask-covered pixel (body, mane, legs, head);
  2. erase mask-black pixels in the rider zone (hat/torso/reins above the back);
  3. fill the barrel patch under the saddle: only originally-opaque runs bounded
     on both sides by body-masked pixels on the same row (never grows the
     silhouette), shaded from the nearest body pixel;
  4. 1px dark dilation restores outlines/hooves/eyes; everything else erased."""
import os
from PIL import Image

ANIMS = {"walk_side": 12, "idle": 6}
BASE_OUT = "art/world/wild_base"
MASK_OUT = "art/horse_masks"
RIDER_ZONE = (26, 0, 76, 37)   # x0, y0, x1, y1: hat, rider torso, reins
PATCH = (34, 38, 62, 62)       # barrel hidden under saddle/blanket/hanging leg

for anim, count in ANIMS.items():
    os.makedirs(f"{BASE_OUT}/{anim}", exist_ok=True)
    os.makedirs(f"{MASK_OUT}/wild_{anim}", exist_ok=True)
    for i in range(count):
        src = Image.open(f"art/player/{anim}/frame_{i:02d}.png").convert("RGBA")
        mask = Image.open(f"art/horse_masks/{anim}/frame_{i:02d}.png").convert("RGBA")
        w, h = src.size
        px, mk = src.load(), mask.load()
        rx0, ry0, rx1, ry1 = RIDER_ZONE
        x0, y0, x1, y1 = PATCH
        keep = {}
        for y in range(h):
            for x in range(w):
                if px[x, y][3] == 0:
                    continue
                if max(mk[x, y][0], mk[x, y][1]) >= 6:
                    keep[(x, y)] = True
                elif rx0 <= x <= rx1 and ry0 <= y <= ry1:
                    px[x, y] = (0, 0, 0, 0)  # rider above the back line
        # barrel inpaint: nearest body-masked pixel by euclidean distance
        # (radial interpolation, no row banding); pixels with no body anywhere
        # near are left for the erase pass.
        body_px = [(x, y) for y in range(h) for x in range(w)
                   if keep.get((x, y)) and mk[x, y][0] >= mk[x, y][1]]
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                if keep.get((x, y)):
                    continue
                best = None
                best_d = 1e9
                for (bx, by) in body_px:
                    d = (bx - x) * (bx - x) + (by - y) * (by - y)
                    if d < best_d:
                        best_d = d
                        best = (bx, by)
                if best is not None and best_d < 900:  # within 30px of real body
                    c = px[best[0], best[1]]
                    px[x, y] = (c[0], c[1], c[2], 255)
                    mk[x, y] = (255, 0, 0, 255)
                    keep[(x, y)] = True
                else:
                    px[x, y] = (0, 0, 0, 0)
        # dark-outline dilation (2 passes)
        for _ in range(2):
            add = {}
            for (x, y) in list(keep):
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < w and 0 <= ny < h and not keep.get((nx, ny)) and not add.get((nx, ny)):
                        if px[nx, ny][3] > 0 and max(px[nx, ny][0], px[nx, ny][1], px[nx, ny][2]) < 120:
                            add[(nx, ny)] = True
            for (x, y) in add:
                keep[(x, y)] = True
                if max(mk[x, y][0], mk[x, y][1]) < 6:
                    mk[x, y] = (40, 0, 0, 255)
        # connected-component cleanup: drop specks not joined to the horse
        seen = {}
        comps = []
        for y in range(h):
            for x in range(w):
                if not keep.get((x, y)) or seen.get((x, y)):
                    continue
                comp = [(x, y)]
                seen[(x, y)] = True
                stack = [(x, y)]
                while stack:
                    cx, cy = stack.pop()
                    for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
                        nx, ny = cx + dx, cy + dy
                        if keep.get((nx, ny)) and not seen.get((nx, ny)):
                            seen[(nx, ny)] = True
                            comp.append((nx, ny))
                            stack.append((nx, ny))
                comps.append(comp)
        comps.sort(key=len, reverse=True)
        for comp in comps[1:]:
            if len(comp) < 12:
                for (x, y) in comp:
                    keep.pop((x, y), None)
        n = 0
        for y in range(h):
            for x in range(w):
                if keep.get((x, y)):
                    n += 1
                else:
                    px[x, y] = (0, 0, 0, 0)
        src.save(f"{BASE_OUT}/{anim}/frame_{i:02d}.png")
        mask.save(f"{MASK_OUT}/wild_{anim}/frame_{i:02d}.png")
        if i == 0:
            print(anim, i, "kept", n)
print("done")
