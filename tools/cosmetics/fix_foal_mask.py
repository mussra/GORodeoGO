from PIL import Image,ImageDraw,ImageFilter
from pathlib import Path
import numpy as np
R=Path(__file__).resolve().parents[2];im=Image.open(R/'art/foal/base.png').convert('RGBA');w,h=im.size
# Coordinates drawn on a 598x692 inspection enlargement, then scaled to source.
def poly(polys):
 m=Image.new('L',(598,692));d=ImageDraw.Draw(m)
 for p in polys:d.polygon(p,fill=255)
 return m.resize((w,h),Image.Resampling.LANCZOS)
skin=Image.new('L',(598,692));d=ImageDraw.Draw(skin)
d.polygon([(124,430),(145,398),(221,377),(275,373),(292,354),(307,327),(309,280),(303,218),(290,183),(292,145),(286,109),(301,51),(323,15),(342,10),(358,32),(372,67),(382,111),(410,124),(453,129),(471,139),(488,164),(512,174),(526,193),(541,204),(545,229),(542,254),(537,276),(551,290),(579,300),(594,310),(598,336),(577,354),(546,355),(514,353),(475,347),(466,370),(456,393),(460,435),(460,467),(448,505),(445,551),(453,595),(443,618),(402,627),(383,607),(379,564),(370,540),(367,595),(380,623),(365,641),(317,638),(302,618),(303,571),(295,538),(277,525),(266,548),(265,584),(282,603),(280,625),(235,625),(214,608),(209,568),(196,540),(178,552),(175,591),(187,625),(174,643),(125,648),(112,628),(120,596),(128,565),(132,527),(126,496)],fill=255)
# Preserve eyes, nostrils, brows and hooves; all actual skin can follow coat.
d.ellipse((394,209,480,293),fill=0);d.ellipse((528,193,559,251),fill=0);d.polygon([(395,190),(415,162),(441,156),(457,164),(436,170),(414,181)],fill=0);d.ellipse((557,278,581,302),fill=0)
skin=skin.resize((w,h),Image.Resampling.LANCZOS)
mane=poly([[(0,495),(16,469),(22,425),(42,383),(75,354),(115,334),(154,338),(176,350),(195,380),(179,395),(166,426),(151,473),(135,508),(100,536),(65,547),(30,537),(0,521)],[(239,312),(251,279),(249,248),(254,216),(270,191),(285,170),(298,159),(303,183),(306,218),(303,254),(302,288),(293,322),(280,348),(265,367),(252,354)],[(362,87),(375,66),(393,48),(421,37),(441,38),(458,29),(484,34),(513,48),(533,65),(539,79),(548,86),(531,93),(517,99),(523,119),(516,132),(499,136),(479,123),(460,109),(430,106),(404,108),(385,104)]])
# White socks are marking, never mane. Recolor consistently with base skin in this prototype.
a=np.array(im);hsv=np.array(im.convert('HSV'));hh=hsv[:,:,0].astype(float)*360/255;ss=hsv[:,:,1]/255.;vv=hsv[:,:,2]/255.
yy,xx=np.mgrid[:h,:w];x=xx*598/w;y=yy*692/h
# Coat is the actual brown skin across body and face, not the white socks/blaze.
s=(hh>10)&(hh<48)&(ss>.38)&(vv>.16)&(a[:,:,3]>8)
# Preserve eyes/brow, hooves, nostrils, deepest dark outlines.
protect=poly([[(394,206),(429,197),(467,213),(484,247),(476,279),(451,298),(414,289),(394,261)],[(525,188),(548,185),(568,211),(560,244),(539,255),(525,238)],[(391,194),(409,164),(433,151),(451,155),(460,166),(435,177),(412,190)],[(0,650),(598,650),(598,692),(0,692)],[(103,634),(139,624),(180,628),(192,655),(103,670)],[(208,605),(242,603),(279,608),(283,643),(212,644)],[(301,635),(339,631),(380,637),(393,672),(303,677)],[(383,614),(411,605),(454,617),(470,654),(388,660)],[(551,273),(574,272),(586,289),(577,304),(555,299)]])
# Eye interiors are separate from coat, surrounding eyelids remain coat.
prot=np.array(protect)>100
face=(x>285)&(y<370)
eye=((x-437)/36)**2+((y-249)/43)**2<1
eye |= ((x-551)/15)**2+((y-221)/28)**2<1
eye |= ((x-569)/12)**2+((y-290)/10)**2<1
s &= ~(prot & ~face)
s &= ~eye
m=np.array(mane).astype(float)/255
# Cream mane and tail coverage extends to their complete boundaries.
mane_area=((x<200)&(y>325)&(y<553))|((x>225)&(x<313)&(y>147)&(y<377))|((x>355)&(y<145))
cream=(ss<.52)&(vv>.30)&mane_area&(a[:,:,3]>8)
m=np.maximum(m,cream.astype(float))
# Mane polygon must follow cream hair, never brown ears or skin underneath.
m *= (((a[:,:,0].astype(float)<a[:,:,1]*1.40)&(ss<.60)) | (y>145)).astype(float)
# Keep rump skin out of tail mask and include the slim cream edge of neck mane.
m[(x>132)&(x<200)&(y>350)&(y<505)&(a[:,:,0].astype(float)>a[:,:,1]*1.35)]=0
mane_edge=(x>237)&(x<310)&(y>188)&(y<362)&(ss<.64)&(a[:,:,0].astype(float)<a[:,:,1]*1.46)
m=np.maximum(m,mane_edge.astype(float))
# Trace the actual tail/body seam; dark outline pixels are not hair either.
seam=np.interp(y,[350,375,400,425,450,480,505],[194,181,166,155,148,144,132])
m[(y>350)&(y<510)&(x>seam)&(x<205)]=0
# The neck mane curls back over the coat at its lower edge.
neck_edge=poly([[(295,173),(304,190),(307,220),(307,253),(311,279),(318,302),(320,330),(312,351),(298,365),(279,375),(263,373),(281,349),(294,320),(301,288),(301,252),(301,215)]])
m=np.maximum(m,np.array(neck_edge)/255.)
s=s.astype(float)*(1-m)
# Retain actual cream blaze/muzzle by source color, not rectangular exclusion.
s = np.maximum(s,((hh>8)&(hh<48)&(ss>.28)&(vv>.2)&face&(a[:,:,3]>8)&~eye).astype(float)*(1-m))
# Cream markings have a lower red/green ratio than the brown base, even in shade.
cream_mark=(a[:,:,0].astype(float)<a[:,:,1]*1.34)&face
s[cream_mark]=0
# The muzzle is an intact cream marking, including its shaded edge.
s[(((x-551)/58)**2+((y-305)/48)**2<1)&face]=0
mask=np.zeros((h,w,3),dtype=np.uint8);mask[:,:,0]=(s*255).astype('uint8');mask[:,:,1]=(m*255).astype('uint8');mask[a[:,:,3]<8]=0
Image.fromarray(mask).filter(ImageFilter.GaussianBlur(1.05)).save(R/'art/horse_masks/foal/frame_00.png')
