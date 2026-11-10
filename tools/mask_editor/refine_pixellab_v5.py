"""Import user's complete v3 state exactly, bake to version5, no cross-actor derivation."""
from pathlib import Path
from PIL import Image
import numpy as np,json,re,io,base64,hashlib
R=Path(__file__).resolve().parents[2];s=Path('/downloads/editor-mascaras-pixellab-v3.html').read_text();assets=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',s,re.S).group(1))
def uri(im):
 b=io.BytesIO();im.save(b,format='PNG');return 'data:image/png;base64,'+base64.b64encode(b.getvalue()).decode()
for a in assets:
 ident=a['id'];p=ident[len('pixellab-'):-len('-color')];actor,view,frame=p.split('-');d=R/f'art/experimental/pixellab_masks_review_v5/{actor}/{view}';d.mkdir(parents=True,exist_ok=True)
 im=Image.open('/downloads/ant-masks-1129-exact/'+ident+'.png').convert('RGB');im.save(d/f'color_{frame}.png');m=np.array(im);Image.fromarray(np.repeat(m[:,:,:1],3,2)).save(d/f'spots_{frame}.png');a['m']=uri(im);a['hash']=hashlib.sha256((d/f'color_{frame}.png').read_bytes()).hexdigest()
s=re.sub(r'const ASSETS = .*?;\nconst BASELINE',lambda _:'const ASSETS = '+json.dumps(assets,separators=(',',':'))+';\nconst BASELINE',s,flags=re.S)
s=s.replace('20261110-v3','20261110-v5').replace('20261110.v3','20261110.v5').replace('mascaras-v3.json','mascaras-v5.json').replace('Revisión v3','Revisión v5').replace('versión v3','versión v5')
s=s.replace('sobre el JSON nuevo de Ant (98 máscaras de 74 poses, base v1). Se usan sus zonas de pelaje y crin, recortadas a la silueta; lo no editado conserva el ajuste anterior.','sobre el JSON completo de Ant de las 11:29, base v3. 69 poses retocadas ahora y 90 acumuladas. Estado importado tal cual, sin derivaciones entre actores.')
Path('/downloads/editor-mascaras-pixellab-v5.html').write_text(s)
Path('/downloads/rancho-pixellab-mascaras-v5-completo.json').write_text(json.dumps(dict(format='rancho-mask-review',version=2,baseline='pixellab-20261110-v5',bases=[dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in assets],changes=[]),separators=(',',':')))
print('v5exact90, coat=spots90')
