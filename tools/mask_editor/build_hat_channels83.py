"""Add hat-only layers. Never writes an existing art, mask, baseline or user stroke."""
from pathlib import Path
from PIL import Image
import numpy as np,json,re,base64,hashlib,collections,io
R=Path(__file__).resolve().parents[2]
folder=R/'art/hat_masks_v10';folder.mkdir(exist_ok=True)
manifest={};new=[]
def add(ident,name,source,mask):
 p=folder/(ident+'.png');Image.fromarray(mask).save(p)
 def uri(path):return 'data:image/png;base64,'+path.read_bytes().decode('ascii') if False else 'data:image/png;base64,'+base64.b64encode(path.read_bytes()).decode()
 digest=hashlib.sha256(p.read_bytes()).hexdigest();im=Image.open(source)
 new.append(dict(id=ident,name=name,kind='hat',w=im.width,h=im.height,hash=digest,s=uri(source),m=uri(p)))
 manifest[ident]=dict(path=str(p.relative_to(R)),source=str(source.relative_to(R)),hash=digest,w=im.width,h=im.height)
for source in sorted((R/'art/experimental/pixellab/rider').glob('*/*.png')):
 view=source.parent.name;index=int(source.stem.split('_')[-1]);im=np.array(Image.open(source).convert('RGBA'));r,g,b=[im[:,:,i].astype(float) for i in range(3)];y,x=np.mgrid[:im.shape[0],:im.shape[1]]
 warm=(r>g*1.13)&(g>b*1.18)&(r>40)&(y<37)&(x>23)&(x<76)&(im[:,:,3]>128)
 # Keep the gold pin intact. It is not part of the hat's dyed felt.
 warm&=~((r>150)&(g>110)&(g>r*.67))
 todo=set(zip(*np.where(warm)));components=[]
 while todo:
  first=todo.pop();q=[first];component=[first]
  while q:
   yy,xx=q.pop()
   for v in [(yy-1,xx),(yy+1,xx),(yy,xx-1),(yy,xx+1)]:
    if v in todo:todo.remove(v);q.append(v);component.append(v)
  components.append(component)
 assert components
 component=max(components,key=len)
 top=min(y for y,x in component)
 # Brim ends before face/bandana. Components can touch by a single brown pixel.
 height={'side':22,'down':22,'up':23,'diag_down':25,'diag_up':25}[view]
 component=[(y,x) for y,x in component if y<top+height]
 mask=np.zeros(im.shape[:2]+(3,),dtype=np.uint8)
 for yy,xx in component:mask[yy,xx,2]=255
 assert len(component)>60,(view,index,len(component))
 add(f'hat-pixellab-{view}-{index:02d}',f'Sombrero PixelLab · {view} / {index+1:02d}',source,mask)
for source in sorted((R/'art/player').glob('*/*.png')):
 anim=source.parent.name;name=source.name;blue=R/'art/player_hats/blue'/anim/name
 if not blue.exists():raise ValueError(str(blue))
 src=np.array(Image.open(source).convert('RGBA'));alt=np.array(Image.open(blue).convert('RGBA'));diff=np.any(src!=alt,axis=2)&(src[:,:,3]>0)
 mask=np.zeros(src.shape[:2]+(3,),dtype=np.uint8);mask[:,:,2]=diff*255
 add(f'hat-classic-{anim}-{source.stem}',f'Sombrero clásico · {anim} / {source.stem}',source,mask)
# Approved hat pixels already exist in the portrait and drinking masks. Copy only B.
for ident,name,source,maskpath in [('hat-portrait','Sombrero Adulto HD / Retrato',R/'art/portraits/adult_hd.png',R/'art/portraits/adult_hd_mask.png')]+[(f'hat-drink-{i}',f'Sombrero Beber / Pose {i}',R/f'art/experimental/drink_preview83/pose_{i}.png',R/f'art/experimental/drink_preview83/color_{i}.png') for i in range(2)]:
 src=np.array(Image.open(maskpath).convert('RGB'));m=np.zeros_like(src);m[:,:,2]=src[:,:,2];add(ident,name,source,m)
(R/'tools/mask_editor/hat83-manifest.json').write_text(json.dumps(manifest,indent=2))
text=Path('/downloads/editor-mascaras-beber-v9.html').read_text();assets=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',text,re.S)[1]);old=json.loads(Path('/downloads/rancho-mascaras-beber-v9-completo.json').read_text());all_assets=assets+new
project=dict(old);project['baseline']='rancho-20261111-hat-v10';project['bases']=old['bases']+[dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in new]
assert project['changes']==old['changes'] and project['bases'][:101]==old['bases']
text=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda _:'const ASSETS = '+json.dumps(all_assets,separators=(',',':'))+';\nconst BASELINE',text,flags=re.S)
text=re.sub(r'const INCLUDED_PROJECT = .*?;\n',lambda _:'const INCLUDED_PROJECT = '+json.dumps(project,separators=(',',':'))+';\n',text,count=1)
# Only mutate surrounding text and code, not embedded image data.
parts=text.split('const ASSETS = ',1);prefix,rest=parts;encoded,rest=rest.split(';\nconst BASELINE',1)
rest=rest.replace('rancho-20261111-drink-v9','rancho-20261111-hat-v10').replace('20261111.v9.drink-hat','20261111.v10.hat-separate').replace('mascaras-v9-beber','mascaras-v10-sombreros')
rest=rest.replace("function materialsFor(kind){", "function materialsFor(kind){ if(kind === 'hat') return ['hat','erase'];")
rest=rest.replace("a.kind === 'rgb-hat'", "(a.kind === 'rgb-hat' || a.kind === 'hat')")
rest=rest.replace('101 máscaras y tus tus trazos PixelLab',f'{len(all_assets)} máscaras y tus trazos originales intactos')
prefix=prefix.replace('Editor de máscaras v9','Editor de máscaras v10')
prefix=re.sub(r'(<h1>.*?</h1>\s*)<p class="hint">.*?</p>',lambda m:m[1]+'<p class="hint">v10: sombreros en capas nuevas y separadas. Las 101 bases anteriores y todos tus trazos se conservan EXACTOS. Busca “Sombrero PixelLab” para marcha/galope, “Sombrero clásico” para salto/aturdido, o Beber/Adulto HD. En capas nuevas solo hay Sombrero y Goma. El resto del caballo no se toca. Devuelve JSON completo. Sin APK.</p>',prefix,count=1,flags=re.S)
text=prefix+'const ASSETS = '+encoded+';\nconst BASELINE'+rest
# Byte-compare every old embedded source and mask, plus original stroke arrays.
check=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',text,re.S)[1]);assert check[:101]==assets
for a in check:
 for k in ['s','m']:Image.open(io.BytesIO(base64.b64decode(a[k].split(',')[1]))).verify()
Path('/downloads/editor-mascaras-sombreros-v10.html').write_text(text);Path('/downloads/rancho-mascaras-sombreros-v10-completo.json').write_text(json.dumps(project,separators=(',',':')))
print(json.dumps(dict(old_bases=101,new_hat_layers=len(new),total=len(check),old_changes=len(project['changes']),old_strokes=sum(len(c['strokes']) for c in project['changes']),old_bases_exact=True,old_assets_exact=True,old_strokes_exact=True)))
