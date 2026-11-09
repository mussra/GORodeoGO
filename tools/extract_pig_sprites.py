"""Recover user-supplied JPEG sheet into aligned RGBA frames.
Only border-connected near-black is cleared. Interior eyes/hooves stay intact.
Source is kept unchanged. Requires Pillow and numpy; no network.
"""
from pathlib import Path
from collections import deque
import numpy as np
from PIL import Image, ImageDraw
ROOT=Path(__file__).resolve().parents[1]
im=Image.open(ROOT/'art/world/pigs/source/running-sheet.jpg').convert('RGB')
# The JPEG is not a regular grid: explicit gaps avoid cutting neighbouring tails.
xs=[(17,175),(176,322),(323,469),(470,618),(619,775),(776,925),(926,1075),(1076,1226),(1227,1375),(1376,1527)]
contact=Image.new('RGBA',(160*10,144*2),(39,62,68,255))
for row,name in enumerate(['pink','brown']):
 out=ROOT/'art/world/pigs'/name;out.mkdir(exist_ok=True)
 for i,(x0,x1) in enumerate(xs):
  crop=im.crop((x0,278+row*419,x1,411+row*419));rgb=np.asarray(crop)
  h,w=rgb.shape[:2];dark=rgb.max(2)<25;outside=np.zeros((h,w),bool);todo=deque()
  for y in range(h):
   for x in (0,w-1):
    if dark[y,x]:outside[y,x]=True;todo.append((y,x))
  for x in range(w):
   for y in (0,h-1):
    if dark[y,x] and not outside[y,x]:outside[y,x]=True;todo.append((y,x))
  while todo:
   y,x=todo.popleft()
   for yy,xx in ((y-1,x),(y+1,x),(y,x-1),(y,x+1)):
    if 0<=yy<h and 0<=xx<w and dark[yy,xx] and not outside[yy,xx]:outside[yy,xx]=True;todo.append((yy,xx))
  rgba=np.dstack((rgb,np.where(outside,0,255).astype('uint8')))
  frame=Image.fromarray(rgba);bbox=frame.getbbox();frame=frame.crop(bbox)
  cell=Image.new('RGBA',(160,144));cell.alpha_composite(frame,((160-frame.width)//2,128-frame.height))
  cell.save(out/f'frame_{i:02}.png');contact.alpha_composite(cell,(i*160,row*144))
contact.convert('RGB').save('/downloads/pig2747-contact.png')
