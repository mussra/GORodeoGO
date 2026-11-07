#!/usr/bin/env python3
"""Frontier sprite sheet generator (Ant 11:30): cartoon sprites with the game's
warm dark outlines and palette, replacing runtime code drawing. 4x supersample."""
from PIL import Image, ImageDraw
import json, math

OUTLINE = (43, 20, 16, 255)      # warm dark brown, from the horse art
TRUNK = (109, 74, 47, 255); TRUNK_D = (84, 56, 34, 255)
LEAF = (82, 139, 63, 255); LEAF_D = (63, 112, 49, 255); LEAF_L = (99, 158, 74, 255)
PINE = (56, 109, 59, 255); PINE_D = (44, 90, 48, 255)
ROCK = (155, 167, 178, 255); ROCK_D = (128, 140, 152, 255)
CACTUS = (62, 125, 70, 255); CACTUS_D = (50, 105, 58, 255)
FLOWER_P = (232, 106, 138, 255); FLOWER_C = (242, 217, 135, 255)
PIG = (242, 167, 184, 255); PIG_D = (227, 137, 157, 255); PIG_NOSE = (124, 67, 86, 255)
WOOD = (168, 122, 74, 255); WOOD_D = (138, 96, 56, 255); ROOF = (180, 69, 47, 255)
CREAM = (248, 237, 206, 255)

CELL = 200
S = 4  # supersample

def canvas():
    im = Image.new("RGBA", (CELL*S, CELL*S), (0,0,0,0))
    return im, ImageDraw.Draw(im)

def finish(im):
    return im.resize((CELL, CELL), Image.LANCZOS)

def ol_ellipse(d, box, fill, w=5):
    d.ellipse(box, fill=fill, outline=OUTLINE, width=w*S)

def ol_poly(d, pts, fill, w=5):
    d.polygon(pts, fill=fill, outline=OUTLINE, width=w*S)

def ol_rect(d, box, fill, w=5):
    d.rounded_rectangle(box, radius=8*S, fill=fill, outline=OUTLINE, width=w*S)

def tree():
    im, d = canvas()
    ol_rect(d, [88*S, 118*S, 112*S, 180*S], TRUNK)
    for cx, cy, r, col in [(64, 88, 46, LEAF_D), (136, 84, 42, LEAF_D), (100, 58, 54, LEAF)]:
        ol_ellipse(d, [(cx-r)*S, (cy-r)*S, (cx+r)*S, (cy+r)*S], col)
    d.ellipse([72*S, 34*S, 104*S, 62*S], fill=LEAF_L)  # highlight
    return finish(im)

def pine():
    im, d = canvas()
    ol_rect(d, [92*S, 138*S, 108*S, 178*S], TRUNK_D)
    for pts, col in [([(100,28),(54,98),(146,98)], PINE), ([(100,58),(42,138),(158,138)], PINE_D)]:
        ol_poly(d, [(x*S, y*S) for x, y in pts], col)
    return finish(im)

def fruit_tree():
    im, d = canvas()
    ol_rect(d, [88*S, 118*S, 112*S, 180*S], TRUNK)
    for cx, cy, r, col in [(66, 90, 44, LEAF_D), (134, 86, 40, LEAF_D), (100, 60, 52, LEAF)]:
        ol_ellipse(d, [(cx-r)*S, (cy-r)*S, (cx+r)*S, (cy+r)*S], col)
    for ax, ay in [(72, 66), (122, 52), (104, 92), (140, 84)]:
        ol_ellipse(d, [(ax-9)*S, (ay-9)*S, (ax+9)*S, (ay+9)*S], (217, 79, 61, 255), 3)
    return finish(im)

def bush():
    im, d = canvas()
    for cx, cy, r, col in [(72, 132, 34, LEAF_D), (124, 128, 38, LEAF_D), (98, 106, 34, LEAF)]:
        ol_ellipse(d, [(cx-r)*S, (cy-r)*S, (cx+r)*S, (cy+r)*S], col)
    return finish(im)

def rock():
    im, d = canvas()
    ol_poly(d, [(x*S, y*S) for x, y in [(46,160),(56,102),(100,74),(150,96),(158,160)]], ROCK)
    ol_poly(d, [(x*S, y*S) for x, y in [(56,102),(100,74),(150,96),(104,118)]], ROCK_D, 3)
    return finish(im)

