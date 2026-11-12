"""Non-destructive adornment study: masks only, no new source art or saved gear.
R: narrow bands clipped to existing horse socks. G: boot cuff/toe accents.
Side walk only, all nine source frames. Not approved production masks.
"""
from pathlib import Path
import hashlib,json
import numpy as np,cv2
from PIL import Image,ImageDraw
R=Path(__file__).resolve().parents[1];OUT=R/'art/adorn153';OUT.mkdir(exist_ok=True)
audit=[]
def save(src,out,leg,boot):
 a=np.array(Image.open(R/src).convert('RGBA'));rgb=np.zeros_like(a[:,:,:3]);leg=np.where(a[:,:,3]>0,leg,0);boot=np.where(a[:,:,3]>0,boot,0);rgb[:,:,0]=leg;rgb[:,:,1]=boot
 assert not np.any((leg>0)&(boot>0));Image.fromarray(rgb).save(OUT/out)
 audit.append(dict(source=src,sha256=hashlib.sha256((R/src).read_bytes()).hexdigest(),mask='art/adorn153/'+out,leg_pixels=int((leg>0).sum()),boot_pixels=int((boot>0).sum())))
def top_bands(eligible,depth):
 n,labels,stats,_=cv2.connectedComponentsWithStats(eligible.astype('uint8'));result=np.zeros(eligible.shape,dtype='uint8')
 for i in range(1,n):
  if stats[i,cv2.CC_STAT_AREA]<3:continue
  # A thin band follows the actual upper edge of each visible sock column.
  comp=labels==i
  for x in np.where(comp.any(0))[0]:
   ys=np.where(comp[:,x])[0]
   result[ys[:depth],x]=255
 return result
for i in range(9):
 src=f'art/experimental/pixellab/rider/side/frame_{i:02}.png';a=np.array(Image.open(R/src).convert('RGBA'));m=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v5/rider/side/color_{i:02}.png').convert('RGB'));y,x=np.mgrid[:96,:96]
 # Existing pale socks only, excluding tail, rider, saddle and the dark hooves.
 eligible=(y>67)&(m[:,:,0]>100)&(m[:,:,1]<100)&(a[:,:,3]>100)&(a[:,:,0]>100)&(a[:,:,2]>.64*a[:,:,0])&(a[:,:,1]>.75*a[:,:,0])
 leg=top_bands(eligible,2)
 # Cuff and toe follow the nine reviewed lateral boot positions.
 shifts=[(0,0),(-1,-1),(-1,-1),(-1,-2),(-1,-1),(0,0),(1,1),(2,2),(2,1)];dx,dy=shifts[i]
 b=Image.new('L',(96,96));d=ImageDraw.Draw(b);d.polygon([(51+dx,60+dy),(56+dx,60+dy),(56+dx,62+dy),(51+dx,62+dy)],fill=255);d.polygon([(54+dx,65+dy),(59+dx,65+dy),(59+dx,67+dy),(54+dx,67+dy)],fill=255)
 # Never tint blue trousers, black outlines or the coat-mask region.
 boot=np.array(b);safe=(a[:,:,3]>100)&(a[:,:,0]>a[:,:,2]*1.25)&(a[:,:,0]<180)&(a[:,:,0]>40)&(m[:,:,0]<100)&(m[:,:,1]<100);boot=np.where(safe,boot,0).astype('uint8');save(src,f'side_{i:02}.png',leg,boot)
src='art/portraits/adult_hd.png';a=np.array(Image.open(R/src).convert('RGBA'));m=np.array(Image.open(R/'art/portraits/adult_lower_legs_mask.png').convert('RGB'));eligible=(m[:,:,0]>100)&(a[:,:,3]>100);leg=np.zeros(eligible.shape,dtype='uint8')
n,labels,stats,centers=cv2.connectedComponentsWithStats(eligible.astype('uint8'));yy,xx=np.mgrid[:983,:936]
for i in range(1,n):
 edge=stats[i,1]+48-.12*(xx-centers[i,0]);leg[(labels==i)&(yy>=edge)&(yy<edge+22)]=255
b=Image.new('L',(936,983));d=ImageDraw.Draw(b);d.polygon([(382,488),(411,482),(442,484),(465,497),(459,526),(431,513),(404,514),(378,526)],fill=255);d.polygon([(410,599),(440,592),(470,598),(474,614),(449,626),(420,622)],fill=255);save(src,'portrait.png',leg,np.array(b))
(OUT/'audit.json').write_text(json.dumps(audit,indent=2));print(json.dumps(audit,indent=2))
