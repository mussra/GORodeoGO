"""Experimental UVs for review only, never loaded by gameplay."""
from pathlib import Path
from PIL import Image
import cv2,numpy as np
R=Path(__file__).resolve().parents[2]
regions={
'horse':{'side':[(68,24,86,49),(56,30,73,58),(18,42,65,65)],'down':[(40,22,55,39),(41,34,55,47),(36,37,59,57)],'up':[(40,15,55,34),(41,28,55,43),(35,33,61,60)],'diag_down':[(58,14,75,39),(49,24,65,48),(28,31,61,56)],'diag_up':[(58,12,74,34),(51,20,66,43),(27,29,61,55)]},
'rider':{'side':[(68,28,88,56),(55,35,73,63),(18,46,65,69)],'down':[(39,35,57,61),(39,53,57,68),(31,42,64,73)],'up':[(41,24,55,40),(41,36,55,53),(32,46,64,76)],'diag_down':[(57,27,80,57),(50,39,67,65),(25,42,60,66)],'diag_up':[(61,26,80,54),(55,33,73,62),(27,45,65,72)]}}
canon=[(69,22,88,48),(57,31,74,61),(18,43,65,66)]
def gray(a):return cv2.resize((cv2.cvtColor(a[:,:,:3],cv2.COLOR_RGB2GRAY)*(a[:,:,3]/255)).astype('uint8'),None,fx=4,fy=4,interpolation=cv2.INTER_CUBIC)
y,x=np.mgrid[:96,:96].astype('float32')
for k in regions:
 for v,rects in regions[k].items():
  base=np.stack((x,y),-1)
  for idx in [2,1,0]:
   x0,y0,x1,y1=rects[idx];a,b,c,d=canon[idx];sel=(x>=x0)&(x<=x1)&(y>=y0)&(y<=(96 if idx==2 else y1));base[:,:,0][sel]=a+(x[sel]-x0)*(c-a)/(x1-x0);base[:,:,1][sel]=b+(y[sel]-y0)*(d-b)/(y1-y0)
  folder=R/f'art/experimental/pixellab/{k}/{v}';ref=np.array(Image.open(folder/'frame_00.png').convert('RGBA'));gref=gray(ref)
  for i in range(9):
   a=np.array(Image.open(folder/f'frame_{i:02}.png').convert('RGBA'));flow=cv2.calcOpticalFlowFarneback(gray(a),gref,None,.5,4,25,6,7,1.5,0);flow=cv2.resize(flow,(96,96),interpolation=cv2.INTER_AREA)/4
   uv=cv2.remap(base,x+flow[:,:,0],y+flow[:,:,1],cv2.INTER_LINEAR,borderMode=cv2.BORDER_REPLICATE);out=np.zeros((96,96,3),np.uint8);out[:,:,:2]=np.clip(np.round(uv*2),0,255);out[:,:,2]=255
   dest=R/f'art/experimental/pixellab_preview_uv/{k}/{v}';dest.mkdir(parents=True,exist_ok=True);Image.fromarray(out).save(dest/f'frame_{i:02}.png')
print('90 experimental preview maps')
