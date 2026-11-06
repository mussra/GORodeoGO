from PIL import Image,ImageDraw,ImageFilter
from pathlib import Path
import cv2,numpy as np
O=Path(__file__).parent;S=8
src=Image.open(O/'original/side.png').convert('RGBA').transpose(Image.Transpose.FLIP_LEFT_RIGHT).resize((96*S,96*S),Image.Resampling.LANCZOS)
def masked(poly):
 m=Image.new('L',src.size);ImageDraw.Draw(m).polygon([(x*S,y*S) for x,y in poly],fill=255)
 a=np.minimum(np.array(m),np.array(src.getchannel('A')));im=src.copy();im.putalpha(Image.fromarray(a));return im
# Full upper silhouette, including original curved shoulder and rump contours.
body=masked([(0,0),(96,0),(96,77),(74,77),(70,72),(66,69),(62,67),(58,65),(54,65),(51,68),(48,70),(39,71),(34,69),(29,70),(24,72),(20,71),(17,68),(17,64),(0,64)])
clean=Image.open(O.parent/'support/torso.png').convert('RGBA').resize(src.size,Image.Resampling.LANCZOS)
arr=np.array(clean);key=(arr[:,:,0].astype(float)+arr[:,:,2].astype(float))/2-arr[:,:,1];arr[:,:,3]=np.minimum(arr[:,:,3],np.clip((120-key)*4,0,255).astype(np.uint8));clean=Image.fromarray(arr).filter(ImageFilter.GaussianBlur(S*.20))
# Preserve all original pixels above horse belly; borrow only newly reconstructed underside.
cm=Image.new('L',src.size);cd=ImageDraw.Draw(cm);cd.polygon([(21*S,54*S),(71*S,54*S),(71*S,73*S),(21*S,73*S)],fill=255);cm=cm.filter(ImageFilter.GaussianBlur(S))
body=Image.composite(clean,body,cm)
arr=np.array(body);n,labels,stats,_=cv2.connectedComponentsWithStats((arr[:,:,3]>60).astype(np.uint8));keep=1+np.argmax(stats[1:,cv2.CC_STAT_AREA]);arr[:,:,3][labels!=keep]=0;body=Image.fromarray(arr)
legs=[
 {'poly':[(31,59),(37,62),(33,68),(26,73),(25,80),(24,87),(21,90),(17,90),(14,86),(15,78),(17,71),(22,66)],'chain':[(30,63),(20,74),(20,88)]},
 {'poly':[(29,65),(37,65),(39,73),(40,80),(43,86),(41,93),(31,93),(29,88),(31,81),(29,74)],'chain':[(33,67),(35,78),(36,91)]},
 {'poly':[(58,55),(66,56),(70,62),(69,68),(72,73),(73,82),(77,87),(75,92),(67,93),(64,88),(65,81),(64,74),(60,71),(56,65)],'chain':[(62,61),(68,74),(70,91)]},
 {'poly':[(56,64),(63,65),(65,71),(61,78),(60,83),(59,89),(55,92),(46,92),(47,85),(51,79),(54,73)],'chain':[(59,66),(59,77),(53,90)]},
]
def warp(im,a,b,c,d,upper=False):
 a,b,c,d=map(lambda p:np.array(p,float)*S,[a,b,c,d]);v=b-a;w=d-c
 A=np.array([[v[0],-v[1]],[v[1],v[0]]]);B=np.array([[w[0],-w[1]*(1.05 if upper else .72)],[w[1],w[0]*(1.05 if upper else .72)]]);M=B@np.linalg.inv(A);t=c-M@a
 arr=np.array(im)
 if upper:
  yy,xx=np.mgrid[:im.height,:im.width].astype(np.float32);u=v/np.linalg.norm(v);perp=np.array([-u[1],u[0]]);along=((xx-a[0])*u[0]+(yy-a[1])*u[1]);side=(xx-a[0])*perp[0]+(yy-a[1])*perp[1]
  factor=1.0+.35*np.clip(1.0-along/np.linalg.norm(v),0,1)**1.1
  px=a[0]+along*u[0]+side/factor*perp[0];py=a[1]+along*u[1]+side/factor*perp[1]
  arr=cv2.remap(arr,px.astype(np.float32),py.astype(np.float32),cv2.INTER_CUBIC)
 return Image.fromarray(cv2.warpAffine(arr,np.column_stack([M,t]),src.size,flags=cv2.INTER_CUBIC))
