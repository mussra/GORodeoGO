"""Derive all connections from the first supplied horizontal straight only."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
import numpy as np
from scipy.ndimage import map_coordinates
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'art/world/derived88';OUT.mkdir(exist_ok=True)
source=Image.open(ROOT/'art/world/modular86/source/ant-road-sheet-20261111.png').convert('RGB')
# First sheet, horizontal straight. No other road art is read.
straight=source.crop((32,186,327,479));straight.save(OUT/'straight-source.png')
a=np.array(straight,dtype=float);h,w=a.shape[:2]
profile=a[:,8:-8].mean(1);soil=np.where((profile[:,0]>profile[:,1]*1.05)&(profile[:,0]>profile[:,2]*1.4))[0];low,high=int(soil[0]),int(soil[-1]);mid=(low+high)/2;half=(high-low)/2
N=192;R=36.;LEAF=11.
# Seamless along-road texture by mirror of original interior pixels. All tiles share period N.
texture=a[:,12:-12];texture=np.concatenate([texture,texture[:,::-1]],axis=1)
# A tile field is a union of path segments/arcs; every port is at the midpoint.
def distances(kind):
 Y,X=np.mgrid[:N,:N].astype(float);X+=.5;Y+=.5
 def seg(x1,y1,x2,y2):
  t=np.clip(((X-x1)*(x2-x1)+(Y-y1)*(y2-y1))/((x2-x1)**2+(y2-y1)**2),0,1)
  return np.hypot(X-(x1+t*(x2-x1)),Y-(y1+t*(y2-y1)))
 if kind=='straight':return seg(-N,N/2,N*2,N/2)
 if kind=='corner':return abs(np.hypot(X,Y-N)-N/2)
 if kind=='tee':return np.minimum(seg(-N,N/2,N*2,N/2),seg(N/2,N/2,N/2,N*2))
 if kind=='cross':return np.minimum(seg(-N,N/2,N*2,N/2),seg(N/2,-N,N/2,N*2))
 if kind=='end':return seg(-N,N/2,N/2,N/2)
 return np.hypot(X-N/2,Y-N/2)
def paint(distance):
 Y,X=np.mgrid[0:distance.shape[0],0:distance.shape[1]].astype(float)
 # Sample one symmetric cross-section, with original dirt and leaf border pixels.
 v=mid+distance/R*half
 v=np.clip(v,0,h-1)
 # Same global two-dimensional phase, repeating every tile. No per-piece colour shifts.
 u=((X+Y*.31)%N)/(N-1)*(texture.shape[1]-1)
 rgb=np.stack([map_coordinates(texture[:,:,c],[v,u],order=1,mode='wrap') for c in range(3)],-1)
 alpha=np.clip((R+LEAF-distance)/3,0,1)*255
 return Image.fromarray(np.uint8(np.dstack([np.clip(rgb,0,255),alpha])))
for name in ['straight','corner','tee','cross','end','dot']:paint(distances(name)).save(OUT/(name+'.png'))
# Connected graph uses rotations, all six derivative assets.
W,H=7,5;edges=set()
def path(cells):
 for p,q in zip(cells,cells[1:]):edges.add(tuple(sorted((p,q))))
path([(0,3),(1,3),(2,3),(2,2),(2,1),(3,1),(4,1),(4,2),(4,3),(5,3),(6,3)])
path([(3,1),(3,0)]);path([(5,1),(5,2),(5,3),(5,4)])
ports=[(0,1,0,1),(0,0,1,1),(0,1,1,1),(1,1,1,1),(0,0,0,1),(0,0,0,0)];names=['straight','corner','tee','cross','end','dot'];cells={p for e in edges for p in e}|{(0,0)}
canvas=Image.new('RGBA',(W*N,H*N+115),(68,111,47,255));layer=Image.new('RGBA',(W*N,H*N))
for pos in cells:
 bits=tuple(int(tuple(sorted((pos,(pos[0]+dx,pos[1]+dy)))) in edges) for dx,dy in [(0,-1),(1,0),(0,1),(-1,0)])
 found=False
 for name,p in zip(names,ports):
  for rot in range(4):
   rotated=p[-rot:]+p[:-rot] if rot else p
   if bits==rotated:
    tile=Image.open(OUT/(name+'.png')).rotate(-90*rot);layer.alpha_composite(tile,(pos[0]*N,pos[1]*N));found=True;break
  if found:break
 assert found
canvas.alpha_composite(layer,(0,65));d=ImageDraw.Draw(canvas);font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',23)
d.rectangle((0,0,W*N,64),fill='#102d24');d.text((20,18),'Una sola recta: curvas, T, cruce y finales derivados por código',font=font,fill='#fff0ce')
d.rectangle((0,H*N+65,W*N,H*N+115),fill='#102d24');d.text((20,H*N+78),'Ancho único. Sin cambiar el mundo. Prueba de textura y uniones.',font=font,fill='#fff0ce')
canvas.convert('RGB').save('/downloads/recta-unica88-montaje.png')
print('Source dirt band',low,high,'source width',high-low+1,'output diameter',2*R,'cells',len(cells))
# Regression: all ports have the same opaque width at the same midpoint.
for name,p in zip(names,ports):
 d=distances(name)
 edge=[d[0],d[:,-1],d[-1],d[:,0]]
 for side,opened in enumerate(p):
  if opened:
   occupied=np.where(edge[side]<R)[0]
   assert len(occupied)==72,(name,side,len(occupied))
   assert abs((occupied[0]+occupied[-1])/2-(N-1)/2)<.01
print('Verified 12 open ports: 72px core width, centre 95.5/192px; six tile types')
