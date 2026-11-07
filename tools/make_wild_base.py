"""Wild base v5: rect-erase rider/tack + interpolated barrel + upward leg regrowth.
R = rider zone (x 26-74, y 0-58). Legs re-enter R only by growing up from
bright seeds below the belly line (y>=62). Hooves: dark, only near bright.
Bridles/reins: elongated dark components removed. Boot: dark, no bright path."""
import sys, colorsys
from PIL import Image

RX0, RY0, RX1, RY1 = 26, 0, 74, 58     # rider zone
BELLY_SEED_Y = 62                       # leg seeds live below this

def rebuild(anim, frame, out_base=None, out_mask=None):
    src = Image.open(f"art/player/{anim}/frame_{frame}.png").convert("RGBA")
    mask = Image.open(f"art/horse_masks/{anim}/frame_{frame}.png").convert("RGBA")
    w, h = src.size
    px, mk = src.load(), mask.load()

    def lum(c): return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]
    def hsl(c): return colorsys.rgb_to_hls(c[0] / 255, c[1] / 255, c[2] / 255)

    # coat reference from trusted body pixels outside R
    hues = []
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0 or max(mk[x, y][0], mk[x, y][1]) < 6:
                continue
            if RX0 <= x <= RX1 and RY0 <= y <= RY1:
                continue
            hh, ll, ss = hsl(px[x, y])
            if ss > 0.3 and 80 < lum(px[x, y]):
                hues.append(hh * 360)
    hues.sort()
    med_hue = hues[len(hues) // 2] if hues else 26.0

    def cls(c):
        hh, ll, ss = hsl(c); l = lum(c)
        dh = min(abs(hh * 360 - med_hue), 360 - abs(hh * 360 - med_hue))
        if l < 70: return "dark"
        if l > 195 and ss < 0.22: return "white"
        if ss > 0.3 and dh <= 16 and l <= 235: return "coat"
        return "other"

    # eraser leftovers in the source art: near-transparent junk becomes truly
    # transparent so it never seeds growth, fills or shows up in the base
    for y in range(h):
        for x in range(w):
            if 0 < px[x, y][3] < 64 and max(mk[x, y][0], mk[x, y][1]) < 6:
                px[x, y] = (0, 0, 0, 0)

    kept = {}
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0:
                continue
            in_r = RX0 <= x <= RX1 and RY0 <= y <= RY1
            covered = max(mk[x, y][0], mk[x, y][1]) >= 6
            if covered or not in_r:
                kept[(x, y)] = True

    # -- barrel reconstruction inside R --------------------------------------
    def is_body(x, y):
        return kept.get((x, y)) and mk[x, y][0] >= mk[x, y][1]
    band_l = [y for x in range(max(0, RX0 - 8), RX0) for y in range(28, h) if kept.get((x, y))]
    bl_l = [y for x in range(max(0, RX0 - 8), RX0) for y in range(h) if is_body(x, y)]
    t0 = min(band_l) if band_l else 34
    b0 = max(bl_l) if bl_l else 60
    for x in range(RX0, RX1 + 1):
        f = (x - RX0) / max(1, RX1 - RX0)
        ty = round(t0 - 4 * f)          # the back is nearly flat, slight rise to the neck
        by = min(b0, 61)                # belly is roughly horizontal
        # nearest-coat copy: the closest real barrel pixel (2D) becomes the
        # fill colour, so local shading and dithering carry over naturally
        for y in range(ty, by + 1):
            if kept.get((x, y)) and cls(px[x, y]) != "other":
                continue
            c = None
            for d in range(1, 16):
                for xx, yy in ((x - d, y), (x + d, y), (x - d, y - 1), (x + d, y - 1),
                               (x - d, y + 1), (x + d, y + 1)):
                    if 0 <= xx < w and 0 <= yy < h and is_body(xx, yy) and cls(px[xx, yy]) == "coat":
                        c = px[xx, yy][:3]
                        break
                if c:
                    break
            if c is None:
                continue
            px[x, y] = (c[0], c[1], c[2], 255)
            mk[x, y] = (255, 0, 0, 255)
            kept[(x, y)] = True
        # outline row on the new topline
        for yy in (ty, ty - 1):
            if 0 <= yy < h and not kept.get((x, yy)):
                px[x, yy] = (74, 52, 40, 255)
                mk[x, yy] = (255, 0, 0, 255)
                kept[(x, yy)] = True

    # -- everything above the body line that is not mask-covered is rider -----
    for y in range(0, 30):
        for x in range(w):
            if max(mk[x, y][0], mk[x, y][1]) < 6:
                kept.pop((x, y), None)
                px[x, y] = (0, 0, 0, 0)

    # -- erase whatever rider/tack remains inside R ---------------------------
    for y in range(RY0, RY1 + 1):
        for x in range(RX0, RX1 + 1):
            if not kept.get((x, y)):
                px[x, y] = (0, 0, 0, 0)
    # below R only legs/socks/hooves may live: drop jeans/blanket blue and
    # shirt/skin colours (blue reads as "dark" at low luminance, so test hue)
    for y in range(RY1 + 1, 66):
        for x in range(RX0, RX1 + 1):
            if kept.get((x, y)) and px[x, y][3] > 0 and max(mk[x, y][0], mk[x, y][1]) < 6:
                c = px[x, y]
                hh, ll, ss = hsl(c)
                bluish = c[2] > c[0] + 20 and ss > 0.25
                if cls(c) == "other" or bluish:
                    kept.pop((x, y), None)
                    px[x, y] = (0, 0, 0, 0)

    # -- regrow legs upward from bright seeds below the belly -----------------
    changed = True
    while changed:
        changed = False
        for y in range(h - 1, -1, -1):
            for x in range(w):
                if kept.get((x, y)) or px[x, y][3] == 0 or max(mk[x, y][0], mk[x, y][1]) >= 6:
                    continue
                k = cls(px[x, y])
                if k == "other":
                    continue
                for dx, dy in ((0, 1), (1, 0), (-1, 0), (0, -1)):
                    if not kept.get((x + dx, y + dy)):
                        continue
                    nb = px[x + dx, y + dy]
                    if lum(nb) < 70:
                        continue  # growth only flows from bright pixels
                    if k == "dark":
                        continue  # hooves handled below
                    kept[(x, y)] = True
                    changed = True
                    break
    # hooves: dark pixels adjacent to a bright kept pixel
    changed = True
    while changed:
        changed = False
        for y in range(h):
            for x in range(w):
                if kept.get((x, y)) or px[x, y][3] == 0 or max(mk[x, y][0], mk[x, y][1]) >= 6:
                    continue
                if cls(px[x, y]) != "dark":
                    continue
                ok = False
                for dx in range(-2, 3):
                    for dy in range(-2, 3):
                        if kept.get((x + dx, y + dy)) and lum(px[x + dx, y + dy]) >= 70:
                            ok = True
                if ok:
                    kept[(x, y)] = True
                    changed = True

    # -- bridle/rein removal: thin elongated dark components ------------------
    seen = {}
    for y in range(h):
        for x in range(w):
            if not kept.get((x, y)) or seen.get((x, y)):
                continue
            if cls(px[x, y]) != "dark" or max(mk[x, y][0], mk[x, y][1]) >= 6:
                continue
            comp = [(x, y)]; seen[(x, y)] = True; stack = [(x, y)]
            while stack:
                cx, cy = stack.pop()
                for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
                    nx, ny = cx + dx, cy + dy
                    if (kept.get((nx, ny)) and not seen.get((nx, ny)) and px[nx, ny][3] > 0
                            and cls(px[nx, ny]) == "dark" and max(mk[nx, ny][0], mk[nx, ny][1]) < 6):
                        seen[(nx, ny)] = True; comp.append((nx, ny)); stack.append((nx, ny))
            xs = [c[0] for c in comp]; ys = [c[1] for c in comp]
            bw, bh = max(xs) - min(xs) + 1, max(ys) - min(ys) + 1
            if len(comp) < 40 and max(bw, bh) >= 3 * min(bw, bh) and min(bw, bh) <= 3:
                for c in comp:
                    kept.pop(c, None)

    # -- boot removal: dark blobs in the boot box with no bright neighbour ----
    for y in range(54, 73):
        for x in range(40, 55):
            if not kept.get((x, y)) or px[x, y][3] == 0 or max(mk[x, y][0], mk[x, y][1]) >= 6:
                continue
            if cls(px[x, y]) != "dark":
                continue
            near = any(kept.get((x + dx, y + dy)) and cls(px[x + dx, y + dy]) == "white"
                       for dx in range(-2, 3) for dy in range(-2, 3))
            if near:
                continue
            if y < 68:
                kept.pop((x, y), None)
                px[x, y] = (0, 0, 0, 0)
            else:
                # below the belly only isolated dark tack survives removal;
                # real leg pixels always have coat pixels beside them
                coat_near = any(kept.get((x + dx, y + dy)) and cls(px[x + dx, y + dy]) == "coat"
                                for dx in range(-2, 3) for dy in range(-2, 3))
                if not coat_near:
                    kept.pop((x, y), None)
                    px[x, y] = (0, 0, 0, 0)

    # -- stirrup-leather sweep: mid-tone tack remnant under the belly --------
    # The boot is leather brown, classified "coat", so the dark-only passes
    # above skip it; it hangs at x46-59 below the belly fill, mask-free, and
    # recolors badly on light coats. Erase non-covered, non-bright pixels
    # there; keep hooves, which always sit next to a bright sock.
    for y in range(58, 76):
        for x in range(46, 60):
            if not kept.get((x, y)) or px[x, y][3] == 0:
                continue
            if max(mk[x, y][0], mk[x, y][1]) >= 6:
                continue  # real body/leg (mask-covered)
            if cls(px[x, y]) == "white":
                continue  # white sock
            near_bright = any(kept.get((x + dx, y + dy)) and cls(px[x + dx, y + dy]) == "white"
                              for dx in range(-3, 4) for dy in range(-3, 4))
            if near_bright:
                continue  # hoof beside a white sock
            kept.pop((x, y), None)
            px[x, y] = (0, 0, 0, 0)

    # -- component cleanup: drop small fragments detached from the body ------
    seen = {}
    comps = []
    for y in range(h):
        for x in range(w):
            if not kept.get((x, y)) or seen.get((x, y)):
                continue
            comp = [(x, y)]; seen[(x, y)] = True; stack = [(x, y)]
            while stack:
                cx, cy = stack.pop()
                for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
                    nx, ny = cx + dx, cy + dy
                    if kept.get((nx, ny)) and not seen.get((nx, ny)):
                        seen[(nx, ny)] = True; comp.append((nx, ny)); stack.append((nx, ny))
            comps.append(comp)
    comps.sort(key=len, reverse=True)
    for comp in comps[1:]:
        if len(comp) < 8:
            for (x, y) in comp:
                kept.pop((x, y), None)

    # -- final erase ----------------------------------------------------------
    for y in range(h):
        for x in range(w):
            if not kept.get((x, y)):
                px[x, y] = (0, 0, 0, 0)
    src.save(out_base or "/tmp/rebuilt_frame.png")
    mask.save(out_mask or "/tmp/rebuilt_mask.png")
    return src, mask

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "batch":
        import os
        for anim, count in (("walk_side", 12), ("idle", 6)):
            os.makedirs(f"art/world/wild_base/{anim}", exist_ok=True)
            os.makedirs(f"art/horse_masks/wild_{anim}", exist_ok=True)
            for i in range(count):
                rebuild(anim, f"{i:02d}",
                        f"art/world/wild_base/{anim}/frame_{i:02d}.png",
                        f"art/horse_masks/wild_{anim}/frame_{i:02d}.png")
            print(f"batch {anim}: {count} frames")
    else:
        frame = sys.argv[1] if len(sys.argv) > 1 else "00"
        anim = sys.argv[2] if len(sys.argv) > 2 else "walk_side"
        rebuild(anim, frame)
        print("saved")
