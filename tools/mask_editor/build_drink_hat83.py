from pathlib import Path
from PIL import Image
import json,re,base64,io,hashlib,numpy as np
R=Path(__file__).resolve().parents[2];s=Path('/downloads/editor-mascaras-beber-v8.html').read_text();assets=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',s,re.S)[1]);project=json.loads((R/'tools/mask_editor/reviews/20261111-ant1246/complete-v8.json').read_text());manifest=json.loads((R/'tools/mask_editor/drink83-import-manifest.json').read_text())
for i in range(2):
 ident=f'drink83-{i}-color';a=next(x for x in assets if x['id']==ident);im=Image.open(io.BytesIO(base64.b64decode(a['m'].split(',')[1]))).convert('RGB');m=np.array(im);src=np.array(Image.open(R/f'art/experimental/drink_preview83/pose_{i}.png').convert('RGBA'));r,g,b=[src[:,:,j].astype(float) for j in range(3)];y,x=np.mgrid[:96,:112]
 hat=(y<30)&(x>=34)&(x<=73)&(r>g*1.13)&(g>b*1.20)&(r>65)&(src[:,:,3]>128)
 # Bright gold pin remains original. Horse ears lie below this region.
 pin=(x>61)&(y>17)&(r>150)&(g>105);hat&=~pin
 m[hat]=[0,0,255];out=R/f'art/experimental/drink_preview83/hat_base_{i}.png';Image.fromarray(m).save(out)
 data=out.read_bytes();a['m']='data:image/png;base64,'+base64.b64encode(data).decode();a['hash']=hashlib.sha256(data).hexdigest();a['kind']='rgb-hat';manifest[ident]['hash']=a['hash']
project['baseline']='rancho-20261111-drink-v9';project['bases']=[dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in assets]
for c in project['changes']:c['hash']=next(a['hash'] for a in assets if a['id']==c['id'])
old=json.loads((R/'tools/mask_editor/reviews/20261111-ant1246/complete-v8.json').read_text());assert [(c['id'],c['strokes']) for c in project['changes']]==[(c['id'],c['strokes']) for c in old['changes']]
s=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda _:'const ASSETS = '+json.dumps(assets,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=re.sub(r'const INCLUDED_PROJECT = .*?;\n',lambda _:'const INCLUDED_PROJECT = '+json.dumps(project,separators=(',',':'))+';\n',s,count=1)
s=s.replace('rancho-20261111-drink-v8','rancho-20261111-drink-v9').replace('20261111.v8.drink','20261111.v9.drink-hat').replace('Editor de máscaras v8','Editor de máscaras v9').replace('mascaras-v8-beber.json','mascaras-v9-beber.json').replace('v8: 4 máscaras','v9: 4 máscaras')
s=s.replace('Rojo=pelaje, verde=crin/cola, negro=protegido','Rojo=pelaje, verde=crin/cola, azul=sombrero, negro=protegido').replace('146 trazos','tus trazos').replace('97 anteriores y 4 nuevas de beber','97 anteriores y 4 de beber con tus retoques incluidos')
s=s.replace('const CAP = 4500000','const CAP = 4500000')
Path('/downloads/editor-mascaras-beber-v9.html').write_text(s);Path('/downloads/rancho-mascaras-beber-v9-completo.json').write_text(json.dumps(project,separators=(',',':')));(R/'tools/mask_editor/drink83-hat-import-manifest.json').write_text(json.dumps(manifest,indent=2));print('v9 preserves40changed masks, all strokes;2base masks add blue hat')
