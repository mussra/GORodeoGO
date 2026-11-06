from PIL import Image,ImageDraw
from pathlib import Path
import numpy as np,cv2,json
R=Path(__file__).resolve().parents[3];O=Path('/tmp/frontal-gallop');O.mkdir(exist_ok=True);S=8
im=Image.open(Path(__file__).parent/'approved-base.png').convert('RGBA').resize((768,768),Image.Resampling.LANCZOS);a=np.array(im);rgb=a[:,:,:3].astype(float);poss=(rgb.min(2)>207)&(rgb.max(2)-rgb.min(2)<28);_,lab=cv2.connectedComponents(poss.astype('uint8'));a[lab==lab[0,0],3]=0;im=Image.fromarray(a)
G=np.array(json.loads((R/'tools/gallop_source/support/corrected-guide.json').read_text()),float)
G[10,0]=[[43,41],[25,48],[29,62]];G[10,1]=[[49,41],[34,53],[20,66]]
# Pixel-space rig and hand-painted material ownership on approved new base.
P=[[(28,54),(33,54),(33,59),(33,63),(30,65),(27,64),(26,61)],[(31,54),(39,54),(40,61),(41,67),(42,72),(37,74),(32,71),(31,65)],[(43,57),(52,58),(53,65),(54,70),(57,75),(56,79),(50,80),(46,77),(45,71),(46,65)],[(52,58),(61,59),(62,65),(62,71),(66,76),(69,83),(70,90),(66,92),(59,90),(57,85),(57,80),(54,74),(52,67)]]
chains=np.array([[(30,55),(29,59),(30,62)],[(35,55),(35,62),(36,69)],[(48,59),(49,67),(51,75)],[(56,60),(59,72),(64,86)]],float)
P[0]=P[1];chains[0]=chains[1]
def poly(p):
 m=Image.new('L',im.size);ImageDraw.Draw(m).polygon([(x*S,y*S)for x,y in p],fill=255);return np.array(m)
parts=[]
for p in P:
 q=a.copy();q[:,:,3]=np.minimum(q[:,:,3],poly(p));parts.append(q)
body=a.copy()
for part in parts:body[:,:,3]=np.minimum(body[:,:,3],255-part[:,:,3])
body[np.mgrid[:768,:768][0]>64*S,3]=0
# Torso cap retains original rump, chest, tack, boots and all rider pixels.
cap=a.copy();cap[:,:,3]=np.minimum(cap[:,:,3],poly([(0,0),(96,0),(96,53),(66,53),(65,59),(61,62),(57,63),(53,60),(48,59),(44,56),(41,56),(35,57),(31,56),(0,57)]))
yy,xx=np.mgrid[:768,:768];x=xx/S;y=yy/S
rider=poly([(32,24),(55,24),(58,30),(58,34),(56,40),(56,47),(54,53),(51,59),(50,63),(46,63),(43,61),(42,56),(39,55),(36,50),(33,43)])>0
# Explicit ownership confines hair to mane/tail, socks and muzzle remain neutral.
hair_region=(poly([(12,38),(29,30),(36,33),(34,44),(30,51),(26,56),(14,56)])>0)|(poly([(53,29),(61,26),(70,29),(74,34),(71,35),(68,33),(68,34),(65,35),(62,45),(59,50),(54,46)])>0)
cream=(rgb[:,:,0]>135)&(rgb[:,:,1]>115)&(rgb[:,:,2]>75)&(rgb.max(2)-rgb.min(2)<155)
hair=hair_region&cream&~rider&(a[:,:,3]>0)
coat=(rgb[:,:,0]>rgb[:,:,1]*1.14)&(rgb[:,:,1]>rgb[:,:,2]*1.25)&(rgb.max(2)>85)&(y>27)&~rider&~hair&(a[:,:,3]>0)
# Source-space socks remain uncoloured while their geometry follows each limb.
sock_region=np.zeros((768,768),bool)
for p,cut in zip(P,[58,60,67,73]):sock_region|=(poly(p)>0)&(y>=cut)
coat &=~sock_region
# Saddle, boot, reins and stirrup ownership independent of coat.
coat &=~(poly([(38,38),(45,39),(49,45),(51,52),(50,59),(50,62),(46,64),(42,62),(41,56),(38,54),(37,49)])>0)
# Bridles/reins/eyes/hooves/socks are not coat.
coat &=~((x>69)&(y>41)&(y<54));coat &=~((x>65)&(y<43)&(y>35)&(rgb.max(2)<135))
material=np.zeros_like(a);material[:,:,0]=coat*255;material[:,:,1]=hair*255;material[:,:,3]=a[:,:,3]
def warp(ar,M):return cv2.warpAffine(ar,M,(768,768),flags=cv2.INTER_CUBIC)
# Reuse accepted painted limb source, not the new static pose's bent/stubby bones.
roots=chains[:,0].copy()
old=Image.open(R/'tools/gallop_source/original/diag_down.png').convert('RGBA').resize((768,768),Image.Resampling.LANCZOS);oa=np.array(old);org=oa[:,:,:3].astype(float)
oldP=[[(25,57),(32,58),(31,66),(31,73),(29,77),(24,76),(22,72),(23,66)],[(30,57),(39,58),(39,67),(38,73),(41,80),(42,87),(33,89),(29,83),(31,76),(30,69)],[(50,60),(57,61),(57,69),(56,77),(54,83),(48,83),(45,79),(47,73),(49,69)],[(55,55),(64,59),(67,69),(70,78),(76,88),(71,92),(63,91),(61,84),(60,76),(56,69)]]
chains=np.array([[(29,58),(27,67),(27,74)],[(33,59),(34,74),(37,84)],[(55,61),(52,71),(51,81)],[(60,61),(64,74),(68,88)]],float)
parts=[];limbmaterials=[]
for j,p in enumerate(oldP):
 ar=oa.copy();ar[:,:,3]=np.minimum(ar[:,:,3],poly(p));parts.append(ar)
 ma=np.zeros_like(ar);co=(org[:,:,0]>org[:,:,1]*1.16)&(org[:,:,1]>org[:,:,2]*1.25)&(org.max(2)>95);ma[:,:,0]=co*255;ma[:,:,3]=ar[:,:,3];limbmaterials.append(ma)