def limb(j,target):
 leg=legs[j];im=masked(leg['poly']);a,b,c=map(lambda p:np.array(p,float),leg['chain']);out=Image.new('RGBA',src.size)
 # Separate two painted bones at shared joint; each keeps full outline and original texture.
 yy,xx=np.mgrid[0:src.height,0:src.width];vec=c-a;vec/=np.linalg.norm(vec);proj=(xx/S-b[0])*vec[0]+(yy/S-b[1])*vec[1]
 for k,(u,v) in enumerate([(a,b),(b,c)]):
  arr=np.array(im);start=((xx/S-a[0])*vec[0]+(yy/S-a[1])*vec[1]);arr[:,:,3]=(arr[:,:,3]*np.clip((start+1.0)/2,0,1)).astype(np.uint8);weight=np.clip((1.6-proj)/2.4,0,1) if k==0 else np.clip((proj+1.6)/2.4,0,1);arr[:,:,3]=(arr[:,:,3]*weight).astype(np.uint8)
  uv=v-u;length=np.linalg.norm(uv);uv=uv/length;t=((xx/S-u[0])*uv[0]+(yy/S-u[1])*uv[1])/length;side=abs((xx/S-u[0])*uv[1]-(yy/S-u[1])*uv[0]);width=((5.4-2.0*np.clip(t,0,1)) if k==0 and j in (2,3) else (3.4 if k==0 else 3.8)+np.clip(t,0,1)*(0 if k==0 else 1.2));trim=np.clip((width+.7-side)/.7,0,1);arr[:,:,3]=(arr[:,:,3]*trim).astype(np.uint8)
  out.alpha_composite(warp(Image.fromarray(arr),u,v,target[k],target[k+1],upper=(k==0 and j in (2,3))))
 if j in (1,3):
  arr=np.array(out);arr[:,:,:3]=(arr[:,:,:3].astype(float)*.78).astype(np.uint8);out=Image.fromarray(arr)
 arr=np.array(out);n,labels,stats,_=cv2.connectedComponentsWithStats((arr[:,:,3]>100).astype(np.uint8));
 if n>1:
  keep=1+np.argmax(stats[1:,cv2.CC_STAT_AREA]);arr[:,:,3][labels!=keep]=0;out=Image.fromarray(arr)
 return out
tail=masked([(70,42),(96,42),(96,77),(73,77),(73,65),(70,57)])
arr=np.array(body);tm=np.array(tail.getchannel('A'));arr[:,:,3][tm>100]=0;body=Image.fromarray(arr)
import json,sys
pose_index=int(sys.argv[1]) if len(sys.argv)>1 else 0
guide=json.loads((O.parent/'support/corrected-guide.json').read_text())
guide[10][0]=[[43,41],[25,48],[29,62]];guide[10][1]=[[49,41],[34,53],[20,66]]
target=[[(29,61),(18.8,69.5),(9.45,77.15)],[(33,61),(33.85,76.3),(31.3,84.8)],[(62,60),(70.5,69.35),(70.5,83.8)],[(66,59),(77.9,64.95),(83.85,75.15)]]
if pose_index:
 anchors=[(29,61),(29,61),(62,60),(62,60)];target=[[(anchors[j][0]+(x-guide[pose_index][0 if j<2 else 2][0][0])*.85,anchors[j][1]+(y-guide[pose_index][0 if j<2 else 2][0][1])*.85) for x,y in chain] for j,chain in enumerate(guide[pose_index])]
target=[[(chain[0][0]+(x-chain[0][0])*1.10,chain[0][1]+(y-chain[0][1])*1.12) for x,y in chain] for chain in target]
im=Image.new('RGBA',src.size);im.alpha_composite(tail)
for j in (1,3):
 part=limb(j,target[j]);arr=np.array(part);yy,xx=np.mgrid[0:src.height,0:src.width];root=np.array(target[j][0])*S;dist=np.hypot(xx-root[0],yy-root[1]);arr[:,:,3]=(arr[:,:,3]*np.clip(dist/(4*S),0,1)).astype(np.uint8);im.alpha_composite(Image.fromarray(arr))
