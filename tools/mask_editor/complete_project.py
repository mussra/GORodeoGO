"""Upgrade one version's offline editor to full JSON roundtrips, not changes-only."""
import re,json,sys
from pathlib import Path
p=Path(sys.argv[1]);s=p.read_text()
s=s.replace("return JSON.stringify({format: 'rancho-mask-review', version: 1, baseline: BASELINE, changes});","return JSON.stringify({format: 'rancho-mask-review', version: 2, baseline: BASELINE, bases:ASSETS.map(a=>({id:a.id,hash:a.hash,mask:a.m})), changes});")
s=s.replace("doc.version !== 1", "![1,2].includes(doc.version)")
s=s.replace("const next = {};", "if(doc.version===2){ if(!Array.isArray(doc.bases)||doc.bases.length!==ASSETS.length)throw Error('Faltan bases completas');for(const entry of doc.bases){const a=ASSETS.find(a=>a.id===entry.id);if(!a||a.hash!==entry.hash||!entry.mask.startsWith('data:image/png;base64,'))throw Error('Base incompatible');}for(const entry of doc.bases)ASSETS.find(a=>a.id===entry.id).m=entry.mask;}\n    const next = {};")
p.write_text(s)
a=json.loads(re.search(r'const ASSETS = (.*?);\nconst BASELINE',s,re.S).group(1));baseline=re.search(r"const BASELINE = '([^']+)'",s).group(1)
Path(sys.argv[2]).write_text(json.dumps(dict(format='rancho-mask-review',version=2,baseline=baseline,bases=[dict(id=x['id'],hash=x['hash'],mask=x['m']) for x in a],changes=[]),separators=(',',':')))
