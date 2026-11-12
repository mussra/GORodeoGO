"""Derived semantic masks for chosen B, from supplied source poses, never new art.
Manual reference hind-leg regions per rig/view, then source optical flow carries
those regions through the gait. Clip to reviewed coat and alpha on every pose.
Front-facing poses hide the hind legs, so do not paint their forelegs white.
No model/network/generation and no per-frame runtime optical-flow work.
"""
from pathlib import Path
import numpy as np,cv2
from PIL import Image
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'art/rear_stockings122'
def smooth(a,b,x):
 t=np.clip((x-a)/(b-a),0,1);return t*t*(3-2*t)
def field(kind,view,shape):
 h,w=shape;y,x=np.mgrid[:h,:w].astype('float32');x=x*96/w;y=y*96/h
 if view=='down':return np.zeros((h,w),np.float32)
 if kind=='foal':return (1-smooth(48+np.sin(y*.4)*2,50+np.sin(y*.4)*2,x))*smooth(72+np.sin(x*.65)*2,74+np.sin(x*.65)*2,y)
 if view=='up':return smooth((64 if kind=='rider' else 53)+np.sin(x*.65)*2,(66 if kind=='rider' else 55)+np.sin(x*.65)*2,y)
 if kind=='drink':edge=40;top=58
 elif view=='diag_down':edge=41 if kind=='rider' else 43;top=59 if kind=='rider' else 51
 elif view=='diag_up':edge=48 if kind=='rider' else 46;top=65 if kind=='rider' else 52
 else:edge=39;top=58
 return (1-smooth(edge-1+np.sin(y*.4)*2,edge+1+np.sin(y*.4)*2,x))*smooth(top-1+np.sin(x*.65)*3,top+1+np.sin(x*.65)*3,y)
# Reviewed lower-leg envelopes for folded/extended phases. Optical flow alone
# loses thin crossing limbs. These envelopes preserve each actual hind leg;
# coat clipping excludes tack/mane and upper border still follows the source.
BOUNDARIES={
 ('rider','side'):[40,40,42,46,51,51,51,44,40],
 ('rider','diag_down'):[41,40,43,45,46,51,56,47,41],
 ('rider','diag_up'):[48,49,50,52,53,46,48,48,48],
 ('horse','side'):[40,40,43,46,51,51,52,45,40],
 ('horse','diag_down'):[43,44,48,47,48,52,55,48,43],
 ('horse','diag_up'):[46,48,50,52,53,53,48,47,46],
}
def lower_envelope(kind,view,i,h,w):
 if (kind,view) not in BOUNDARIES:return np.zeros((h,w),np.float32)
 y,x=np.mgrid[:h,:w].astype('float32');x=x*96/w;y=y*96/h
 top=66 if kind=='rider' else (65 if view=='side' else 57)
 edge=BOUNDARIES[kind,view][i]
 return (1-smooth(edge-.5,edge+.5,x))*smooth(top,top+2,y)
def gray(a):return cv2.resize((cv2.cvtColor(a[:,:,:3],cv2.COLOR_RGB2GRAY)*(a[:,:,3]/255)).astype('uint8'),None,fx=4,fy=4,interpolation=cv2.INTER_CUBIC)
def group(kind,view,sources,masks,paths):
 ref=np.array(Image.open(sources[0]).convert('RGBA'));h,w=ref.shape[:2];base=field(kind,view,(h,w));y,x=np.mgrid[:h,:w].astype('float32');gref=gray(ref)
 for i,(source,mask,path) in enumerate(zip(sources,masks,paths)):
  a=np.array(Image.open(source).convert('RGBA'));m=np.array(Image.open(mask).convert('RGB'))
  if i==0:coverage=base
  else:
   flow=cv2.calcOpticalFlowFarneback(gray(a),gref,None,.5,4,25,6,7,1.5,0);flow=cv2.resize(flow,(w,h),interpolation=cv2.INTER_AREA)/4
   coverage=cv2.remap(base,x+flow[:,:,0],y+flow[:,:,1],cv2.INTER_LINEAR,borderMode=cv2.BORDER_CONSTANT)
  # Semantic mask never touches mane, rider, hooves outside coat, or background.
  if kind in ["rider","horse"] and len(sources)==9:coverage=np.maximum(coverage,lower_envelope(kind,view,i,h,w))
  coverage*=((m[:,:,0]>100)&(m[:,:,0]>m[:,:,1])&(a[:,:,3]>0))
  out=OUT/path;out.parent.mkdir(parents=True,exist_ok=True);Image.fromarray(np.uint8(np.clip(coverage*255,0,255)),'L').save(out)
for kind in ['rider','horse']:
 for view in ['side','down','up','diag_down','diag_up']:
  files=[ROOT/f'art/experimental/pixellab/{kind}/{view}/frame_{i:02}.png' for i in range(9)]
  masks=[ROOT/f'art/experimental/pixellab_masks_review_v5/{kind}/{view}/color_{i:02}.png' for i in range(9)]
  group(kind,view,files,masks,[Path(f'pixellab/{kind}/{view}/frame_{i:02}.png') for i in range(9)])
for anim in ['idle','jump_side','jump_down','jump_up','jump_diag_down','jump_diag_up','stunned']:
 files=sorted((ROOT/f'art/player/{anim}').glob('*.png'));view=anim.removeprefix('jump_') if anim.startswith('jump_') else 'side'
 group('rider',view,files,[ROOT/f'art/horse_masks/{anim}/{p.name}' for p in files],[Path(f'player/{anim}/{p.name}') for p in files])
for pose in range(2):
 group('drink','side',[ROOT/f'art/experimental/drink_preview83/pose_{pose}.png'],[ROOT/f'art/experimental/drink_preview83/color_{pose}.png'],[Path(f'drink/pose_{pose}.png')])
group('foal','side',[ROOT/'art/foal/base.png'],[ROOT/'art/horse_masks/foal/frame_00.png'],[Path('foal/base.png')])
print('derived masks:',len(list(OUT.rglob('*.png'))))
