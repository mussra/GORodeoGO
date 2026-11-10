"""Remove exterior neutral matte residue from existing rider hat PNGs only.
Never reads or modifies user-painted coat/pattern masks or UV maps.
Coordinates and old RGBA are logged for a fully reversible pixel audit.
"""
from pathlib import Path
from PIL import Image
from collections import deque
import json
ROOT=Path(__file__).resolve().parents[1]
audit=ROOT/"tools/hat_cleanup_2768.json"
if audit.exists():
 raise SystemExit("Audit already exists; restore original PNGs and remove audit before regenerating.")
changes=[]
for view in ['up','down','diag_up','side']:
 for i in range(1,9):
  path=ROOT/f'art/experimental/pixellab/rider/{view}/frame_{i:02}.png'
  im=Image.open(path).convert('RGBA'); pix=im.load();w,h=im.size
  # The horse's ears and mane sit outside this tight hat-only window.
  xmin,xmax=(27,67) if view in ('up','down') else (28,70)
  candidates=set()
  for y in range(25):
   for x in range(xmin,xmax):
    r,g,b,a=pix[x,y];hi=max(r,g,b);lo=min(r,g,b)
    if a and 75<=hi<=140 and (hi-lo)/hi<=.40:candidates.add((x,y))
  # Reach only matte pixels connected to transparent exterior, never interior.
  seen={(x,y) for y in range(h) for x in range(w) if pix[x,y][3]==0};q=deque(seen);remove=set()
  while q:
   x,y=q.popleft()
   for xx,yy in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
    if 0<=xx<w and 0<=yy<h and (xx,yy) not in seen and (xx,yy) in candidates:
     seen.add((xx,yy));remove.add((xx,yy));q.append((xx,yy))
  # Residue can reach the topmost row, with no transparent neighbour above.
  for p in candidates:
   if p[1]==0:remove.add(p)
  if remove:
   old=[[x,y,*pix[x,y]] for x,y in sorted(remove,key=lambda p:(p[1],p[0]))]
   for x,y in remove:pix[x,y]=(0,0,0,0)
   im.save(path);changes.append({'path':str(path.relative_to(ROOT)),'pixels':old})
(ROOT/'tools/hat_cleanup_2768.json').write_text(json.dumps(changes,indent=2)+'\n')
print('frames',len(changes),'pixels',sum(len(c['pixels']) for c in changes))
