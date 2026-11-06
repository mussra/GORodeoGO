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
