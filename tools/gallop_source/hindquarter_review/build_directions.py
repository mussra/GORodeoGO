from PIL import Image,ImageDraw,ImageFilter
from pathlib import Path
import cv2,numpy as np,json,runpy,sys
O=Path(__file__).parent;S=8
G=json.loads((O.parent/'support/corrected-guide.json').read_text());G[10][0]=[[43,41],[25,48],[29,62]];G[10][1]=[[49,41],[34,53],[20,66]]
# Each root and segment is cut from the same original view, not a rotated side sprite.
C={
'diag_down':{'body':[(0,0),(96,0),(96,60),(65,60),(61,65),(51,67),(40,66),(31,65),(25,67),(0,68)],'chains':[[(60,61),(64,74),(68,88)],[(55,61),(52,71),(51,81)],[(33,59),(34,74),(37,84)],[(29,58),(27,67),(27,74)]],'polys':[[(55,55),(64,59),(67,69),(70,78),(76,88),(71,92),(63,91),(61,84),(60,76),(56,69)],[(50,60),(57,61),(57,69),(56,77),(54,83),(48,83),(45,79),(47,73),(49,69)],[(30,57),(39,58),(39,67),(38,73),(41,80),(42,87),(33,89),(29,83),(31,76),(30,69)],[(25,57),(32,58),(31,66),(31,73),(29,77),(24,76),(22,72),(23,66)]]},
'diag_up':{'body':[(0,0),(96,0),(96,63),(68,63),(63,69),(54,70),(48,68),(40,69),(34,71),(0,71)],'chains':[[(64,63),(65,72),(63,80)],[(57,62),(57,71),(56,78)],[(47,63),(46,78),(47,89)],[(36,65),(31,78),(30,89)]],'polys':[[(59,58),(66,59),(68,66),(69,73),(68,79),(64,83),(59,81),(59,73),(60,67)],[(54,61),(60,61),(61,68),(61,76),(58,80),(54,78),(52,72)],[(42,60),(51,60),(52,69),(50,76),(52,86),(51,92),(43,93),(40,89),(42,82),(42,74)],[(32,63),(40,64),(39,72),(35,79),(35,87),(33,92),(26,93),(24,89),(25,80),(29,72)]]},
'down':{'body':[(0,0),(96,0),(96,65),(59,65),(56,70),(39,70),(35,66),(0,66)],'chains':[[(53,65),(52,77),(52,90)],[(42,65),(42,77),(41,88)],[(55,63),(57,69),(57,76)],[(40,63),(42,70),(43,78)]],'polys':[[(49,62),(58,63),(57,71),(56,79),(58,87),(57,93),(48,93),(47,87),(49,79)],[(38,62),(46,63),(46,73),(45,80),(46,87),(44,91),(37,91),(36,87),(38,79)],[(51,60),(58,61),(60,68),(60,75),(55,79),(52,74)],[(38,61),(43,61),(45,68),(45,77),(40,81),(38,75)]]},
'up':{'body':[(0,0),(96,0),(96,67),(59,67),(56,74),(39,74),(35,67),(0,67)],'chains':[[(54,64),(54,74),(54,83)],[(41,64),(41,73),(41,82)],[(55,66),(55,79),(55,90)],[(40,66),(40,79),(39,90)]],'polys':[[(51,63),(57,63),(59,72),(58,80),(57,85),(51,85),(50,80)],[(37,63),(43,63),(45,72),(45,80),(42,85),(37,85)],[(51,62),(59,63),(59,72),(58,80),(59,88),(57,93),(50,93),(49,88),(51,80)],[(36,63),(43,63),(44,71),(43,80),(44,87),(42,93),(35,93),(34,88),(36,80)]]}}
def polygon(src,p):
 m=Image.new('L',src.size);ImageDraw.Draw(m).polygon([(x*S,y*S) for x,y in p],fill=255);a=np.minimum(np.array(src.getchannel('A')),np.array(m));im=src.copy();im.putalpha(Image.fromarray(a));return im