def cactus():
    im, d = canvas()
    ol_rect(d, [82*S, 40*S, 118*S, 180*S], CACTUS)
    ol_rect(d, [40*S, 92*S, 82*S, 122*S], CACTUS_D)
    ol_rect(d, [40*S, 62*S, 66*S, 122*S], CACTUS_D)
    ol_rect(d, [118*S, 76*S, 158*S, 106*S], CACTUS_D)
    ol_rect(d, [132*S, 48*S, 158*S, 106*S], CACTUS_D)
    return finish(im)

def flower():
    im, d = canvas()
    for fx, fy in [(70, 110), (126, 92), (100, 140)]:
        d.line([fx*S, (fy+8)*S, fx*S, (fy+44)*S], fill=CACTUS, width=4*S)
        for p in range(5):
            a = p*math.tau/5
            px, py = fx+math.cos(a)*16, fy+math.sin(a)*16
            ol_ellipse(d, [(px-11)*S, (py-11)*S, (px+11)*S, (py+11)*S], FLOWER_P, 3)
        ol_ellipse(d, [(fx-9)*S, (fy-9)*S, (fx+9)*S, (fy+9)*S], FLOWER_C, 3)
    return finish(im)

def house():
    im, d = canvas()
    ol_rect(d, [40*S, 88*S, 160*S, 172*S], WOOD)
    ol_poly(d, [(x*S, y*S) for x, y in [(28,92),(100,36),(172,92)]], ROOF)
    ol_rect(d, [88*S, 120*S, 116*S, 172*S], WOOD_D)      # door
    ol_rect(d, [52*S, 104*S, 78*S, 128*S], CREAM)        # window
    return finish(im)

def board():
    im, d = canvas()
    ol_rect(d, [94*S, 96*S, 106*S, 178*S], TRUNK_D)      # post
    ol_rect(d, [42*S, 36*S, 158*S, 104*S], WOOD)         # panel
    for i, w_ in enumerate([96, 76, 88]):
        d.line([58*S, (54+i*16)*S, (58+w_)*S, (54+i*16)*S], fill=OUTLINE, width=5*S)
    return finish(im)

def pig():
    im, d = canvas()
    ol_ellipse(d, [40*S, 76*S, 140*S, 156*S], PIG)                       # body
    ol_ellipse(d, [116*S, 66*S, 172*S, 130*S], PIG)                      # head
    ol_ellipse(d, [150*S, 92*S, 178*S, 118*S], PIG_D)                    # snout
    d.ellipse([158*S, 98*S, 166*S, 106*S], fill=PIG_NOSE)
    d.ellipse([166*S, 100*S, 174*S, 108*S], fill=PIG_NOSE)
    ol_poly(d, [(x*S, y*S) for x, y in [(122, 74), (132, 52), (144, 72)]], PIG_D, 4)  # ear
    d.ellipse([140*S, 86*S, 150*S, 96*S], fill=OUTLINE)                  # eye
    for lx in [58, 96]:
        ol_rect(d, [lx*S, 142*S, (lx+16)*S, 178*S], PIG_D, 4)            # legs
    d.arc([20*S, 84*S, 48*S, 112*S], start=270, end=180+360, fill=OUTLINE, width=5*S)  # curly tail
    return finish(im)

ITEMS = [("house", house), ("board", board), ("tree", tree), ("pine", pine),
         ("fruit_tree", fruit_tree), ("bush", bush), ("rock", rock),
         ("cactus", cactus), ("flower", flower), ("pig", pig)]

def main():
    cols = 5
    rows = (len(ITEMS)+cols-1)//cols
    sheet = Image.new("RGBA", (cols*CELL, rows*CELL), (0,0,0,0))
    meta = {}
    for i, (name, fn) in enumerate(ITEMS):
        spr = fn()
        x, y = (i % cols)*CELL, (i//cols)*CELL
        sheet.paste(spr, (x, y), spr)
        meta[name] = {"x": x, "y": y, "w": CELL, "h": CELL}
    sheet.save("art/world/spritesheet.png")
    json.dump(meta, open("art/world/spritesheet.json", "w"), indent=1)
    print("sheet saved", sheet.size)

if __name__ == "__main__":
    main()
