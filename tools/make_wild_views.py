"""Wild horse directional views from Ant's reference sheet (7-nov-2026):
extracts frente/espalda/3-4 views, removes the bridle, scales to the 96x96
game canvas (hooves at y=74 like the side bases) and writes recolor masks
(red=coat, green=mane/tail, black=untouched) matching art/horse_masks."""
import sys, os, colorsys, pickle
from PIL import Image

SHEETS = {
    "down": ("/downloads/image-93928fac.jpg", (53, 47, 171, 323), 60 / 296),
    "up": ("/downloads/image-93928fac.jpg", (612, 43, 752, 326), 60 / 296),
    "diag_down": ("/downloads/image-ae2ae1e2.jpg", (14, 52, 244, 289), 60 / 238),
    "diag_up": ("/downloads/image-ae2ae1e2.jpg", (284, 51, 492, 291), 60 / 238),
    "side": ("/downloads/image-93928fac.jpg", (236, 34, 537, 327), 60 / 296),
}
# bridle strap polygons in source-crop coords + eye exclusion boxes
BRIDLE = {
    "down": {"polys": [[(16, 38), (32, 38), (30, 112), (18, 112)],
                       [(88, 38), (104, 40), (102, 112), (90, 112)],
                       [(24, 100), (96, 100), (96, 122), (24, 122)]],
             "eyes": []},
    "up": {"polys": [], "eyes": []},
    "diag_down": {"polys": [[(128, 18), (152, 14), (186, 70), (172, 84)],
                            [(158, 66), (210, 70), (212, 92), (160, 92)]],
                  "eyes": [(172, 40, 200, 70)]},
    "diag_up": {"polys": [[(124, 20), (144, 16), (166, 78), (152, 90)],
                          [(144, 68), (182, 70), (184, 96), (146, 96)]],
                "eyes": [(136, 40, 158, 62)]},
    "side": {"polys": [[(230, 38), (244, 42), (256, 88), (242, 92)],
                       [(248, 78), (296, 88), (294, 104), (246, 94)],
                       [(252, 96), (268, 100), (266, 116), (252, 112)]],
             "eyes": [(224, 54, 248, 84)]},
}

def lum(c): return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]
def hsl(c): return colorsys.rgb_to_hls(c[0] / 255, c[1] / 255, c[2] / 255)

def in_poly(x, y, poly):
    inside = False
    j = len(poly) - 1
    for i in range(len(poly)):
        xi, yi = poly[i]; xj, yj = poly[j]
        if (yi > y) != (yj > y) and x < (xj - xi) * (y - yi) / (yj - yi) + xi:
            inside = not inside
        j = i
    return inside

def extract(path, bg, box):
    img = Image.open(path).convert("RGBA")
    x0, y0, x1, y1 = box
    w, h = x1 - x0 + 1, y1 - y0 + 1
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    px, opx = img.load(), out.load()
    for y in range(h):
        for x in range(w):
            if not bg[y0 + y][x0 + x]:
                opx[x, y] = px[x0 + x, y0 + y]
    return out

def halo_clean(img):
    w, h = img.size; px = img.load()
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0: continue
            edge = any(0 <= x + dx < w and 0 <= y + dy < h and px[x + dx, y + dy][3] == 0
                       for dx in (-1, 0, 1) for dy in (-1, 0, 1))
            if edge:
                r, g, b, a = px[x, y]
                if max(r, g, b) - min(r, g, b) < 30 and max(r, g, b) > 130:
                    px[x, y] = (0, 0, 0, 0)
    return img

