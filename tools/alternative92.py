from PIL import Image
from pathlib import Path
import numpy as np
from scipy.ndimage import gaussian_filter
root=Path(__file__).resolve().parents[1];out=root/'art/world/alternative92';im=Image.open(out/'source.jpg').convert('RGB')
# Actual JPEG: remove only neutral bright checker pixels, retain colored edge pixels.
boxes=[(23,518,230,727),(252,518,459,727),(481,518,693,727),(715,518,928,727),(950,518,1157,727),(1179,518,1385,727)]
for name,b in zip(['straight','corner','cross','cross-second','end','dot'],boxes):
 b=(b[0]+3,b[1]+3,b[2]-3,b[3]-3)
 a=np.array(im.crop(b).resize((192,192),Image.Resampling.LANCZOS));brightness=a.min(2);spread=a.max(2).astype(float)-a.min(2)
 alpha=np.minimum(np.clip((spread-12)/12,0,1),np.clip((190-brightness)/25,0,1))*255
 a=np.dstack((a,np.uint8(alpha)));Image.fromarray(a).save(out/(name+'.png'))
# Straight dirt width measured from source silhouette, retain original pixels and scale ports.
a=np.array(Image.open(out/'straight.png'));alpha=a[:,:,3];ys=np.where(alpha[:,96]>200)[0];print('straight opaque rows',ys[0],ys[-1]);cy=(ys[0]+ys[-1])/2;factor=72/(ys[-1]-ys[0]+1)
for name in ['straight','corner','cross','cross-second','end','dot']:
 raw=Image.open(out/(name+'.png'));raw.transform((192,192),Image.Transform.AFFINE,(1,0,0,0,1/factor,cy-96/factor),Image.Resampling.BICUBIC).save(out/(name+'.png')) if name=='straight' else None
# Explicit T: top half from horizontal straight, bottom half from first cross.
s=np.array(Image.open(out/'straight.png'));c=np.array(Image.open(out/'cross.png'));c[:96]=s[:96];Image.fromarray(c).save(out/'tee.png')
strip=Image.open(out/'straight.png').crop((6,48,186,144)).resize((96,96),Image.Resampling.LANCZOS)
ribbon=Image.new('RGBA',(192,96));ribbon.paste(strip,(0,0));ribbon.paste(strip.transpose(Image.Transpose.FLIP_LEFT_RIGHT),(96,0));ribbon.save(out/'ribbon.png')
# Same normalized random overlap recipe as the light alternative, new source only.
rng=np.random.default_rng(920752026);N=1024;S=176
src=im.crop((23,21,1385,490));patches=[]
for i in range(12):
 px=int(rng.integers(0,src.width-300));py=int(rng.integers(0,src.height-300))
 patches.append(np.asarray(src.crop((px,py,px+300,py+300)).resize((S,S),Image.Resampling.LANCZOS),dtype=float))
acc=np.zeros((N,N,3));weight=np.zeros((N,N));y,x=np.mgrid[:S,:S];w=np.maximum(.001,np.sin(np.pi*(x+.5)/S)**2*np.sin(np.pi*(y+.5)/S)**2)
for cy in range(-1,14):
 for cx in range(-1,14):
  px=int(cx*N/12+rng.uniform(-45,45))%N;py=int(cy*N/12+rng.uniform(-45,45))%N
  a=np.rot90(patches[int(rng.integers(len(patches)))],int(rng.integers(4)))
  if rng.random()<.5:a=a[:,::-1]
  yy=(np.arange(S)+py)%N;xx=(np.arange(S)+px)%N
  acc[np.ix_(yy,xx)]+=a*w[:,:,None];weight[np.ix_(yy,xx)]+=w
rgb=acc/weight[:,:,None];low=gaussian_filter(rgb,(30,30,0),mode='wrap');rgb=np.array([83,115,39])+(rgb-low)*.95
Image.fromarray(np.uint8(np.clip(rgb,0,255))).save(out/'grass-cache.png')
# Source seam evidence.
a=np.array(im.crop((23,21,1385,490)),dtype=float)
print('raw grass edge RGB mean difference X',abs(a[:,0]-a[:,-1]).mean(),'Y',abs(a[0]-a[-1]).mean())
a=np.array(Image.open(out/'cross.png'),dtype=float);b=np.array(Image.open(out/'cross-second.png'),dtype=float);print('cross pair mean absolute difference',abs(a-b).mean())
