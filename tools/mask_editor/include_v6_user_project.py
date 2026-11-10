"""Preload Ant's complete v5 project into editor v6 without baking any stroke."""
from pathlib import Path
import json,re,hashlib
source=Path('/downloads/file-4265057f.json').read_text();doc=json.loads(source)
html=Path('/downloads/editor-mascaras-pixellab-v6.html').read_text()
assets=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',html,re.S).group(1))
assert len(doc['bases'])==90 and len(doc['changes'])==35
assert sum(len(c['strokes']) for c in doc['changes'])==146
assert [dict(id=a['id'],hash=a['hash'],mask=a['m']) for a in assets]==doc['bases']
# Keep raw numeric precision and each original field. Only baseline is renamed.
output=source.replace('"baseline":"pixellab-20261110-v5"','"baseline":"pixellab-20261110-v6"')
if json.loads(output)['baseline']!='pixellab-20261110-v6':
 output=re.sub(r'("baseline"\s*:\s*")pixellab-20261110-v5(")',r'\1pixellab-20261110-v6\2',source,count=1)
check=json.loads(output);assert check['bases']==doc['bases'] and check['changes']==doc['changes']
# A new draft namespace prevents an older empty v6 local draft masking these edits.
html=html.replace('20261110.v6\'','20261110.v6.ant1433\'')
html=html.replace('Math.round(n*2)/2','n') # Keep all original point precision in local drafts, too.
html=html.replace('let edits = {}, history = [], flags = [];','const INCLUDED_PROJECT = '+source+';\nlet edits = Object.fromEntries(INCLUDED_PROJECT.changes.map(c=>[c.id,c.strokes])), history = [], flags = [];')
html=html.replace('v6: al cambiar de pose conserva','v6 con tus retoques de las 14:33 ya incluidos: 35 poses, 146 trazos. No necesitas importar nada. Al cambiar de pose conserva')
html=html.replace('No hay borrador previo. Si el aviso indica guardado no confirmado, no cierres sin enviar copia.','Proyecto de Ant 14:33 incluido: 35 poses y 146 trazos. Exporta una copia antes de cerrar.')
Path('/downloads/editor-mascaras-pixellab-v6-con-retoques.html').write_text(html)
Path('/downloads/rancho-pixellab-mascaras-v6-con-retoques-completo.json').write_text(output)
# Exact source payload byte comparison after baseline normalization, not approximate floats.
assert output.replace('pixellab-20261110-v6','pixellab-20261110-v5')==source
print('JSON source bytes preserved except v5→v6 baseline; source SHA256',hashlib.sha256(source.encode()).hexdigest())
print('90 bases and146strokes preserved exactly in HTML INCLUDED_PROJECT and JSON')
