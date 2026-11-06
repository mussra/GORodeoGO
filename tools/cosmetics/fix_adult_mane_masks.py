from pathlib import Path
from PIL import Image,ImageDraw
import numpy as np
R=Path(__file__).resolve().parents[2]
# Tail ends are traced per frame. The adjacent white sock is not tail hair.
ends=[[(0,76),(18,76),(21,63),(24,60)],[(0,76),(18,76),(21,63),(24,59)],[(0,75),(17,75),(19,64),(23,58)],[(0,75),(17,75),(19,65),(23,58)],[(0,75),(19,75),(20,65),(23,58)],[(0,75),(18,75),(20,65),(24,58)],[(0,75),(22,75),(23,65),(25,60)],[(0,75),(22,75),(23,65),(25,60)],[(0,69),(21,69),(22,61),(25,56)],[(0,69),(21,69),(22,61),(25,56)],[(0,70),(21,70),(22,62),(25,56)],[(0,69),(21,69),(22,61),(25,56)]]
for anim in ['walk_side','idle','stunned']:
 for p in (R/'art/horse_masks'/anim).glob('*.png'):
  i=int(p.stem.split('_')[-1]);i=i if anim=='walk_side' else 0
  a=np.array(Image.open(p));m=Image.new('L',(96,96));d=ImageDraw.Draw(m)
  d.polygon([(0,38),(25,38)]+list(reversed(ends[i])),fill=255)
  keep=np.array(m)>0;yy,xx=np.mgrid[:96,:96]
  a[:,:,1][(xx<32)&~keep]=0
  Image.fromarray(a).save(p)
# Bright cream rear socks must keep their source paint after geometry rebuilds.
for p in (R/'art/horse_masks/walk_side').glob('*.png'):
 a=np.array(Image.open(p));src=np.array(Image.open(R/'art/player/walk_side'/p.name).convert('RGBA'))/255.0
 yy,xx=np.mgrid[:96,:96]
 socks=(xx>=19)&(xx<29)&(yy>=69)&(yy<88)&(src[:,:,3]>.9)&(src[:,:,0]>.6)&(src[:,:,1]>.5)&(src[:,:,2]>.4)&(np.abs(src[:,:,0]-src[:,:,2])<.3)
 a[socks]=0;Image.fromarray(a).save(p)
