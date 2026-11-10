from PIL import Image,ImageDraw
from pathlib import Path
import numpy as np,cv2,json,base64,hashlib,re,io
R=Path(__file__).resolve().parents[2];out=R/'art/experimental/pixellab_masks_review_v2';stats=[]
P={
'rider':{
'side':{'protect':[(27,0),(63,0),(62,30),(57,39),(59,60),(54,68),(48,67),(44,60),(36,56),(34,42)],'hair':[[(2,44),(27,41),(24,56),(18,72),(6,81),(0,70)],[(55,36),(68,25),(74,27),(68,42),(67,50),(62,58)]]},
'down':{'protect':[(21,0),(76,0),(76,34),(63,41),(60,50),(56,47),(55,40),(42,40),(40,50),(35,51),(30,40),(21,34)],'hair':[[(43,33),(51,33),(53,44),(44,46)]]},
'up':{'protect':[(20,0),(76,0),(76,33),(64,43),(61,54),(57,55),(54,47),(42,47),(39,56),(32,54),(29,39)],'hair':[[(39,55),(55,53),(59,67),(55,85),(43,87),(38,70)]]},
'diag_down':{'protect':[(27,0),(61,0),(61,27),(57,32),(55,45),(52,59),(47,64),(40,62),(36,51),(35,42),(29,36)],'hair':[[(10,34),(31,35),(35,43),(27,55),(17,67),(8,65)],[(52,33),(62,25),(69,25),(64,35),(60,47),(54,56)]]},
'diag_up':{'protect':[(27,0),(65,0),(64,27),(60,32),(56,44),(57,57),(52,68),(47,65),(46,56),(39,52),(36,44),(28,35)],'hair':[[(19,48),(37,44),(40,53),(35,67),(25,82),(12,84)],[(54,28),(64,26),(69,25),(67,33),(61,44),(57,45)]]}},
'horse':{
'side':{'protect':[],'hair':[[(0,42),(22,40),(26,51),(21,69),(11,78),(0,78)],[(55,27),(68,22),(73,24),(69,34),(65,45),(60,45)]]},
'down':{'protect':[],'hair':[[(43,16),(51,16),(52,24),(49,31),(44,30)]]},
'up':{'protect':[],'hair':[[(41,45),(54,43),(57,54),(53,69),(43,70),(38,58)]]},
'diag_down':{'protect':[],'hair':[[(17,35),(34,31),(39,39),(31,50),(22,57),(15,55)],[(50,16),(59,12),(64,14),(62,22),(59,33),(54,36)]]},
'diag_up':{'protect':[],'hair':[[(20,38),(37,35),(42,44),(34,57),(26,64),(18,61)],[(51,14),(61,10),(65,14),(61,24),(56,28)]]}}}
def poly(polys):
 im=Image.new('L',(96,96));d=ImageDraw.Draw(im)
 for p in polys:
  if p:d.polygon(p,fill=255)
 return np.array(im)>0
def uri(im):
 b=io.BytesIO();im.save(b,format='PNG');return 'data:image/png;base64,'+base64.b64encode(b.getvalue()).decode()
