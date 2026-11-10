"""User's v1 project is rendered on v1, never layered over v2. Spots use coat exactly."""
from pathlib import Path
from PIL import Image
import numpy as np,json,base64,hashlib,re,io
R=Path(__file__).resolve().parents[2];source=R/'tools/mask_editor/reviews/20261110-ant-1031'
j=json.loads((source/'partial-v1.json').read_text());edited={e['id'] for e in j['changes']};items=[]
def uri(im):
 b=io.BytesIO();im.save(b,format='PNG');return 'data:image/png;base64,'+base64.b64encode(b.getvalue()).decode()
labels={'side':'Lateral','down':'Abajo','up':'Arriba','diag_down':'Diagonal abajo','diag_up':'Diagonal arriba'}
for k in ['rider','horse']:
 for v in labels:
  for i in range(9):
   id=f'pixellab-{k}-{v}-{i:02}-color';art=Image.open(R/f'art/experimental/pixellab/{k}/{v}/frame_{i:02}.png').convert('RGBA');a=np.array(art)
   if id in edited:
    m=np.array(Image.open(source/'exact-import'/(id+'.png')).convert('RGB'))
   else:m=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v2/{k}/{v}/color_{i:02}.png').convert('RGB'))
   # Fine adjustment only at silhouette. Preserve user membership over visible pixels.
   coat=(m[:,:,0]>m[:,:,1])&(m[:,:,0]>64)&(a[:,:,3]>100)
   hair=(m[:,:,1]>m[:,:,0])&(m[:,:,1]>64)&(a[:,:,3]>100)
   clean=np.zeros((96,96,3),np.uint8);clean[:,:,0]=coat*255;clean[:,:,1]=hair*255
   d=R/f'art/experimental/pixellab_masks_review_v3/{k}/{v}';d.mkdir(parents=True,exist_ok=True);im=Image.fromarray(clean);im.save(d/f'color_{i:02}.png')
   # A derived preview artifact only, exactly the coat channel, NOT another editable mask.
   Image.fromarray(np.repeat((coat*255).astype('uint8')[:,:,None],3,2)).save(d/f'spots_{i:02}.png')
   items.append(dict(id=id,name=('Jinete' if k=='rider' else 'Salvaje')+' · '+labels[v]+f' / Pelaje y crin · {i+1:02}/09',kind='rgb',w=96,h=96,hash=hashlib.sha256((d/f'color_{i:02}.png').read_bytes()).hexdigest(),s=uri(art),m=uri(im)))
s=Path('/downloads/editor-mascaras-pixellab-v2.html').read_text();s=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda _:'const ASSETS = '+json.dumps(items,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=s.replace('pixellab-20261110-v2','pixellab-20261110-v3').replace('20261110.v2','20261110.v3').replace('mascaras-v2.json','mascaras-v3.json')
s=s.replace('90 poses, 180 máscaras: cada pose tiene pelaje/crin y zona de manchas.','90 poses, 90 máscaras: rojo = pelaje y manchas con la misma zona; verde = crin/cola. No hay máscara separada de manchas.').replace('Rojo = pelaje, verde = crin y cola, blanco = zona donde pueden aparecer manchas','Rojo = pelaje y manchas; verde = crin y cola')
s=s.replace('Revisión v2 sobre el JSON parcial de Ant: 35 máscaras de 18 poses. Trazos ajustados a la silueta y resto refinado por regiones/flujo entre poses; aún borrador pendiente de revisión.','Revisión v3 sobre el JSON nuevo de Ant (98 máscaras de 74 poses, base v1). Se usan sus zonas de pelaje y crin, recortadas a la silueta; lo no editado conserva el ajuste anterior. Manchas = pelaje, sin máscara aparte. Pendiente de revisión.')
s=s.replace('90 poses · 5 vistas × 9 frames × 2 actores. 180 máscaras editables. Borrador automático, no aprobado.','90 poses · 5 vistas × 9 frames × 2 actores. 90 máscaras editables. Manchas = pelaje. Pendiente de revisión.').replace('180 máscaras editables','90 máscaras editables').replace('Revisión v2, no aprobada.','Revisión v3, no aprobada.')
Path('/downloads/editor-mascaras-pixellab-v3.html').write_text(s);print('v3',len(items),'coat edits',sum(a['id'].endswith('color') for a in j['changes']))
