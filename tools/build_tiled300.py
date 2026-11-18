from PIL import Image,ImageOps,ImageDraw,ImageFont,ImageEnhance,ImageFilter
import numpy as np
from scipy.ndimage import gaussian_filter
from pathlib import Path
P=Path(__file__).resolve().parents[1]/'art/ui/tiled300'
im=Image.open(P/'source/original.png').convert('RGBA').crop((40,52,2132,650)).resize((523,150),Image.Resampling.LANCZOS)
a=np.asarray(im).astype(float);rgb=a[:,:,:3];m=((rgb[:,:,2]>rgb[:,:,0]*1.12)&(rgb[:,:,1]>rgb[:,:,0]*1.15)).astype(float)
# Retain the leather grain but remove the source's broad lighting variation before tiling.
weight=gaussian_filter(m,9)+1e-5
for c,target in enumerate((27,79,88)):
 low=gaussian_filter(rgb[:,:,c]*m,9)/weight
 rgb[:,:,c]=rgb[:,:,c]+m*(target-low)*0.95
im=Image.fromarray(np.clip(a,0,255).astype('uint8'))
L=R=90;T=B=64

def tile(patch,w,h,mirror=False):
 out=Image.new('RGBA',(w,h));pw,ph=patch.size
 for y in range(0,h,ph):
  for x in range(0,w,pw):
   t=patch
   if mirror and (x//pw)%2:t=ImageOps.mirror(t)
   if mirror and (y//ph)%2:t=ImageOps.flip(t)
   out.paste(t,(x,y))
 return out

def panel(w,h):
 out=tile(im.crop((185,48,329,103)),w,h,True)
 # Two horizontal stitch periods and one vertical period, no scaling of stitch shapes.
 x0,x1=219,266;y0,y1=64,87
 for src,xy,size in [((x0,0,x1,T),(L,0),(w-L-R,T)),((x0,150-B,x1,150),(L,h-B),(w-L-R,B)),((0,y0,L,y1),(0,T),(L,h-T-B)),((523-R,y0,523,y1),(w-R,T),(R,h-T-B))]:
  out.paste(tile(im.crop(src),*size),xy)
 # Corners stay fixed; overlap feather blends only joins, not source dimensions.
 for right,bottom in [(False,False),(True,False),(False,True),(True,True)]:
  cw,ch=L+24,T+18
  crop=im.crop((523-cw if right else 0,150-ch if bottom else 0,523 if right else cw,150 if bottom else ch))
  mask=np.ones((ch,cw),float)
  rampx=np.ones(cw);rampx[-24:]=np.linspace(1,0,24)
  rampy=np.ones(ch);rampy[-18:]=np.linspace(1,0,18)
  if right:rampx=rampx[::-1]
  if bottom:rampy=rampy[::-1]
  mask=rampy[:,None]*rampx[None,:]
  alpha=np.asarray(crop)[:,:,3]*mask
  crop.putalpha(Image.fromarray(alpha.astype('uint8')))
  out.alpha_composite(crop,(w-cw if right else 0,h-ch if bottom else 0))
 # Restore the original outer silhouette after blending; no leather under transparent corners.
 silhouette=Image.new('L',(w,h),255)
 for src,xy,size in [((0,0,L,T),(0,0),None),((523-R,0,523,T),(w-R,0),None),((0,150-B,L,150),(0,h-B),None),((523-R,150-B,523,150),(w-R,h-B),None),((x0,0,x1,T),(L,0),(w-L-R,T)),((x0,150-B,x1,150),(L,h-B),(w-L-R,B)),((0,y0,L,y1),(0,T),(L,h-T-B)),((523-R,y0,523,y1),(w-R,T),(R,h-T-B))]:
  patch=im.crop(src)
  if size:patch=tile(patch,*size)
  silhouette.paste(patch.getchannel('A'),xy)
 out.putalpha(silhouette)
 return out

def state(im,kind):
 if kind=='normal':return im
 alpha=im.getchannel('A')
 if kind=='pressed':
  im=ImageEnhance.Brightness(im).enhance(.76)
  # Insets are represented by a dark interior shadow, without rescaling artwork.
  shadow=Image.new('RGBA',im.size,(0,0,0,0));d=ImageDraw.Draw(shadow)
  d.rounded_rectangle((14,14,im.width-15,im.height-15),radius=20,outline=(0,0,0,95),width=5)
  im=Image.alpha_composite(im,shadow.filter(ImageFilter.GaussianBlur(3)))
 else:
  im=ImageEnhance.Color(im).enhance(.18)
  im=ImageEnhance.Brightness(im).enhance(.68)
 im.putalpha(alpha)
 return im

w,h=321,197;L=90;T=64
out=tile(im.crop((185,50,326,101)),w,h,True)
for src,xy,sz in [((219,0,266,64),(90,0),(141,64)),((219,86,266,150),(90,h-64),(141,64)),((0,64,90,87),(0,64),(90,69)),((433,64,523,87),(w-90,64),(90,69))]:out.paste(tile(im.crop(src),*sz),xy)
for s,xy in [((0,0,90,64),(0,0)),((433,0,523,64),(w-90,0)),((0,86,90,150),(0,h-64)),((433,86,523,150),(w-90,h-64))]:out.paste(im.crop(s),xy)
d=P
for k in ['normal','pressed','disabled']:state(out,k).resize((116,71),Image.Resampling.LANCZOS).save(d/(k+'.png'))
