"""Draft automatic masks for Ant's approved drinking poses; extend v7 without editing old assets."""
from pathlib import Path
from PIL import Image,ImageDraw
import numpy as np,json,re,hashlib,base64
R=Path(__file__).resolve().parents[2];folder=R/'art/experimental/drink_preview83'
def poly(points):
 im=Image.new('1',(112,96));ImageDraw.Draw(im).polygon(points,fill=1);return np.array(im).astype(bool)
def uri(p):return 'data:image/png;base64,'+base64.b64encode(p.read_bytes()).decode()
manifest={};new=[]
for i in range(2):
 src=folder/f'pose_{i}.png';a=np.array(Image.open(src).convert('RGBA'));r,g,b=[a[:,:,n].astype(float) for n in range(3)];y,x=np.mgrid[:96,:112]
 solid=a[:,:,3]>128;warm=(r>g*1.08)&(g>b*1.12)&(r>55);cream=(r>125)&(g>105)&(b>55)&(r>g*.95)&(g>b*1.03)
 protect=poly([(36,5),(73,5),(73,31),(61,35),(61,51),(60,60),(60,66),(52,70),(44,66),(42,60),(33,59),(34,45),(39,34)])
 tail=poly([(0,38),(31,37),(31,57),(25,75),(0,78)])
 mane=poly([(60,30),(81,29),(83,39),(73,50),(63,56)]) if i==0 else poly([(61,37),(78,40),(87,51),(91,65),(83,68),(74,58),(66,53)])
 horsezone=(y>=37)&(~protect)
 hair=solid&cream&(tail|mane)&(~protect)
 coat=solid&horsezone&(warm|cream)&(~hair)
 # Preserve tack/boots/black outlines. Thin reins remain mostly protected by dark palette.
 coat&=~poly([(70,52),(92,51),(93,56),(72,57)]) if i==0 else ~poly([(78,75),(95,77),(96,81),(80,80)])
 mask=np.zeros((96,112,3),np.uint8);mask[:,:,0]=coat*255;mask[:,:,1]=hair*255
 eye=np.zeros((96,112,3),np.uint8);cx,cy=(83,51) if i==0 else (85,75)
 eyezone=((x-cx)**2+(y-cy)**2<=2.5**2)&solid&(r<85)&(g<65)&(b<60);eye[eyezone]=255
 Image.fromarray(mask).save(folder/f'color_{i}.png');Image.fromarray(eye).save(folder/f'eyes_{i}.png')
 # Draft pose mapping: unchanged body shares coordinates; head-down is mapped back to head-up.
 uv=np.zeros((96,112,3),np.uint8);u=x.astype(float);v=y.astype(float)
 if i==1:
  head=(x>=74)&(y>=59);u[head]=74+(x[head]-74)*.9;v[head]=36+(y[head]-59)*.82
 uv[:,:,0]=np.clip(u*2,0,255);uv[:,:,1]=np.clip(v*2,0,255);uv[:,:,2]=255;Image.fromarray(uv).save(folder/f'uv_{i}.png')
 for layer,kind,name in [('color','rgb','Pelaje y crin'),('eyes','eye','Iris')]:
  p=folder/f'{layer}_{i}.png';ident=f'drink83-{i}-{layer}';digest=hashlib.sha256(p.read_bytes()).hexdigest()
  new.append(dict(id=ident,name=f'Beber / {"Cabeza arriba" if i==0 else "Cabeza abajo"} / {name}',kind=kind,w=112,h=96,hash=digest,s=uri(src),m=uri(p)))
  manifest[ident]=dict(path=str(p.relative_to(R)),source=str(src.relative_to(R)),hash=digest,w=112,h=96)
 assert not np.any((mask.max(2)>0)&protect)
 assert not np.any((mask.max(2)>0)&(~solid))
s=Path('/downloads/editor-mascaras-rancho-v7.html').read_text();old=json.loads(Path('/downloads/rancho-mascaras-v7-completo.json').read_text());assets=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',s,re.S)[1]);assets+=new
assert len(assets)==101
s=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda _:'const ASSETS = '+json.dumps(assets,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=s.replace('rancho-20261110-v7','rancho-20261111-drink-v8').replace('20261110.v7.all-masks','20261111.v8.drink').replace('mascaras-v7.json','mascaras-v8-beber.json').replace('Editor v7','Editor v8').replace('97 máscaras','101 máscaras').replace('97máscaras','101máscaras')
s=s.replace('Editor de máscaras v7','Editor de máscaras v8')
s=re.sub(r"textContent: 'v7: Potro.*?'", "textContent: '101 máscaras: 97 anteriores y 4 nuevas de beber. Conserva herramienta y trazos. Devuelve el JSON completo de esta versión; no importes otra base.'",s,count=1)
s=re.sub(r'<p class="hint">v7:.*?</p>', '<p class="hint">101 máscaras: 97 anteriores y 4 nuevas de beber. Continúa en esta versión y devuelve su JSON completo. No importes un proyecto de otra base. Bases y precisión de los trazos anteriores conservadas.</p>',s,count=1,flags=re.S)
s=re.sub(r'<p class="hint"><strong>v7:.*?</p>', '<p class="hint">101 máscaras: 97 anteriores y 4 nuevas de beber. Continúa en esta versión y devuelve su JSON completo. No importes un proyecto de otra base. Bases anteriores y precisión de los trazos conservadas.</p>',s,count=1,flags=re.S)
s=re.sub(r'(<h1>.*?</h1>\s*)<p class="hint">.*?</p>',lambda m:m[1]+'<p class="hint">v8: 4 máscaras nuevas de beber (pelaje/crin e iris para cada pose). Las 97 máscaras y 146 trazos anteriores se conservan. El grupo Beber está al final. Rojo=pelaje, verde=crin/cola, negro=protegido; Iris se edita por separado. Borrador automático: revisa silla, botas, brida, cabeza y patas. Exporta JSON antes de cerrar. No modifica la APK.</p>',s,count=1,flags=re.S)
project=dict(format='rancho-mask-review',version=2,baseline='rancho-20261111-drink-v8',bases=[dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in assets],changes=old['changes'])
assert project['bases'][:97]==old['bases'];assert project['changes']==old['changes']
Path('/downloads/editor-mascaras-beber-v8.html').write_text(s);Path('/downloads/rancho-mascaras-beber-v8-completo.json').write_text(json.dumps(project,separators=(',',':')))
(R/'tools/mask_editor/drink83-import-manifest.json').write_text(json.dumps(manifest,indent=2));print('101assets,97old bases+146strokes preserved,4new editable masks')
