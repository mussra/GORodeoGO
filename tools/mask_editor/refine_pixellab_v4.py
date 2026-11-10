"""Transfer only unedited poses from Ant's matching other-actor pose. Preserve edited74."""
from pathlib import Path
from PIL import Image
import numpy as np, cv2, json, re, hashlib, base64, io
R=Path(__file__).resolve().parents[2]
j=json.loads((R/'tools/mask_editor/reviews/20261110-ant-1031/partial-v1.json').read_text());edited={x['id'] for x in j['changes'] if x['id'].endswith('-color')};items=[];report=[]
def uri(im):
 b=io.BytesIO();im.save(b,format='PNG');return 'data:image/png;base64,'+base64.b64encode(b.getvalue()).decode()
labels={'side':'Lateral','down':'Abajo','up':'Arriba','diag_down':'Diagonal abajo','diag_up':'Diagonal arriba'}
for k in ['rider','horse']:
 for v in labels:
  for i in range(9):
   ident=f'pixellab-{k}-{v}-{i:02}-color';target=np.array(Image.open(R/f'art/experimental/pixellab/{k}/{v}/frame_{i:02}.png').convert('RGBA'));mask=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v3/{k}/{v}/color_{i:02}.png').convert('RGB'))
   if ident not in edited:
    other='rider' if k=='horse' else 'horse';otherid=f'pixellab-{other}-{v}-{i:02}-color';assert otherid in edited
    source=np.array(Image.open(R/f'art/experimental/pixellab/{other}/{v}/frame_{i:02}.png').convert('RGBA'));sm=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v3/{other}/{v}/color_{i:02}.png').convert('RGB'))
    # Normalize the horse extent, not RGB: actors have different coat palettes.
    sy,sx=np.where(sm[:,:,:2].max(2)>0);ty,tx=np.where(target[:,:,3]>100)
    scale_x=(tx.max()-tx.min())/(sx.max()-sx.min());scale_y=(ty.max()-ty.min())/(sy.max()-sy.min())
    dx=tx.min()-sx.min()*scale_x;dy=ty.min()-sy.min()*scale_y
    transform=np.float32([[scale_x,0,dx],[0,scale_y,dy]])
    mapped=cv2.warpAffine(sm,transform,(96,96),flags=cv2.INTER_NEAREST)
    # The rider occludes parts absent in wild art. Continue nearest transferred coat/hair
    # membership through those holes, then clip to the wild horse's actual colored pixels.
    occupied=mapped[:,:,:2].max(2)>0
    _,nearest=cv2.distanceTransformWithLabels((~occupied).astype('uint8'),cv2.DIST_L2,5,labelType=cv2.DIST_LABEL_PIXEL)
    coords=np.argwhere(occupied);filled=mapped[coords[nearest-1,0],coords[nearest-1,1]]
    rgb=target[:,:,:3].astype(float);r,g,b=rgb.transpose(2,0,1)
    warm=(r>g*1.06)&(g>b*1.08)&(r>85);cream=(r>150)&(g>120)&(b>80)&(r>=g*.95)&((rgb.max(2)-rgb.min(2))<125)
    eligible=(target[:,:,3]>100)&(warm|cream);mask=filled.copy();mask[~eligible]=0
    report.append(dict(actor=k,view=v,frame=i+1,source_actor=other,dx=float(dx),dy=float(dy),scale_x=float(scale_x),scale_y=float(scale_y),filled_occluded_pixels=int((eligible&~occupied).sum())))
   d=R/f'art/experimental/pixellab_masks_review_v4/{k}/{v}';d.mkdir(parents=True,exist_ok=True);im=Image.fromarray(mask);im.save(d/f'color_{i:02}.png');Image.fromarray(np.repeat(mask[:,:,:1],3,2)).save(d/f'spots_{i:02}.png')
   if ident in edited:assert np.array_equal(mask,np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v3/{k}/{v}/color_{i:02}.png')))
   items.append(dict(id=ident,name=('Jinete' if k=='rider' else 'Salvaje')+' · '+labels[v]+f' / Pelaje y crin · {i+1:02}/09',kind='rgb',w=96,h=96,hash=hashlib.sha256((d/f'color_{i:02}.png').read_bytes()).hexdigest(),s=uri(Image.fromarray(target)),m=uri(im)))
s=Path('/downloads/editor-mascaras-pixellab-v3.html').read_text();s=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda _:'const ASSETS = '+json.dumps(items,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=s.replace('20261110-v3','20261110-v4').replace('20261110.v3','20261110.v4').replace('mascaras-v3.json','mascaras-v4.json').replace('Revisión v3','Revisión v4').replace('versión v3','versión v4').replace('lo no editado conserva el ajuste anterior.','16 poses sin retoques se derivan del otro actor, misma vista y frame; 74 correcciones intactas.')
Path('/downloads/editor-mascaras-pixellab-v4.html').write_text(s)
Path('/downloads/rancho-pixellab-mascaras-v4-completo.json').write_text(json.dumps(dict(format='rancho-mask-review',version=2,baseline='pixellab-20261110-v4',bases=[dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in items],changes=[]),separators=(',',':')))
(R/'tools/mask_editor/reviews/v4-transfer-report.json').write_text(json.dumps(report,indent=2));print(json.dumps(report));print('74 unchanged;16transferred;0missing equivalent')
