from PIL import Image
import numpy as np
from collections import deque
from pathlib import Path

def extract(path,goat):
 im=Image.open(path).convert('RGB');w,h=im.size
 for row in range(4):
  bounds=[0,round(h*.255),round(h*.475),round(h*.708),h] if goat else [0,round(h*.25),round(h*.50),round(h*.75),h]
  band=im.crop((0,bounds[row],w,bounds[row+1]));a=np.array(band);hi=a.max(2).astype(int);lo=a.min(2).astype(int)
  bg=hi<28
  hh,ww=bg.shape;gone=np.zeros(bg.shape,bool);q=deque()
  for x in range(ww):q.extend([(x,0),(x,hh-1)])
  for y in range(hh):q.extend([(0,y),(ww-1,y)])
  while q:
   x,y=q.popleft()
   if x<0 or y<0 or x>=ww or y>=hh or gone[y,x] or not bg[y,x]:continue
   gone[y,x]=True;q.extend([(x-1,y),(x+1,y),(x,y-1),(x,y+1)])
  # Only retain the twelve actual connected animals, dropping JPEG edge islands.
  seen=np.zeros(bg.shape,bool);components=[]
  for yy in range(hh):
   for xx in range(ww):
    if gone[yy,xx] or seen[yy,xx]:continue
    comp=[];q=deque([(xx,yy)]);seen[yy,xx]=True
    while q:
     x,y=q.popleft();comp.append((x,y))
     for dx,dy in [(1,0),(-1,0),(0,1),(0,-1),(1,1),(-1,-1),(1,-1),(-1,1)]:
      nx,ny=x+dx,y+dy
      if 0<=nx<ww and 0<=ny<hh and not gone[ny,nx] and not seen[ny,nx]:seen[ny,nx]=True;q.append((nx,ny))
    if len(comp)>100:components.append(comp)
  components=sorted(sorted(components,key=len,reverse=True)[:10],key=lambda c:min(x for x,y in c))
  print(path,row,'animals',len(components))
  assert len(components)==10
  for col,comp in enumerate(components):
   alpha=np.zeros((hh,ww),dtype='uint8')
   for x,y in comp:alpha[y,x]=255
   fg=Image.fromarray(np.dstack((a,alpha)));fg=fg.crop(fg.getbbox())
   target_h=132 if goat else 123;max_w=148
   factor=min(max_w/fg.width,target_h/fg.height);fg=fg.resize((round(fg.width*factor),round(fg.height*factor)),Image.Resampling.LANCZOS)
   out=Image.new('RGBA',(160,160 if goat else 144));baseline=144 if goat else 128;out.alpha_composite(fg,((160-fg.width)//2,baseline-fg.height))
   folder=Path('art/world/goats/compare10')/['right','left','down','up'][row] if goat else Path('art/world/pigs')/('pink' if row<2 else 'brown')/('down' if row%2==0 else 'up')
   folder.mkdir(parents=True,exist_ok=True);out.save(folder/f'frame_{col:02}.png')

extract('art/world/goats/compare10/source/running-four-views.jpg',True)
