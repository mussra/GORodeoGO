"""Offline review draft only: conservative color/region segmentation, not approved game masks."""
from pathlib import Path
from PIL import Image
import numpy as np,base64,json,hashlib,re,io
R=Path(__file__).resolve().parents[2]
OUT=R/'art/experimental/pixellab_masks_draft'
items=[];report=[]
labels={'side':'Lateral','down':'Abajo','up':'Arriba','diag_down':'Diagonal abajo','diag_up':'Diagonal arriba'}
def uri(im):
 b=io.BytesIO();im.save(b,format='PNG');return 'data:image/png;base64,'+base64.b64encode(b.getvalue()).decode()
y,x=np.mgrid[:96,:96]
for kind in ['rider','horse']:
 for view in labels:
  for frame in range(9):
   src=R/f'art/experimental/pixellab/{kind}/{view}/frame_{frame:02}.png';im=Image.open(src).convert('RGBA');a=np.array(im);rgb=a[:,:,:3].astype(float);r,g,b=rgb.transpose(2,0,1)
   alpha=a[:,:,3]>100;mx=rgb.max(2);mn=rgb.min(2)
   # Gray/dark edges/eyes excluded. Warm horse palette plus cream hair.
   warm=(r>g*1.08)&(g>b*1.12)&(r>95)
   cream=(r>150)&(g>130)&(b>90)&((mx-mn)<100)&(r>=g*.95)
   if kind=='rider':
    # Rider, saddle and hat masks are deliberately excluded by view-specific polygons.
    from PIL import ImageDraw
    poly={'side':[(30,0),(62,0),(63,27),(58,39),(58,60),(48,68),(39,61),(30,43)],'down':[(20,0),(76,0),(76,34),(66,42),(64,67),(57,73),(54,58),(42,58),(38,73),(31,66),(30,42),(20,34)],'up':[(20,0),(77,0),(77,36),(66,47),(65,67),(55,69),(55,57),(42,57),(39,68),(28,64),(29,43)],'diag_down':[(25,0),(61,0),(64,28),(58,38),(56,58),(48,63),(39,58),(34,45),(28,36)],'diag_up':[(25,0),(64,0),(66,29),(61,36),(60,63),(52,72),(47,59),(37,50),(30,34)]}[view]
    rider=Image.new('1',(96,96));ImageDraw.Draw(rider).polygon(poly,fill=1);protect=np.array(rider)
    hair_region={'side':((x<30)&(y>40))|((x>63)&(y<52)&(y>25)),'down':(x>43)&(x<53)&(y>35)&(y<57),'up':(x>39)&(x<57)&(y>55),'diag_down':((x<34)&(y>37))|((x>56)&(y<45)&(y>24)),'diag_up':((x<43)&(y>47))|((x>60)&(y<44)&(y>25))}[view]
   else:
    protect=np.zeros((96,96),bool)
    hair_region={'side':((x<25)&(y>42))|((x>57)&(y<46)),'down':(y<31)|((x>43)&(x<52)&(y<45)),'up':(y>43)&(x>40)&(x<55),'diag_down':((x<36)&(y>38))|((x>55)&(y<34)),'diag_up':((x<42)&(y>39))|((x>57)&(y<31))}[view]
   hair=cream&hair_region&alpha&~protect
   coat=(warm|cream)&alpha&~protect&~hair
   # Restrict decorative spots to the coat, never rider/hair. This is eligibility, not fixed spots.
   mask=np.zeros((96,96,3),np.uint8);mask[:,:,0]=coat*255;mask[:,:,1]=hair*255
   pattern=np.repeat((coat*255).astype(np.uint8)[:,:,None],3,2)
   d=OUT/kind/view;d.mkdir(parents=True,exist_ok=True)
   for layer,pix in [('color',mask),('spots',pattern)]:
    out=d/f'{layer}_{frame:02}.png';m=Image.fromarray(pix);m.save(out);h=hashlib.sha256(out.read_bytes()).hexdigest()
    name=('Jinete' if kind=='rider' else 'Salvaje')+' · '+labels[view]+' / '+('Pelaje y crin' if layer=='color' else 'Zona de manchas')+f' · {frame+1:02}/09'
    items.append(dict(id=f'pixellab-{kind}-{view}-{frame:02}-{layer}',name=name,kind='rgb' if layer=='color' else 'pattern',w=96,h=96,hash=h,s=uri(im),m=uri(m)))
   report.append(dict(actor=kind,view=view,frame=frame,coat=int(coat.sum()),hair=int(hair.sum())))
