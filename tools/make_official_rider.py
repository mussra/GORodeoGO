#!/usr/bin/env python3
"""Builds art/world/rider/<hat>/<dir>.png (96x96 transparent overlays) from the
approved phase-2 cuts (/downloads/phase2_rider/). Official rider = menu art
(Ant 8-nov 13:04); hat variants follow HatAppearance OPTIONS colors.
Geometry = the recipe Ant approved in comp_oficial_5dirs.png:
side h=48 at (32,0); down/up/diag_down/diag_up widths 34/34/40/38 centered,
bottom anchored at y=50."""
import colorsys
import os
from PIL import Image

SRC = "/downloads/phase2_rider"
OUT = "art/world/rider"
CELL = 96
RECIPE = {  # dir -> (source file, target width or None for height rule)
    "side": ("side_official.png", None, 48),       # height=48, x=32
    "down": ("down_v1.png", 34, None),
    "up": ("up_v1.png", 34, None),
    "diag_down": ("diag_down_v1.png", 40, None),
    "diag_up": ("diag_up_v1.png", 38, None),
}
HATS = {"original": None, "blue": (0x41, 0x5c, 0x81), "sand": (0xc8, 0xb9, 0x94)}
BOTTOM_Y = 50  # boot soles for non-side dirs (side rider already spans 0..48)


def hat_target_hls(rgb):
    r, g, b = [c / 255.0 for c in rgb]
    h, l, s = colorsys.rgb_to_hls(r, g, b)
    return h, s


def recolor_hat(cell: Image.Image, rgb) -> Image.Image:
    """Shift hue/sat of hat pixels (brown tones in the top region) to the hat
    color, keeping luminance so the shading survives."""
    th, ts = hat_target_hls(rgb)
    im = cell.copy()
    px = im.load()
    hat_zone_bottom = 24  # hat lives in the top ~half of the 48-52px rider
    for y in range(hat_zone_bottom):
        for x in range(CELL):
            r, g, b, a = px[x, y]
            if a < 128:
                continue
            rf, gf, bf = r / 255.0, g / 255.0, b / 255.0
            h, l, s = colorsys.rgb_to_hls(rf, gf, bf)
            # brown hat: warm hue, moderate saturation; skip gold concho (very
            # saturated bright) and skin (lower saturation, higher red)... keep
            # it simple: hat browns have 0.06<=h<=0.13 and s>=0.35 and l<=0.62
            if 0.055 <= h <= 0.14 and s >= 0.35 and l <= 0.62:
                nr, ng, nb = colorsys.hls_to_rgb(th, l, ts)
                px[x, y] = (int(nr * 255), int(ng * 255), int(nb * 255), a)
    return im


def main() -> None:
    for hat, rgb in HATS.items():
        os.makedirs(f"{OUT}/{hat}", exist_ok=True)
    for d, (fname, width, height) in RECIPE.items():
        im = Image.open(f"{SRC}/{fname}").convert("RGBA")
        im = im.crop(im.getbbox())
        if height is not None:
            w = round(im.size[0] * height / im.size[1])
            im = im.resize((w, height), Image.LANCZOS)
            ox, oy = 32, 0
        else:
            h = round(im.size[1] * width / im.size[0])
            im = im.resize((width, h), Image.LANCZOS)
            ox = (CELL - width) // 2
            oy = BOTTOM_Y - h
        cell = Image.new("RGBA", (CELL, CELL), (0, 0, 0, 0))
        cell.paste(im, (ox, oy), im)
        for hat, rgb in HATS.items():
            out = cell if rgb is None else recolor_hat(cell, rgb)
            out.save(f"{OUT}/{hat}/{d}.png")
    print("wrote", OUT)


if __name__ == "__main__":
    main()
