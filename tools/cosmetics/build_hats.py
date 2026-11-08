"""Reversible color variants. Never writes art/player originals."""
from pathlib import Path
from PIL import Image
import numpy as np, cv2
ROOT=Path(__file__).resolve().parents[2]

def recolor(image,kind,anim=''):
 a=np.array(image.convert('RGBA'));hsv=cv2.cvtColor(a[:,:,:3],cv2.COLOR_RGB2HSV);yy,xx=np.mgrid[:a.shape[0],:a.shape[1]]
 # Hat sits above the face in every existing view. Exclude gold medallion
 # by hue and horse ears by the hat's horizontal extent.
 # gallop_side (12-frame IA gallop, 8-nov-2026): the rider sits further left,
 # so the hat band must reach x~17; the horse ears stay right of x~64 there.
 h,w=a.shape[:2]
 if anim=='gallop_side':mask=(yy<h*.30)&(xx>w*.13)&(xx<w*.66)&(hsv[:,:,0]<19)&(hsv[:,:,1]>90)&(a[:,:,3]>0)
 else:mask=(yy<h*.30)&(xx>w*.26)&(xx<w*.72)&(hsv[:,:,0]<19)&(hsv[:,:,1]>90)&(a[:,:,3]>0)
 v=hsv.copy()
 if kind=='blue':
  v[:,:,0][mask]=108;v[:,:,1][mask]=(v[:,:,1][mask]*.65).astype('uint8');v[:,:,2][mask]=(v[:,:,2][mask]*.72).astype('uint8')
 else:
  v[:,:,0][mask]=22;v[:,:,1][mask]=(v[:,:,1][mask]*.30).astype('uint8');v[:,:,2][mask]=np.minimum(255,v[:,:,2][mask].astype(float)*.75+70).astype('uint8')
 rgb=cv2.cvtColor(v,cv2.COLOR_HSV2RGB);a[:,:,:3][mask]=rgb[mask]
 return Image.fromarray(a)
if __name__=='__main__':
 for kind in ('blue','sand'):
  for p in sorted((ROOT/'art/player').glob('*/*.png')):
   target=ROOT/'art/player_hats'/kind/p.relative_to(ROOT/'art/player');target.parent.mkdir(parents=True,exist_ok=True);recolor(Image.open(p),kind,p.parent.name).save(target)