ant=json.loads((R/'tools/mask_editor/reviews/20261110-ant/partial-v1.json').read_text());edited={e['id'] for e in ant['changes']}
items=[];labels={'side':'Lateral','down':'Abajo','up':'Arriba','diag_down':'Diagonal abajo','diag_up':'Diagonal arriba'}
for kind in P:
 for view in P[kind]:
  ref=np.array(Image.open(R/f'art/experimental/pixellab/{kind}/{view}/frame_00.png').convert('RGBA'));grayref=cv2.cvtColor(ref,cv2.COLOR_RGBA2GRAY)
  protect0=poly([P[kind][view]['protect']]);hair0=poly(P[kind][view]['hair'])
  for frame in range(9):
   a=np.array(Image.open(R/f'art/experimental/pixellab/{kind}/{view}/frame_{frame:02}.png').convert('RGBA'));gray=cv2.cvtColor(a,cv2.COLOR_RGBA2GRAY)
   flow=cv2.calcOpticalFlowFarneback(gray,grayref,None,.5,4,15,4,7,1.5,0)
   y,x=np.mgrid[:96,:96].astype('float32');mx=x+flow[:,:,0];my=y+flow[:,:,1]
   protect=cv2.remap(protect0.astype('uint8'),mx,my,cv2.INTER_NEAREST)>0;region=cv2.remap(hair0.astype('uint8'),mx,my,cv2.INTER_NEAREST)>0
   rgb=a[:,:,:3].astype(float);r,g,b=rgb.transpose(2,0,1);alpha=a[:,:,3]>100
   bright=rgb.max(2);warm=(r>g*1.06)&(g>b*1.08)&(r>85)
   cream=(r>150)&(g>120)&(b>80)&(r>=g*.95)&((bright-rgb.min(2))<125)
   eligible=alpha&(warm|cream)&~protect
   hair=eligible&cream&region;coat=eligible&~hair
   id=f'pixellab-{kind}-{view}-{frame:02}-color';user=id in edited
   sourceframe=frame
   if kind=='rider' and view=='down' and frame==8:
    sourceframe=0;user=True # unedited last frame closes to first, transfer user's first pose
   if user:
    m=np.array(Image.open(R/f'tools/mask_editor/reviews/20261110-ant/exact-import/pixellab-{kind}-{view}-{sourceframe:02}-color.png').convert('RGB'))
    if sourceframe!=frame:
     m=cv2.remap(m,mx,my,cv2.INTER_NEAREST)
    # Preserve chosen membership. Clip coarse strokes to visible warm horse colors,
    # protect high rider/hat/saddle zones using original palette plus narrow safe geometry.
    allowed=alpha&(warm|cream)
    if view=='down':allowed[:32,:]=False
    if view=='up':allowed[:45,:]=False
    coat=(m[:,:,0]>m[:,:,1])&allowed;hair=(m[:,:,1]>m[:,:,0])&allowed
   mask=np.zeros((96,96,3),np.uint8);mask[:,:,0]=coat*255;mask[:,:,1]=hair*255
   spotid=f'pixellab-{kind}-{view}-{frame:02}-spots'
   if spotid in edited:
    m=np.array(Image.open(R/f'tools/mask_editor/reviews/20261110-ant/exact-import/{spotid}.png').convert('RGB'))
    spots=(m[:,:,0]>127)&coat
   else:spots=coat.copy()
   # Tiny holes in eligible coat restored only if all direct neighbors agree, never across outlines.
   holes=cv2.morphologyEx(coat.astype('uint8'),cv2.MORPH_CLOSE,np.ones((3,3),np.uint8)).astype(bool)&eligible&~hair
   if not user:coat|=holes;mask[:,:,0]=coat*255;spots=coat.copy()
   dest=out/kind/view;dest.mkdir(parents=True,exist_ok=True)
   for layer,pix in [('color',mask),('spots',np.repeat((spots*255).astype(np.uint8)[:,:,None],3,2))]:
    im=Image.fromarray(pix);p=dest/f'{layer}_{frame:02}.png';im.save(p)
    name=('Jinete' if kind=='rider' else 'Salvaje')+' · '+labels[view]+' / '+('Pelaje y crin' if layer=='color' else 'Zona de manchas')+f' · {frame+1:02}/09'
    items.append(dict(id=f'pixellab-{kind}-{view}-{frame:02}-{layer}',name=name,kind='rgb' if layer=='color' else 'pattern',w=96,h=96,hash=hashlib.sha256(p.read_bytes()).hexdigest(),s=uri(Image.fromarray(a)),m=uri(im)))
   stats.append(dict(kind=kind,view=view,frame=frame,ant_color=user,coat=int(coat.sum()),hair=int(hair.sum()),spots=int(spots.sum())))
s=Path('/downloads/editor-mascaras-pixellab-v1.html').read_text();s=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda _: 'const ASSETS = '+json.dumps(items,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=s.replace('pixellab-20261110-v1','pixellab-20261110-v2').replace('20261110.v1','20261110.v2').replace('mascaras-v1.json','mascaras-v2.json')
s=s.replace('Borrador automático por colores y regiones, pendiente de revisión.','Revisión v2 sobre el JSON parcial de Ant: 35 máscaras de 18 poses. Trazos ajustados a la silueta y resto refinado por regiones/flujo entre poses; aún borrador pendiente de revisión.')
s=s.replace('Borrador automático, no aprobado.','Revisión v2, no aprobada.').replace('Propuesta automática conservadora:','Revisión v2 asistida:')
Path('/downloads/editor-mascaras-pixellab-v2.html').write_text(s)
Path('/downloads/pixellab-refine-v2-report.json').write_text(json.dumps(stats,indent=2));print('built v2',len(items))
