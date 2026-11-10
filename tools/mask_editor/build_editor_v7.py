"""Extend the same v6 editor with foal/portrait masks; preserve all old bases/strokes."""
from pathlib import Path
import re,json,base64,hashlib
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
s=Path('/downloads/editor-mascaras-pixellab-v6-con-retoques.html').read_text()
assets=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',s,re.S).group(1))
old=json.loads(Path('/downloads/rancho-pixellab-mascaras-v6-con-retoques-completo.json').read_text())
def uri(p):return 'data:image/png;base64,'+base64.b64encode((ROOT/p).read_bytes()).decode()
new=[('foal-color','Potro / Pelaje y crin','rgb','art/foal/base.png','art/horse_masks/foal/frame_00.png'),('foal-lower-legs','Potro / Patas bajas','socks','art/foal/base.png','art/lower_legs_masks/foal/frame_00.png'),('foal-eyes','Potro / Iris','eye','art/foal/base.png','art/foal/eyes.png'),('portrait-color','Adulto HD / Pelaje, crin y sombrero','rgb-hat','art/portraits/adult_hd.png','art/portraits/adult_hd_mask.png'),('portrait-lower-legs','Adulto HD / Patas bajas','socks','art/portraits/adult_hd.png','art/portraits/adult_lower_legs_mask.png'),('portrait-light-legs','Adulto HD / Patas claras','socks','art/portraits/adult_hd.png','art/portraits/adult_light_legs_mask.png'),('portrait-eyes','Adulto HD / Iris','eye','art/portraits/adult_hd.png','art/portraits/adult_eyes.png')]
manifest={}
for id,name,kind,src,mask in new:
 w,h=Image.open(ROOT/src).size
 digest=hashlib.sha256((ROOT/mask).read_bytes()).hexdigest()
 assets.append(dict(id=id,name=name,kind=kind,w=w,h=h,hash=digest,s=uri(src),m=uri(mask)))
 manifest[id]=dict(path=mask,source=src,hash=digest,w=w,h=h)
s=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda m:'const ASSETS = '+json.dumps(assets,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=s.replace('pixellab-20261110-v6','rancho-20261110-v7').replace('20261110.v6.ant1433','20261110.v7.all-masks').replace('mascaras-v6.json','mascaras-v7.json').replace('Revisión v6','Editor v7')
s=s.replace("if(![BASELINE,'pixellab-20261110-v5'].includes(doc.baseline))","if(doc.baseline!==BASELINE)")
s=s.replace("art().id === 'portrait-lower-legs'", "art().id.endsWith('lower-legs')")
s=s.replace("else setStatus(false, 'Proyecto de Ant 14:33 incluido: 35 poses y 146 trazos. Exporta una copia antes de cerrar.');", "else setStatus(false, 'Proyecto incluido: 97 máscaras y tus 146 trazos PixelLab. Exporta JSON antes de cerrar.');")
s=s.replace('90 poses · 5 vistas × 9 frames × 2 actores. 90 máscaras editables.', '97 máscaras: 90 poses PixelLab, 3 del potro y 4 del adulto HD.').replace('90 poses · 5 vistas × 9 frames × 2 actores.', '97 máscaras: PixelLab + Potro + Adulto HD.')
s=s.replace('v6 con tus retoques de las 14:33 ya incluidos: 35 poses, 146 trazos. No necesitas importar nada.', 'v7: Potro y Adulto HD añadidos sobre máscaras mejoradas. Tus 35 poses y 146 trazos PixelLab siguen intactos. Manchas usan Pelaje, no otra máscara.')
s=s.replace('El editor no cambia los mapas experimentales por pose.', 'Potro y Adulto HD tienen sus propias máscaras de patas e iris. En Adulto HD, azul significa sombrero; no pintes el resto del jinete. El editor no cambia los mapas experimentales por pose.')
s=s.replace('No modifica la APK.', 'No modifica la APK automáticamente. Devuelve el JSON completo para aplicar las máscaras revisadas al juego.')
# Keep the exact included stroke values; add complete base records for the new masks.
project=dict(format='rancho-mask-review',version=2,baseline='rancho-20261110-v7',bases=[dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in assets],changes=old['changes'])
s=s.replace('PixelLab · Revisión de máscaras nuevas','Rancho · Editor de máscaras v7')
s=re.sub(r'(<h1>.*?</h1>\s*)<p class="hint">.*?</p>',lambda m:m.group(1)+'<p class="hint">97 máscaras: Potro, Adulto HD y 90 poses PixelLab. Pelaje rojo, crin/cola verde y sombrero azul solo en el retrato. Las manchas usan el mismo pelaje. Bases del potro/adulto mejoradas; tus 146 trazos PixelLab anteriores siguen incluidos. Exporta JSON antes de cerrar. El editor no cambia el dibujo original ni la APK.</p>',s,count=1,flags=re.S)
s=s.replace('con versión v6','con versión v7').replace('Revisión v2 asistida:','Revisión editable:')
s=s.replace('.drawing canvas{display:block;width:100%;image-rendering:pixelated}', '.drawing canvas{display:block;width:100%;image-rendering:auto}')
s=s.replace("$('reviewCard'));", "$('reviewCard'));")
Path('/downloads/editor-mascaras-rancho-v7.html').write_text(s)
Path('/downloads/rancho-mascaras-v7-completo.json').write_text(json.dumps(project,separators=(',',':')))
(ROOT/'tools/mask_editor/v7-import-manifest.json').write_text(json.dumps(manifest,indent=2))
assert [dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in assets[:90]]==old['bases']
print('v7:97 masks; all90PixelLab bases and146strokes preserved')
