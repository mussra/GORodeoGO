"""Build lower-leg ownership separately from horse coat/hair and dark hooves."""
from pathlib import Path
from PIL import Image,ImageFilter
import numpy as np
R=Path(__file__).resolve().parents[2]
def build(p,key):
 a=np.array(Image.open(p).convert('RGBA'));h,w=a.shape[:2];y,x=np.mgrid[:h,:w];rgb=a[:,:,:3].astype(float);mx=rgb.max(2);mn=rgb.min(2)
 mp=R/'art/horse_masks'/key
 if mp.exists():hair=np.array(Image.open(mp).convert('RGB'))[:,:,1]>40
 else:hair=np.zeros((h,w),bool)
 # Source cream only, never brown hooves. Pixel art stays crisp.
 sel=(y>h*(.68 if key.parts[0].startswith('wild') else .60))&(mx>130)&(mn>75)&((mx-mn)<100)&(rgb[:,:,0]>=rgb[:,:,2])&(a[:,:,3]>150)&~hair
 if key.parts[0]=='foal':
  # Find each cream/hoof seam from its luminance drop, one column at a time.
  m=np.zeros((h,w,3),dtype=np.uint8);lum=rgb.mean(2)
  for left,right,top,edge_min,edge_max in [(51,101,288,308,331),(102,149,278,298,320),(148,201,288,309,338),(188,238,279,301,329)]:
   edges={}
   for col in range(left,right):
    candidates=[]
    for row in range(edge_min,edge_max):
     if a[row,col,3]<200 or a[row-1,col,3]<200:continue
     drop=float(lum[row-1,col]-lum[row,col])
     if lum[row-1,col]>65 and drop>8:candidates.append((drop,row))
    if candidates:edges[col]=max(candidates)[1]
   for col in range(left,right):
    if not edges:continue
    edge=edges[min(edges,key=lambda c:abs(c-col))]
    organic_top=top+round(1.5*np.sin(col*.7)+np.cos(col*.33))
    m[organic_top:edge,col,0]=255
  m[a[:,:,3]<5]=0
  out=R/'art/lower_legs_masks'/key;out.parent.mkdir(parents=True,exist_ok=True);Image.fromarray(m).save(out);return
 # Hair protection includes its antialiased outline.
 hair=np.asarray(Image.fromarray((hair*255).astype('uint8')).filter(ImageFilter.MaxFilter(3)))>0
 sel&=~hair
 m=np.zeros((h,w,3),dtype=np.uint8);m[:,:,0]=sel*255
 out=R/'art/lower_legs_masks'/key;out.parent.mkdir(parents=True,exist_ok=True);Image.fromarray(m).save(out)
for p in (R/'art/player').glob('*/*.png'):build(p,p.relative_to(R/'art/player'))
for p in (R/'art/world/wild_base').glob('*/*.png'):build(p,Path('wild_'+p.parent.name)/p.name)
build(R/'art/foal/base.png',Path('foal/frame_00.png'))
# HD stockings are traced per limb, with fractional cream ownership.
from PIL import ImageDraw
p=R/'art/portraits/adult_hd.png';im=Image.open(p);a=np.array(im);h,w=a.shape[:2]
polys=[[(204,775),(275,787),(267,825),(281,872),(294,914),(266,908),(235,908),(204,918),(172,933),(167,909),(183,858)],[(354,780),(426,779),(438,821),(451,862),(477,890),(456,888),(423,895),(391,910),(368,920),(359,890),(352,845)],[(557,807),(641,810),(640,851),(650,904),(673,947),(652,940),(616,937),(582,947),(544,966),(543,940),(552,886)],[(711,803),(790,796),(800,838),(820,885),(849,929),(828,927),(798,931),(763,945),(722,963),(718,942),(714,903)]]
layer=Image.new('L',(w*4,h*4));draw=ImageDraw.Draw(layer)
for poly in polys:draw.polygon([(px*4,py*4) for px,py in poly],fill=255)
zone=np.array(layer.resize((w,h),Image.Resampling.LANCZOS))/255
rgb=a[:,:,:3].astype(float)/255;mx=rgb.max(2);mn=rgb.min(2);sat=(mx-mn)/np.maximum(mx,.001)
weight=zone*(a[:,:,3]/255)
m=np.zeros((h,w,3),dtype=np.uint8);m[:,:,0]=(weight*255).astype('uint8');Image.fromarray(m).save(R/'art/portraits/adult_lower_legs_mask.png')