im.alpha_composite(body)
for j in (0,2):
 part=limb(j,target[j]);arr=np.array(part);yy,xx=np.mgrid[0:src.height,0:src.width];root=np.array(target[j][0])*S;dist=np.hypot(xx-root[0],yy-root[1]);arr[:,:,3]=(arr[:,:,3]*np.clip(dist/(4*S),0,1)).astype(np.uint8);im.alpha_composite(Image.fromarray(arr))
# Length adjustment is a moderate trial, not a stated user percentage.
# Blend original torso back over the inner edge of the near hind root.
yy,xx=np.mgrid[0:src.height,0:src.width];root=np.array(target[2][0])*S;dist=np.hypot(xx-root[0],yy-root[1]);ba=np.array(body);mask=np.clip((10*S-dist)/(5*S),0,1)*ba[:,:,3]/255;patch=body.copy();patch.putalpha(Image.fromarray((mask*255).astype(np.uint8)));im.alpha_composite(patch)
# Restore upper torso over roots using original curved body, feathered lower edge.
m=Image.new('L',src.size);d=ImageDraw.Draw(m);d.polygon([(0,0),(96*S,0),(96*S,58*S),(73*S,59*S),(68*S,63*S),(61*S,62*S),(55*S,61*S),(51*S,66*S),(37*S,67*S),(31*S,63*S),(25*S,61*S),(0,59*S)],fill=255);m=m.filter(ImageFilter.GaussianBlur(S*.65));top=body.copy();top.putalpha(Image.fromarray(np.minimum(np.array(top.getchannel('A')),np.array(m))));im.alpha_composite(top)
# Review-only continuous near haunch: a tapered muscle bridge follows the unchanged upper bone.
a=np.array(target[2][0],float);b=np.array(target[2][1],float);v=b-a;length=np.linalg.norm(v);u=v/length;normal=np.array([-u[1],u[0]])
yy,xx=np.mgrid[:src.height,:src.width].astype(float);along=(xx/S-a[0])*u[0]+(yy/S-a[1])*u[1];across=(xx/S-a[0])*normal[0]+(yy/S-a[1])*normal[1];t=np.clip(along/(length*.82),0,1)
width=6.2*(1-t)+2.8*t;coverage=np.clip((width-abs(across))/.8,0,1)*np.clip((along+8)/3,0,1)*np.clip((length*.82-along)/2,0,1)
# Sample the same painted orange haunch, avoiding a new flat color.
source=np.array(body);mapx=(64+across*.7)*S;mapy=(54+np.clip(along,-5,7)*.35)*S
paint=cv2.remap(source,mapx.astype(np.float32),mapy.astype(np.float32),cv2.INTER_CUBIC);# Keep a soft upper highlight and darker taper rather than a flat orange bridge.
shade=1.0-.12*np.clip(along/(length*.82),0,1)-.07*np.clip(abs(across)/np.maximum(width,1),0,1)**2
paint[:,:,:3]=np.clip(paint[:,:,:3].astype(float)*shade[:,:,None],0,255).astype(np.uint8)
paint[:,:,3]=(coverage*paint[:,:,3]).astype(np.uint8)
im.alpha_composite(Image.fromarray(paint))
# Tail covers the rear root, but not lower limb/hoof.
tailtop=tail.copy();ta=np.array(tailtop);yy,xx=np.mgrid[0:src.height,0:src.width];ta[:,:,3]=(ta[:,:,3]*np.clip((66-yy/S)/3,0,1)).astype(np.uint8);im.alpha_composite(Image.fromarray(ta))
# Vertical suspension follows reference shoulder height, without pinning individual hooves.
dy=(guide[pose_index][0][0][1]-48)*.85
shift=Image.new('RGBA',im.size);shift.alpha_composite(im,(0,round(dy*S)));im=shift
im.save(O/f'pose{pose_index+1:02d}-large.png');im.resize((96,96),Image.Resampling.LANCZOS).save(O/f'frame_{pose_index:02d}.png');body.save(O/'body.png')
