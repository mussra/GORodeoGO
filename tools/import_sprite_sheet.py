#!/usr/bin/env python3
"""Chroma-key a 3x2 sheet into registered 96px animation frames.
Usage: python tools/import_sprite_sheet.py sheet.png art/player/walk_side
The source is kept outside runtime; no new Python dependency in the game.
"""
from pathlib import Path
import argparse
import statistics
from PIL import Image

def import_sheet(source, destination):
    im=Image.open(source).convert('RGBA'); w,h=im.size
    cells=[]; heights=[]
    for i in range(6):
        x,y=i%3,i//3
        cell=im.crop((round(x*w/3),round(y*h/2),round((x+1)*w/3),round((y+1)*h/2)))
        pix=cell.load()
        for yy in range(cell.height):
            for xx in range(cell.width):
                r,g,b,a=pix[xx,yy]
                # Pure-magenta backdrop and its antialias fringe, never warm reds.
                strength=min(r,b)-g
                if r>125 and b>110 and strength>65:
                    a=0 if strength>100 else int(a*(100-strength)/35)
                    pix[xx,yy]=(r,g,b,a)
        # Ignore almost-transparent generation noise for registration.
        alpha=cell.getchannel('A').point(lambda a: 255 if a >= 96 else 0)
        bbox=alpha.getbbox()
        if not bbox: raise ValueError('empty animation cell')
        cells.append((cell,bbox));heights.append(bbox[3]-bbox[1])
    scale=84/statistics.median(heights)
    out=Path(destination);out.mkdir(parents=True,exist_ok=True)
    for stale in out.glob('frame_*.png'): stale.unlink()
    for i,(cell,bbox) in enumerate(cells):
        sprite=cell.crop(bbox)
        sprite=sprite.resize((round(sprite.width*scale),round(sprite.height*scale)),Image.Resampling.LANCZOS)
        frame=Image.new('RGBA',(96,96))
        frame.alpha_composite(sprite,((96-sprite.width)//2,92-sprite.height))
        frame.save(out/f'frame_{i:02d}.png')
    return out

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('destination');a=p.parse_args();import_sheet(a.source,a.destination)