def remove_bridle(img, cfg):
    w, h = img.size; px = img.load()
    erased = set()
    for poly in cfg["polys"]:
        xs = [p[0] for p in poly]; ys = [p[1] for p in poly]
        for y in range(max(0, min(ys) - 1), min(h, max(ys) + 2)):
            for x in range(max(0, min(xs) - 1), min(w, max(xs) + 2)):
                if px[x, y][3] == 0 or not in_poly(x, y, poly): continue
                if any(x >= ex0 and x <= ex1 and y >= ey0 and y <= ey1 for ex0, ey0, ex1, ey1 in cfg["eyes"]): continue
                edge = any(0 <= x + dx < w and 0 <= y + dy < h and px[x + dx, y + dy][3] == 0
                           for dx in (-1, 0, 1) for dy in (-1, 0, 1))
                if edge: continue  # keep silhouette outline
                c = px[x, y]
                if lum(c) < 95 and c[0] >= c[1] >= c[2] - 15:
                    erased.add((x, y))
    for (x, y) in erased:
        best = None
        for r in range(1, 15):
            for dy in range(-r, r + 1):
                for dx in range(-r, r + 1):
                    if max(abs(dx), abs(dy)) != r: continue
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < w and 0 <= ny < h and px[nx, ny][3] > 0 and (nx, ny) not in erased:
                        best = px[nx, ny]; break
                if best: break
            if best: break
        px[x, y] = best if best else (0, 0, 0, 0)
    return img

def place(img, scale, canvas=96, hoof_y=74):
    w, h = img.size
    nw, nh = max(1, round(w * scale)), max(1, round(h * scale))
    img = img.resize((nw, nh), Image.LANCZOS)
    px = img.load()
    for y in range(nh):
        for x in range(nw):
            if px[x, y][3] < 40: px[x, y] = (0, 0, 0, 0)
            else: px[x, y] = (px[x, y][0], px[x, y][1], px[x, y][2], 255)
    # hoof center = mean x of opaque pixels in the bottom 10 rows
    xs = []
    for y in range(nh - 10, nh):
        for x in range(nw):
            if px[x, y][3] > 0: xs.append(x)
    cx = sum(xs) / len(xs) if xs else nw / 2
    canv = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    canv.paste(img, (round(canvas / 2 - cx), hoof_y - nh))
    return canv

def make_mask(img):
    # Original-mask convention: interior coat red, interior blonde green,
    # everything else (dark outline, hooves, socks, blaze, eyes) black/untouched.
    w, h = img.size; px = img.load()
    mask = Image.new("RGB", (w, h), (0, 0, 0))
    mk = mask.load()
    for y in range(h):
        for x in range(w):
            if px[x, y][3] == 0: continue
            c = px[x, y]
            hh, ll, ss = hsl(c)
            chroma = (max(c[0], c[1], c[2]) - min(c[0], c[1], c[2]))
            if 0.105 < hh < 0.19 and chroma > 30 and 0.55 < ll < 0.93:
                mk[x, y] = (0, 255, 0)          # blonde mane/tail interior
            elif 0.03 < hh <= 0.105 and chroma > 40 and 0.30 < ll <= 0.78:
                mk[x, y] = (255, 0, 0)          # orange coat interior
    # despeckle: mane/coat are big blobs; drop isolated classified pixels
    for _ in range(2):
        drop = []
        for y in range(h):
            for x in range(w):
                if mk[x, y] == (0, 0, 0): continue
                same = sum(1 for dx in (-1, 0, 1) for dy in (-1, 0, 1)
                           if 0 <= x + dx < w and 0 <= y + dy < h and mk[x + dx, y + dy] == mk[x, y])
                if same < 2: drop.append((x, y))
        for (x, y) in drop: mk[x, y] = (0, 0, 0)
    return mask

if __name__ == "__main__":
    bgs = {}
    for name, (path, box, scale) in SHEETS.items():
        pkl = path.replace(".jpg", ".bg.pkl")
        if pkl not in bgs: bgs[pkl] = pickle.load(open(pkl, "rb"))
        img = extract(path, bgs[pkl], box)
        img = halo_clean(img)
        img = remove_bridle(img, BRIDLE[name])
        canv = place(img, scale)
        mask = make_mask(canv)
        os.makedirs(f"art/world/wild_base/{name}", exist_ok=True)
        os.makedirs(f"art/horse_masks/wild_{name}", exist_ok=True)
        canv.save(f"art/world/wild_base/{name}/frame_00.png")
        mask.save(f"art/horse_masks/wild_{name}/frame_00.png")
        print("built", name)
