"""Editor-only tool retention; v5 art and user JSON are not baked or changed."""
from pathlib import Path
import json,re
source=Path('/downloads/editor-mascaras-pixellab-v5.html').read_text()
assert "material = materialsFor(k)[0];" in source
s=source.replace("material = materialsFor(k)[0];", "// Keep the user's active zone on pose changes. Only fall back if incompatible.\n  if(!materialsFor(k).includes(material)) material = materialsFor(k)[0];")
s=s.replace('20261110-v5','20261110-v6').replace('20261110.v5','20261110.v6').replace('mascaras-v5.json','mascaras-v6.json').replace('Revisión v5','Revisión v6').replace('versión v5','versión v6')
# Same masks: v5 user exports remain safe to restore into the editor-only v6.
s=s.replace("if(doc.baseline !== BASELINE)","if(![BASELINE,'pixellab-20261110-v5'].includes(doc.baseline))")
s=s.replace('90 poses · 5 vistas × 9 frames × 2 actores.', 'v6: al cambiar de pose conserva Pelaje/Crin/Goma y modo Pincel/Mano. Bases v5 sin cambios. Puedes importar tu JSON v5. 90 poses · 5 vistas × 9 frames × 2 actores.')
assets=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',s,re.S).group(1))
Path('/downloads/editor-mascaras-pixellab-v6.html').write_text(s)
Path('/downloads/rancho-pixellab-mascaras-v6-completo.json').write_text(json.dumps(dict(format='rancho-mask-review',version=2,baseline='pixellab-20261110-v6',bases=[dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in assets],changes=[]),separators=(',',':')))
assert assets==json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',source,re.S).group(1))
print('v6 generated: all90v5assetsidentical,14:33retouchJSONnotbaked')
