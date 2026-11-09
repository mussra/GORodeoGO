"""Pose UV maps: view-specific body regions, carried by optical flow per frame.
Only offline work: the game samples a small RGB UV PNG while baking textures.
R/G encode canonical pixel x/y in half-pixel units; B marks mapped coat.
"""
from pathlib import Path
from PIL import Image
import cv2,numpy as np
# Reference region coordinates: head/neck/body. All views project to the same
# named atlas islands, so turning cannot project a neck mark onto the head.
REGIONS={
 'side':[(69,22,88,48),(57,31,74,61),(18,43,65,66)],
 'down':[(40,15,56,41),(40,34,56,47),(36,39,60,57)],
 'up':[(40,12,57,35),(43,29,55,42),(36,35,61,63)],
 'diag_down':[(61,11,77,36),(55,22,70,48),(27,29,63,56)],
 'diag_up':[(63,10,77,31),(57,19,70,43),(28,30,65,56)],
}
CANON=[(69,22,88,48),(57,31,74,61),(18,43,65,66)]
def uv_for(view,ref):
 h,w=ref.shape[:2];yy,xx=np.mgrid[:h,:w].astype(np.float32)
 uv=np.stack([xx,yy],-1);regions=REGIONS[view]
 # Body first, neck then head. Legs follow torso space below its belly.
 for idx in [2,1,0]:
  x0,y0,x1,y1=regions[idx];a,b,c,d=CANON[idx]
  select=(xx>=x0)&(xx<=x1)&(yy>=y0)&(yy<=(h if idx==2 else y1))
  # Don't use head rectangle below the jaw, or neck over the hindquarters.
  uv[...,0][select]=a+(xx[select]-x0)*(c-a)/(x1-x0)
  uv[...,1][select]=b+(yy[select]-y0)*(d-b)/(y1-y0)
 return uv
out=Path('art/horse_pose_uv');out.mkdir(exist_ok=True)
for view in REGIONS:
 folder=Path('art/world/wild_base')/('walk_'+view)
 ref=np.array(Image.open(folder/'frame_00.png').convert('RGBA'))
 # Grayscale carries outline + internal shading, alpha makes the exterior0.
 def gray(a):
  b=cv2.cvtColor(a[:,:,:3],cv2.COLOR_RGB2GRAY).astype(np.float32)*(a[:,:,3]/255.)
  return cv2.resize(b.astype(np.uint8),None,fx=4,fy=4,interpolation=cv2.INTER_CUBIC)
 gref=gray(ref);baseuv=uv_for(view,ref);h,w=ref.shape[:2]
 for i in range(12):
  cur=np.array(Image.open(folder/f'frame_{i:02}.png').convert('RGBA'))
  if i==0:flow=np.zeros((h,w,2),np.float32)
  else:
   flow=cv2.calcOpticalFlowFarneback(gray(cur),gref,None,.5,4,25,6,7,1.5,0)
   flow=cv2.resize(flow,(w,h),interpolation=cv2.INTER_AREA)/4
  yy,xx=np.mgrid[:h,:w].astype(np.float32)
  uv=cv2.remap(baseuv,xx+flow[...,0],yy+flow[...,1],cv2.INTER_LINEAR,borderMode=cv2.BORDER_REPLICATE)
  encoded=np.zeros((h,w,3),np.uint8);encoded[:,:,:2]=np.clip(np.round(uv*2),0,255).astype(np.uint8);encoded[:,:,2]=255
  target=out/('wild_walk_'+view);target.mkdir(exist_ok=True)
  Image.fromarray(encoded).save(target/f'frame_{i:02}.png')
 # Wild idle is the same side frame0. Preserve identity when stopping.
 if view=='side':
  target=out/'wild_side';target.mkdir(exist_ok=True)
  Image.open(out/'wild_walk_side/frame_00.png').save(target/'frame_00.png')
print('61 pose UV maps built')
