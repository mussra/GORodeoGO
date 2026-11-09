"""Add the original stocking recolor mask while preserving offline editor drafts."""
import base64,hashlib,json,re,sys
from pathlib import Path
R=Path(__file__).resolve().parents[2]
s=Path(sys.argv[1]).read_text();m=re.search(r'const ASSETS = (.*?);\nconst BASELINE',s,re.S);items=json.loads(m.group(1));items=[a for a in items if a['id']!='portrait-lower-legs']
mask=(R/'art/portraits/adult_lower_legs_mask.png').read_bytes();art=(R/'art/portraits/adult_hd.png').read_bytes()
items.insert(0,dict(id='portrait-lower-legs',name='Retrato · Patas bajas (recolor completo)',kind='socks',w=936,h=983,hash=hashlib.sha256(mask).hexdigest(),s='data:image/png;base64,'+base64.b64encode(art).decode(),m='data:image/png;base64,'+base64.b64encode(mask).decode()))
s=s[:m.start(1)]+json.dumps(items,separators=(',',':'))+s[m.end(1):]
s=s.replace("k === 'socks' && m === 'coat' ? 'Patas claras'", "k === 'socks' && m === 'coat' ? (art().id === 'portrait-lower-legs' ? 'Patas bajas' : 'Patas claras')")
s=s.replace('Incluye Patas claras del retrato','Incluye Patas bajas (recolor completo) y Patas claras del retrato')
Path(sys.argv[2]).write_text(s)
