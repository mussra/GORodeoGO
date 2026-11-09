"""Append the dedicated portrait pattern mask to the existing offline editor.
Keeps the prior baseline and storage keys so saved edits are not lost.
"""
import base64,hashlib,json,re,sys
from pathlib import Path
R=Path(__file__).resolve().parents[2]
source=Path(sys.argv[1]);target=Path(sys.argv[2])
html=source.read_text();match=re.search(r'const ASSETS = (.*?);\nconst BASELINE',html,re.S)
items=json.loads(match.group(1));items=[a for a in items if a['id']!='portrait-light-legs']
mask=(R/'art/portraits/adult_light_legs_mask.png').read_bytes();art=(R/'art/portraits/adult_hd.png').read_bytes()
items.insert(0,dict(id='portrait-light-legs',name='Retrato · Patas claras (borde de los calcetines)',kind='socks',w=936,h=983,hash=hashlib.sha256(mask).hexdigest(),s='data:image/png;base64,'+base64.b64encode(art).decode(),m='data:image/png;base64,'+base64.b64encode(mask).decode()))
html=html[:match.start(1)]+json.dumps(items,separators=(',',':'))+html[match.end(1):]
html=html.replace("function materialsFor(kind){ return", "function materialsFor(kind){ if(kind === 'socks') return ['coat','erase']; return")
html=html.replace("b.textContent = m === 'eye'", "b.textContent = k === 'socks' && m === 'coat' ? 'Patas claras' : m === 'eye'")
html=html.replace("let col = isEye(a.kind)", "let col = isEye(a.kind)")
html=html.replace("const shade = Math.max", "if(a.kind === 'socks') col = [245,237,217];\n    const shade = Math.max")
html=html.replace('Base con zonas de linaje del 6 de noviembre', 'Incluye Patas claras del retrato, editable con pincel y goma. Guarda y devuelve los cambios para aplicarlos a la APK. Base con zonas de linaje del 6 de noviembre')
html=html.replace('pelaje, crin, ojos, sombrero y zonas de linaje, incluidos', 'patas claras, pelaje, crin, ojos, sombrero y zonas de linaje, incluidos')
target.write_text(html)
print('Editor entries:',len(items), 'bytes:',target.stat().st_size)
