#!/usr/bin/env python3
"""Crop the approved 10x10 artwork sheet without changing the game."""
import argparse,json
from pathlib import Path
from PIL import Image
p=argparse.ArgumentParser();p.add_argument('sheet');p.add_argument('--output',default='art/replacement259');args=p.parse_args()
root=Path(__file__).resolve().parents[1];out=Path(args.output);out=out if out.is_absolute() else root/out
manifest=json.loads((root/'art/replacement259/manifest.json').read_text())
im=Image.open(args.sheet).convert('RGBA')
if im.width!=im.height or im.width%10:raise SystemExit('Expected square sheet whose pixel width is divisible by 10; inspect and resize deliberately first.')
out.mkdir(exist_ok=True,parents=True);n=im.width//10
for row in manifest['items']:
 x=(row['column']-1)*n;y=(row['row']-1)*n;tile=im.crop((x,y,x+n,y+n));pixels=tile.load()
 def background(x,y):
  r,g,b,a=pixels[x,y];return r>190 and b>190 and g<90 and abs(r-b)<65
 for y in range(n):
  for x in range(n):
   if background(x,y):pixels[x,y]=(0,0,0,0)
 tile.save(out/row['file'])
print('Cropped 100 files. Inspect every cell, transparent hole, margin and edge before activating. No game resources were changed automatically.')
