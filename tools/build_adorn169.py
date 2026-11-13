"""WIP semantic adorn masks, derived only from supplied art. Not yet used in game.
R: thin bands on actual pale lower legs. G: boot cuff/toe metal.
Frame-zero boot regions follow each rig through source optical flow. Audit every
pose visually before production; no source image is changed by this script.
"""
from pathlib import Path
import numpy as np, cv2, hashlib,json
from PIL import Image, ImageDraw
ROOT=Path(__file__).resolve().parents[1];OUT=ROOT/'art/adorn169';audit=[]
def gray(a):
 return cv2.resize((cv2.cvtColor(a[:,:,:3],cv2.COLOR_RGB2GRAY)*(a[:,:,3]/255)).astype('uint8'),None,fx=4,fy=4,interpolation=cv2.INTER_CUBIC)
def bands(eligible):
 n,labels,stats,_=cv2.connectedComponentsWithStats(eligible.astype('uint8'));out=np.zeros(eligible.shape,np.uint8)
 for k in range(1,n):
  if stats[k,cv2.CC_STAT_AREA]<3:continue
  comp=labels==k
  for x in np.where(comp.any(0))[0]:out[np.where(comp[:,x])[0][:5],x]=255
 return out
# Per source-coordinate rig, not world-space positions.
BOOT={
 'side':[(51,60,56,62),(54,65,59,67)],
 'down':[(31,50,36,51),(31,56,36,57),(60,50,64,51),(60,56,64,57)],
 'up':[(30,50,35,51),(30,56,35,57),(60,50,65,51),(60,56,65,57)],
 'diag_down':[(42,50,48,52),(42,56,49,58)],
 'diag_up':[(55,59,60,61),(57,63,62,65)],
 'drink':[(48,59,54,60),(52,66,57,67)]}
def group(kind,view,sources,masks,outs):
 ref=np.array(Image.open(ROOT/sources[0]).convert('RGBA'));h,w=ref.shape[:2];base=Image.new('L',(w,h));d=ImageDraw.Draw(base)
 if kind!='horse':
  for box in BOOT[view]:d.rectangle(box,fill=255)
 base=np.array(base);y,x=np.mgrid[:h,:w].astype('float32');gref=gray(ref)
 for i,(src,mp,op) in enumerate(zip(sources,masks,outs)):
  a=np.array(Image.open(ROOT/src).convert('RGBA'));m=np.array(Image.open(ROOT/mp).convert('RGB'));yy,xx=np.mgrid[:h,:w]
  coat=(m[:,:,0]>100)&(m[:,:,1]<100)&(a[:,:,3]>100)
  eligible=coat&(yy>((67 if view=='side' else 54) if kind=='horse' else 65))&(a[:,:,0]>110)&(a[:,:,2]>.64*a[:,:,0])&(a[:,:,1]>.75*a[:,:,0])
  if src.startswith('art/player/'):
   lp=ROOT/src.replace('art/player/','art/lower_legs_masks/')
   eligible=(np.array(Image.open(lp).convert('RGB'))[:,:,0]>100)&(a[:,:,3]>100)&(yy>65)
  if view=='drink':eligible &= xx<80
  leg=bands(eligible)
  if i:
   flow=cv2.calcOpticalFlowFarneback(gray(a),gref,None,.5,4,25,6,7,1.5,0);flow=cv2.resize(flow,(w,h),interpolation=cv2.INTER_AREA)/4
   boot=cv2.remap(base,x+flow[:,:,0],y+flow[:,:,1],cv2.INTER_NEAREST,borderMode=cv2.BORDER_CONSTANT)
  else:boot=base.copy()
  safe=(a[:,:,3]>100)&(a[:,:,0]>a[:,:,2]*1.25)&(a[:,:,0]<180)&(a[:,:,0]>40)&~coat&(m[:,:,1]<100)
  boot=np.where(safe,boot,0).astype('uint8');leg=np.where(boot>0,0,leg)
  rgb=np.stack([leg,boot,np.zeros((h,w),np.uint8)],2);out=OUT/op;out.parent.mkdir(parents=True,exist_ok=True);Image.fromarray(rgb).save(out)
  audit.append(dict(source=src,mask=str(out.relative_to(ROOT)),sha256=hashlib.sha256((ROOT/src).read_bytes()).hexdigest(),leg_pixels=int((leg>0).sum()),boot_pixels=int((boot>0).sum()),kind=kind,view=view,frame=i))
for kind in ['rider','horse']:
 for view in ['side','down','up','diag_down','diag_up']:
  group(kind,view,[f'art/experimental/pixellab/{kind}/{view}/frame_{i:02}.png' for i in range(9)],[f'art/experimental/pixellab_masks_review_v5/{kind}/{view}/color_{i:02}.png' for i in range(9)],[Path(f'{kind}/{view}/{i:02}.png') for i in range(9)])
for view in ['side','down','up','diag_down','diag_up']:
 group('rider',view,[f'art/player/jump_{view}/frame_{i:02}.png' for i in range(8)],[f'art/horse_masks/jump_{view}/frame_{i:02}.png' for i in range(8)],[Path(f'jump_{view}/{i:02}.png') for i in range(8)])
group('rider','side',['art/player/stunned/frame_0.png'],['art/horse_masks/stunned/frame_0.png'],[Path('stunned/00.png')])
group('rider','drink',[f'art/experimental/drink_preview83/pose_{i}.png' for i in range(2)],[f'art/experimental/drink_preview83/color_{i}.png' for i in range(2)],[Path(f'drink/{i:02}.png') for i in range(2)])
(OUT/'audit.json').write_text(json.dumps(audit,indent=2));print('WIP masks',len(audit));print('Empty legs',[(a['kind'],a['view'],a['frame']) for a in audit if not a['leg_pixels']]);print('Empty visible boots',[(a['view'],a['frame']) for a in audit if a['kind']=='rider' and not a['boot_pixels']])