for view,cfg in C.items():
 src=Image.open(O.parent/'original'/f'{view}.png').convert('RGBA').resize((96*S,96*S),Image.Resampling.LANCZOS)
 body=polygon(src,cfg['body']);tail=None
 if view=='diag_up':tail=polygon(src,[(18,54),(34,51),(40,59),(35,72),(33,81),(20,81),(18,76)])
 if view=='up':tail=polygon(src,[(43,53),(50,52),(54,61),(54,73),(49,85),(43,84),(39,77),(40,65)])
 if view=='diag_down':tail=polygon(src,[(0,40),(28,39),(28,50),(25,60),(21,68),(0,69)])
 parts=[polygon(src,p) for p in cfg['polys']];outdir=O/'directions'/view;outdir.mkdir(parents=True,exist_ok=True)
 for n in range(12):
  limbs=[];dy=(G[n][0][0][1]-48)*.85
  for j in range(4):
   a,b,c=map(lambda x:np.array(x,float),cfg['chains'][j]);root=a.copy();g=np.array(G[n][j],float);delta=(g-g[0])*.85*1.12
   if view.startswith('diag'):
    target=root+np.column_stack([-delta[:,0]*.72,delta[:,1]*1.25+delta[:,0]*(.22 if view=='diag_down' else -.22)])
   else:
    target=root+np.column_stack([delta[:,0]*.05,delta[:,1]*1.25+delta[:,0]*(.32 if view=='down' else -.32)])
   part=Image.new('RGBA',src.size);yy,xx=np.mgrid[0:src.height,0:src.width];vec=c-a;vec/=np.linalg.norm(vec);proj=(xx/S-b[0])*vec[0]+(yy/S-b[1])*vec[1]
   for k,(u,v) in enumerate([(a,b),(b,c)]):
    ar=np.array(parts[j]);weight=np.clip((1.5-proj)/2.5,0,1) if k==0 else np.clip((proj+1.5)/2.5,0,1);ar[:,:,3]=(ar[:,:,3]*weight).astype(np.uint8)
    u0=u*S;v0=v*S;c0=target[k]*S;d0=target[k+1]*S;vv=v0-u0;ww=d0-c0;A=np.array([[vv[0],-vv[1]],[vv[1],vv[0]]]);B=np.array([[ww[0],-ww[1]*.55],[ww[1],ww[0]*.55]]);M=B@np.linalg.inv(A);t=c0-M@u0
    if k==0 and ((view in ['diag_down','diag_up'] and j in [2,3]) or (view=='up' and j in [2,3])):
     gridy,gridx=np.mgrid[:src.height,:src.width].astype(np.float32);unit=vv/np.linalg.norm(vv);normal=np.array([-unit[1],unit[0]]);along=(gridx-u0[0])*unit[0]+(gridy-u0[1])*unit[1];side=(gridx-u0[0])*normal[0]+(gridy-u0[1])*normal[1]
     factor=1.0+.60*np.clip(1.0-along/np.linalg.norm(vv),0,1)**1.1
     px=u0[0]+along*unit[0]+side/factor*normal[0];py=u0[1]+along*unit[1]+side/factor*normal[1]
     ar=cv2.remap(ar,px.astype(np.float32),py.astype(np.float32),cv2.INTER_CUBIC)
    part.alpha_composite(Image.fromarray(cv2.warpAffine(ar,np.column_stack([M,t]),src.size,flags=cv2.INTER_CUBIC)))
   if (view=='down' and j>1) or (view=='up' and j<2):part=Image.new('RGBA',src.size)
   limbs.append(part)
  im=Image.new('RGBA',src.size)
  order=[2,3,0,1] if view=='down' else [0,1,3,2]
  for j in order[:2]:im.alpha_composite(limbs[j])
  im.alpha_composite(body)
  for j in order[2:]:im.alpha_composite(limbs[j])
  # Review-only muscle bridge, anchored to unchanged rear upper bones.
  rear=[2,3] if view in ['diag_down','diag_up','up'] else []
  for j in rear:
   a,b,c=map(lambda x:np.array(x,float),cfg['chains'][j]);root=a.copy();g=np.array(G[n][j],float);delta=(g-g[0])*.85*1.12
   if view.startswith('diag'):target=root+np.column_stack([-delta[:,0]*.72,delta[:,1]*1.25+delta[:,0]*(.22 if view=='diag_down' else -.22)])
   else:target=root+np.column_stack([delta[:,0]*.05,delta[:,1]*1.25+delta[:,0]*(.32 if view=='down' else -.32)])
   a,b=target[:2];v=b-a;length=np.linalg.norm(v);unit=v/length;normal=np.array([-unit[1],unit[0]])
   yy,xx=np.mgrid[:src.height,:src.width].astype(float);along=(xx/S-a[0])*unit[0]+(yy/S-a[1])*unit[1];across=(xx/S-a[0])*normal[0]+(yy/S-a[1])*normal[1];t=np.clip(along/(length*.67),0,1);width=4.0*(1-t)+1.9*t
   coverage=np.clip((width-abs(across))/.8,0,1)*np.clip((along+3)/2,0,1)*np.clip((length*.67-along)/2,0,1)
   source=np.array(body);anchor=cfg['chains'][j][0];mapx=(anchor[0]+across*.65)*S;mapy=(anchor[1]-5+np.clip(along,-2,4)*.4)*S
   paint=cv2.remap(source,mapx.astype(np.float32),mapy.astype(np.float32),cv2.INTER_CUBIC);paint[:,:,3]=(coverage*.62*paint[:,:,3]).astype(np.uint8);im.alpha_composite(Image.fromarray(paint))
  # Torso masks the root only, leaving flexion readable below it.
  cap=body.copy();ar=np.array(cap);yy,xx=np.mgrid[0:src.height,0:src.width];ar[:,:,3]=(ar[:,:,3]*np.clip((66-yy/S)/5,0,1)).astype(np.uint8);im.alpha_composite(Image.fromarray(ar))
  if tail is not None:im.alpha_composite(tail)
  shifted=Image.new('RGBA',im.size);shifted.alpha_composite(im,(0,round((dy-3)*S)));shifted.resize((96,96),Image.Resampling.LANCZOS).save(outdir/f'frame_{n:02d}.png')
# Contact sheet, all views/phases at fixed canvas.
sheet=Image.new('RGB',(1440,600),'#315558');d=ImageDraw.Draw(sheet)
for row,view in enumerate(C):
 for n in range(12):
  im=Image.open(O/'directions'/view/f'frame_{n:02d}.png').resize((120,120));sheet.paste(im,(n*120,row*150+20),im)
 d.text((5,row*150),view,fill='white')
sheet.save(O/'directions-preview.png')
