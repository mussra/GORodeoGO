from PIL import Image,ImageDraw
import numpy as np
from pathlib import Path
R=Path(__file__).resolve().parents[2]
polys={'side':[(35,27),(59,27),(61,37),(60,48),(59,60),(59,67),(53,72),(45,69),(43,61),(37,58),(34,48)],'diag_down':[(34,26),(56,26),(58,31),(57,35),(59,39),(59,44),(58,48),(56,54),(56,61),(54,66),(46,66),(42,61),(41,56),(37,54),(34,47)],'diag_up':[(36,26),(56,26),(57,32),(57,37),(59,42),(58,47),(59,52),(58,59),(58,65),(56,70),(52,70),(52,64),(53,60),(51,57),(50,53),(45,51),(43,48),(43,46),(42,40),(36,37)],'down':[(28,24),(64,24),(64,32),(61,38),(59,40),(62,46),(64,53),(63,59),(58,59),(56,50),(54,42),(50,37),(44,37),(40,42),(37,51),(35,57),(30,56),(29,49),(32,42),(32,37)],'up':[(28,24),(65,24),(65,35),(62,42),(64,49),(64,59),(59,59),(57,50),(54,46),(40,46),(36,50),(34,58),(29,59),(29,49),(31,42)]}
y,x=np.mgrid[:96,:96]
for p in (R/'art/player').glob('*/*.png'):
 a=np.array(Image.open(p).convert('RGBA'));rgb=a[:,:,:3].astype(float);mx=rgb.max(2);mn=rgb.min(2);view=p.parent.name.removeprefix('walk_');view='side' if view in ['idle','stunned'] else view
 top=np.where(a[:30,:,3]>100)[0].min();dy=int(top)-{'side':9,'diag_down':6,'diag_up':6,'down':5,'up':5}[view]
 m=Image.new('L',(96,96));ImageDraw.Draw(m).polygon([(xx,yy+dy) for xx,yy in polys[view]],fill=255);rider=np.array(m)>0
 coat=(rgb[:,:,0]>rgb[:,:,1]*1.16)&(rgb[:,:,1]>rgb[:,:,2]*1.25)&(mx>95)&(y>30+dy)&~rider&(a[:,:,3]>0)
 region={'side':((x<25)&(y>40)&(y<76))|((x>58)&(x<75)&(y>25)&(y<51)),'diag_down':((x<28)&(y>35)&(y<65))|((x>56)&(x<70)&(y<45)),'diag_up':((x<39)&(y>45)&(y<79))|((x>54)&(x<65)&(y<43)),'down':(x>70),'up':(y>48)&(y<80)&(x>39)&(x<55)}[view]
 mane=region&(mx>120)&((mx-mn)<150)&(rgb[:,:,0]>rgb[:,:,2])&~rider&(a[:,:,3]>0)
 mask=np.zeros((96,96,3),dtype='uint8');mask[:,:,0]=coat*255;mask[:,:,1]=mane*255
 q=R/'art/horse_masks'/p.relative_to(R/'art/player');q.parent.mkdir(parents=True,exist_ok=True);Image.fromarray(mask).save(q)
