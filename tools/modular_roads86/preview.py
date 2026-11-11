"""Non-destructive slicing and seam-normalisation preview of Ant's six tiles."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
import numpy as np
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'art/world/modular86';OUT.mkdir(exist_ok=True)
im=Image.open(OUT/'source/ant-road-sheet-20261111.png').convert('RGBA')
boxes=[(20,174,339,491),(383,175,700,491),(744,174,1063,491),(1107,174,1424,490),(1468,174,1786,491),(1831,174,2149,491)]
names=['straight','corner','tee','cross','end','dot'];N=192
raw={};fixed={}
# Ports N,E,S,W from original sheet, with clockwise rotations below.
ports=[(0,1,0,1),(0,0,1,1),(0,1,1,1),(1,1,1,1),(0,0,0,1),(0,0,0,0)]
for name,box in zip(names,boxes):
 tile=im.crop(box).resize((N,N),Image.Resampling.LANCZOS);tile.save(OUT/(name+'-raw.png'));raw[name]=tile
 # Trim rounded outer corners and the decorative cut-edge fringe, then square.
 tile=im.crop((box[0]+12,box[1]+12,box[2]-12,box[3]-12)).resize((N,N),Image.Resampling.LANCZOS).convert('RGB');fixed[name]=tile
# Normalise all open edge widths/centres to common 34%-66% ports.
from scipy.ndimage import map_coordinates
Y,X=np.mgrid[0:N,0:N].astype(float)
lo,hi=N*.32,N*.68
for i,name in enumerate(names):
 a=np.array(fixed[name],dtype=float);sx=X.copy();sy=Y.copy()
 for side,opened in enumerate(ports[i]):
  if not opened:continue
  profile=[a[:5].mean(0),a[:,-5:].mean(1),a[-5:].mean(0),a[:,:5].mean(1)][side]
  soil=np.where((profile[:,0]>profile[:,1]*1.05)&(profile[:,0]>profile[:,2]*1.4))[0]
  assert len(soil)>15,(name,side)
  oldlo,oldhi=soil[0],soil[-1]
  axis=np.arange(N);mapped=np.interp(axis,[0,lo,hi,N-1],[0,oldlo,oldhi,N-1]);shift=mapped-axis
  if side in (0,2):
   distance=Y if side==0 else N-1-Y;sy+=0;sx+=shift[None,:]*(1-distance/(N-1))**2
  else:
   distance=X if side==3 else N-1-X;sy+=shift[:,None]*(1-distance/(N-1))**2
 b=np.stack([map_coordinates(a[:,:,c],[sy,sx],order=1,mode='nearest') for c in range(3)],axis=-1)
 fixed[name]=Image.fromarray(np.uint8(b))
# A grass-only patch from inside the straight tile; mirrored into a continuous base.
patch=im.crop((70,195,290,235)).convert('RGB').resize((192,64),Image.Resampling.LANCZOS)
base=Image.new('RGB',(384,128));base.paste(patch,(0,0));base.paste(patch.transpose(Image.Transpose.FLIP_LEFT_RIGHT),(192,0));base.paste(base.crop((0,0,384,64)).transpose(Image.Transpose.FLIP_TOP_BOTTOM),(0,64));base.save(OUT/'grass-base.png')
# Common port texture copied from the straight, symmetric so rotations agree.
straight=np.array(fixed['straight'],dtype=float)
road_edge=(straight[:,:5].mean(1)+straight[:,-5:].mean(1))/2
road_edge=(road_edge+road_edge[::-1])/2
for i,name in enumerate(names):
 a=np.array(fixed[name],dtype=float);alpha=np.ones((N,N))*255
 for side,opened in enumerate(ports[i]):
  for d in range(22):
   if opened:
    w=(1-d/22)**2
    if side==0:a[d]=a[d]*(1-w)+road_edge*w
    if side==2:a[-1-d]=a[-1-d]*(1-w)+road_edge*w
    if side==1:a[:,-1-d]=a[:,-1-d]*(1-w)+road_edge*w
    if side==3:a[:,d]=a[:,d]*(1-w)+road_edge*w
   # Grass at outer borders dissolves into the matching background. Soil stays opaque.
   mask=np.ones(N)*(d/22)
   if opened:mask[int(lo)-14:int(hi)+15]=1
   if side==0:alpha[d]=np.minimum(alpha[d],mask*255)
   if side==2:alpha[-1-d]=np.minimum(alpha[-1-d],mask*255)
   if side==1:alpha[:,-1-d]=np.minimum(alpha[:,-1-d],mask*255)
   if side==3:alpha[:,d]=np.minimum(alpha[:,d],mask*255)
 fixed[name]=Image.fromarray(np.uint8(np.dstack([np.clip(a,0,255),alpha])));fixed[name].save(OUT/(name+'.png'))
# Connected graph with a long main path, bend, bifurcation, cross and isolated dot.
W,H=7,5;edges=set()
def path(cells):
 for a,b in zip(cells,cells[1:]):edges.add(tuple(sorted((a,b))))
path([(0,3),(1,3),(2,3),(2,2),(2,1),(3,1),(4,1),(4,2),(4,3),(5,3),(6,3)])
path([(3,1),(3,0)])
path([(5,1),(5,2),(5,3),(5,4)])
# Dot at upper left.
cells={p for e in edges for p in e};cells.add((0,0))
def kind_for(pos):
 bits=[]
 for dx,dy in [(0,-1),(1,0),(0,1),(-1,0)]:bits.append(int(tuple(sorted((pos,(pos[0]+dx,pos[1]+dy)))) in edges))
 for i,ps in enumerate(ports):
  for rot in range(4):
   rotated=ps[-rot:]+ps[:-rot] if rot else ps
   if tuple(bits)==tuple(rotated):return names[i],rot
 raise ValueError((pos,bits))
font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',23)
for label,tiles in [('antes',raw),('ajustado',fixed)]:
 canvas=Image.new('RGBA',(W*N,H*N+115),(65,106,37,255))
 for yy in range(65,H*N+65,128):
  for xx in range(0,W*N,384):canvas.paste(base,(xx,yy))
 for pos in cells:
  kind,rot=kind_for(pos);tile=tiles[kind].rotate(-90*rot)
  canvas.alpha_composite(tile,(pos[0]*N,pos[1]*N+65))
 d=ImageDraw.Draw(canvas);d.rectangle((0,0,W*N,64),fill='#102d24');d.text((20,17),'Hoja nueva - '+('recorte directo, sin ajuste' if label=='antes' else 'recorte, encajes y césped de la misma hoja'),font=font,fill='#fff0ce')
 d.rectangle((0,H*N+65,W*N,H*N+115),fill='#102d24')
 d.text((20,H*N+77),'Recto, curva, T, cruce, final y punto. Solo prueba; sin cambiar el mundo.',font=font,fill='#fff0ce')
 canvas.convert('RGB').save('/downloads/hoja-caminos86-'+label+'.png')

# Expose the repetition rather than concealing it in the road composition.
grass_preview=Image.new('RGB',(1152,640))
for yy in range(0,640,128):
 for xx in range(0,1152,384):grass_preview.paste(base,(xx,yy))
d=ImageDraw.Draw(grass_preview);d.rectangle((0,0,1152,64),fill='#102d24');d.text((20,18),'Césped de la hoja: parche repetido y espejado; patrón visible',font=font,fill='#fff0ce')
grass_preview.save('/downloads/hoja-caminos86-cesped.png')
# Every adjacency uses the same open/closed ports after tile rotation.
for pos in cells:
 name,rot=kind_for(pos)
 assert name in names and rot in range(4)
print('Verified',len(cells),'cells,',len(edges),'connections; six original tile types used:',sorted({kind_for(p)[0] for p in cells}))