parts[2]=parts[3].copy();limbmaterials[2]=limbmaterials[3].copy();chains[2]=chains[3]
# Accepted phase order; foreleg projection adjusted for frontal visibility. Segment widths remain independent of projected length.
metrics=[]
for n in range(12):
 targets=[];layers=[];mlayers=[]
 for j,c in enumerate(chains):
  root,knee,hoof=c;guide=G[n,[3,2,1,0][j]];delta=(guide-guide[0])*.85*1.12;projected=np.column_stack([-delta[:,0]*.72,delta[:,1]*1.25+delta[:,0]*.22]);target=roots[j]+projected*np.array([1.40 if j>=2 else .80,.80]);
  if j==2:
   forward=max(0.0,-delta[2,0]);target[1:,0]+=forward*np.array([.20,.40]);target[1:,1]-=np.array([1.0,2.0])
  targets.append(target);part=Image.new('RGBA',im.size);mpart=Image.new('RGBA',im.size)
  vec=hoof-root;vec/=np.linalg.norm(vec);along=(x-knee[0])*vec[0]+(y-knee[1])*vec[1]
  for k in range(2):
   u,v=c[k:k+2];c0,d0=target[k:k+2];vv=v-u;ww=d0-c0;A=np.array([[vv[0],-vv[1]],[vv[1],vv[0]]]);normal_scale=np.linalg.norm(vv)/np.linalg.norm(ww)*.80;B=np.array([[ww[0],-ww[1]*normal_scale],[ww[1],ww[0]*normal_scale]]);M=B@np.linalg.inv(A);t=(c0-M@u)*S;aff=np.column_stack([M,t]);weight=np.clip((1.3-along)/2.6,0,1)if k==0 else np.clip((along+1.3)/2.6,0,1)
   for original,dest in [(parts[j],part),(limbmaterials[j],mpart)]:
    ar=original.copy();ar[:,:,3]=np.minimum(ar[:,:,3],parts[j][:,:,3]);ar[:,:,3]=(ar[:,:,3]*weight).astype('uint8');unit=vv/np.linalg.norm(vv);alongbone=((x-u[0])*unit[0]+(y-u[1])*unit[1]);side=abs((x-u[0])*unit[1]-(y-u[1])*unit[0]);trim=np.clip((5.8-side)/.6,0,1)*np.clip((alongbone+1.0)/1.4,0,1)*np.clip((np.linalg.norm(vv)+2.0-alongbone)/1.4,0,1);ar[:,:,3]=(ar[:,:,3]*trim).astype('uint8');dest.alpha_composite(Image.fromarray(warp(ar,aff)))
   metrics.append(float(np.max(np.abs(M.T@M-np.eye(2)))))
  if j in [0,2]:
   ar=np.array(part);ar[:,:,:3]=(ar[:,:,:3].astype(float)*.82).astype('uint8');part=Image.fromarray(ar)
  layers.append(part);mlayers.append(mpart)
 if n in [0,10]:
  for jj,layer in enumerate(layers):layer.resize((96,96)).save(O/f'debug_{n}_{jj}.png')
 bodyim=Image.fromarray(body);bodymask=material.copy();bodymask[:,:,3]=body[:,:,3];bodymask=Image.fromarray(bodymask);capmask=material.copy();capmask[:,:,3]=cap[:,:,3];capmask=Image.fromarray(capmask)
 out=Image.new('RGBA',im.size);mask=Image.new('RGBA',im.size)
 for j in [0]:out.alpha_composite(layers[j]);mask.alpha_composite(mlayers[j])
 out.alpha_composite(bodyim);mask.alpha_composite(bodymask)
 for j in [2,1,3]:out.alpha_composite(layers[j]);mask.alpha_composite(mlayers[j])
 # Continuous tapered haunch uses same accepted upper-joint path.
 for j in [1]:
  root,knee=targets[j][:2];v=knee-root;length=np.linalg.norm(v);u=v/length;normal=np.array([-u[1],u[0]]);along=(x-root[0])*u[0]+(y-root[1])*u[1];across=(x-root[0])*normal[0]+(y-root[1])*normal[1];t=np.clip(along/(length*.75),0,1);width=4.5*(1-t)+1.8*t;coverage=np.clip((width-abs(across))/.6,0,1)*np.clip((along+4)/2,0,1)*np.clip((length*.75-along)/1.8,0,1)
  mapx=(35+across*.55)*S;mapy=(50+np.clip(along,-3,5)*.35)*S;paint=cv2.remap(a,mapx.astype('float32'),mapy.astype('float32'),cv2.INTER_CUBIC);orange=(paint[:,:,0].astype(float)>paint[:,:,1]*1.14)&(paint[:,:,1].astype(float)>paint[:,:,2]*1.2);paint[:,:,3]=(paint[:,:,3]*coverage*orange).astype('uint8');out.alpha_composite(Image.fromarray(paint));mm=np.zeros_like(paint);mm[:,:,0]=255;mm[:,:,3]=paint[:,:,3];mask.alpha_composite(Image.fromarray(mm))
 out.alpha_composite(Image.fromarray(cap));mask.alpha_composite(capmask)
 # Far foreleg crosses in front of the chest on its forward swing, not behind an opaque torso.
 if True:
  for layer in [layers[2],mlayers[2]]:
   ar=np.array(layer);dist=np.hypot(x-roots[2,0],y-roots[2,1]);ar[:,:,3]=(ar[:,:,3]*np.clip((dist-2)/4,0,1)).astype('uint8');layer.paste(Image.fromarray(ar))
  out.alpha_composite(layers[2]);mask.alpha_composite(mlayers[2])
 bob=round((G[n,0,0,1]-48)*.85*S)
 for z,name in [(out,'art'),(mask,'mask')]:
  shifted=Image.new('RGBA',im.size);shifted.alpha_composite(z,(0,bob));res=shifted.resize((96,96),Image.Resampling.LANCZOS)
  if name=='mask':
   ar=np.array(res);ar[:,:,:3]=(ar[:,:,:3].astype(float)*ar[:,:,3:4]/255).astype('uint8');res=Image.fromarray(ar[:,:,:3])
  res.save(O/f'{name}_{n:02}.png')
 ar=np.array(Image.open(O/f'art_{n:02}.png'));num,lab,stats,_=cv2.connectedComponentsWithStats((ar[:,:,3]>40).astype('uint8'));keep=np.zeros((96,96),bool)
 for component in range(1,num):
  if stats[component,cv2.CC_STAT_AREA]>=5:keep|=lab==component
 ar[:,:,3][~keep]=0;Image.fromarray(ar).save(O/f'art_{n:02}.png');ma=np.array(Image.open(O/f'mask_{n:02}.png'));ma[~keep]=0;Image.fromarray(ma).save(O/f'mask_{n:02}.png')
json.dump({'max_bone_orthogonality_error':max(metrics),'frames':12},open(O/'regression.json','w'))