assert len(items)==180
s=(R/'tools/mask_editor/template.html').read_text()
s=re.sub(r'const ASSETS = .*?;\nconst BASELINE', lambda _: 'const ASSETS = '+json.dumps(items,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=s.replace("review-20261106-aae61841d7e8","pixellab-20261110-v1").replace('rancho-mask-draft.aae61841d7e8','rancho-pixellab-mask-draft.20261110.v1').replace('rancho-mask-review-flags.20261107','rancho-pixellab-mask-flags.20261110.v1')
s=s.replace('Ajusta las máscaras de Rancho','PixelLab · Revisión de máscaras nuevas')
s=s.replace('Verde = crin y cola, rojo = pelaje, azul = sombrero, blanco = iris o zona de linaje','90 poses, 180 máscaras: cada pose tiene pelaje/crin y zona de manchas. Rojo = pelaje, verde = crin y cola, blanco = zona donde pueden aparecer manchas')
s=s.replace('Editor sin conexión: funciona aunque cierres el navegador y vuelvas.','Borrador automático por colores y regiones, pendiente de revisión. No aplicado al juego. Guarda una copia JSON antes de cerrar: el guardado local depende del navegador y de dónde abras este archivo.')
s=s.replace("return kind === 'eye' || kind === 'lineage'", "return kind === 'eye' || kind === 'lineage' || kind === 'pattern'")
s=s.replace("m === 'eye' && k === 'lineage' ? 'Zona de linaje'", "m === 'eye' && k === 'pattern' ? 'Zona de manchas' : m === 'eye' && k === 'lineage' ? 'Zona de linaje'")
s=s.replace("const host = $('groups');", "const host = $('groups'); host.innerHTML = '';")
s=s.replace("if(!maskReady || activePointer !== null) return;", "if(!maskReady || activePointer !== null || $('viewport').classList.contains('pan')) return;")
s=s.replace('ctx.drawImage(srcImg, 0, 0);','ctx.clearRect(0,0,cv.width,cv.height); ctx.drawImage(srcImg, 0, 0);')
s=s.replace('wctx.drawImage(maskBase, 0, 0);','wctx.clearRect(0,0,work.width,work.height); wctx.drawImage(maskBase, 0, 0);')
s=s.replace('const CAP = 14500;','const CAP = 4500000;')
s=s.replace('radius = 5, zoom = 1, offset = 60','radius = 2, zoom = 1, offset = 0').replace('id="radius" min="1" max="60" value="5"','id="radius" min="1" max="12" value="2"').replace('id="offset" min="0" max="140" step="5" value="60"','id="offset" min="0" max="140" step="5" value="0"').replace('id="radiusVal">5','id="radiusVal">2').replace('id="offVal">60','id="offVal">0')
s=s.replace("a.download = 'rancho-mascaras.json'", "a.download = 'rancho-pixellab-mascaras-v1.json'").replace('rancho-mascaras.json','rancho-pixellab-mascaras-v1.json')
s=s.replace('Yo suavizo los trazos y los generalizo antes de aplicarlos al juego.','Adjunta el JSON en el chat. Se revisa antes de aplicarlo al juego. No cierres sin exportar si el guardado no está confirmado.')
s=re.sub(r'<p class="hint">Incluye Patas bajas.*?</p>','<p class="hint">Propuesta automática conservadora: puede omitir bordes y confundir zonas claras o partes del jinete. Revisa en especial crin, cola, patas, silla y cara. La zona de manchas es una zona permitida sobre el pelaje, no manchas fijas dibujadas: estas bases son lisas. No se han generado mapas UV para estas poses. No modifica la APK.</p>',s)
s=s.replace("ASSETS.length + ' máscaras: patas claras, pelaje, crin, ojos, sombrero y zonas de linaje, incluidos los caballos salvajes (Salvaje ·).'", "'90 poses · 5 vistas × 9 frames × 2 actores. 180 máscaras editables. Borrador automático, no aprobado.'")
s=s.replace('wctx.drawImage(m, 0, 0);','wctx.clearRect(0,0,work.width,work.height);wctx.drawImage(m, 0, 0);')
s=s.replace("$('showPng').onclick = () => {","$('showPng').onclick = () => { if(!maskReady){ $('notice').textContent='Abre primero una máscara con Editar';return;} finishStroke();render();")
# Validate provenance on import, and make export commit any in-progress pointer first.
s=s.replace("function projectJson(){", "function projectJson(){\n  finishStroke();")
s=s.replace("if(doc.format !== 'rancho-mask-review'", "if(doc.baseline !== BASELINE) throw Error('Este JSON pertenece a otro editor/base');\n    if(doc.format !== 'rancho-mask-review'")
Path('/downloads/editor-mascaras-pixellab-v1.html').write_text(s)
Path('/downloads/pixellab-mask-draft-report.json').write_text(json.dumps(report,indent=2))
print('built',len(items),'masks htmlbytes',len(s))
