from pathlib import Path
from zipfile import ZipFile
from collections import defaultdict
import re,json,csv
root=Path('/downloads/gorodeo/gallop-apk');z=ZipFile('/downloads/Rancho-3.0.8.apk');entries={i.filename:i for i in z.infolist()};mapped={}
for p in root.rglob('*.import'):
 if '.godot' in p.parts:continue
 s=p.read_text();paths=re.findall(r'res://([^"\n]+)',s)
 for path in paths:
  if path.startswith('.godot/imported/'):mapped['assets/'+path]=str(p.relative_to(root))[:-7]
rows=[];groups=defaultdict(int);types=defaultdict(int)
for name,i in entries.items():
 src=mapped.get(name,name.removeprefix('assets/'));kind='texture' if name.endswith('.ctex') else 'audio' if name.endswith(('.sample','.oggstr','.mp3str')) else 'engine' if name.startswith('lib/') else 'code' if name.endswith(('.dex','.gdc','.gd')) else 'other'
 row={'path':src,'apk_path':name,'type':kind,'bytes':i.compress_size,'uncompressed':i.file_size};rows.append(row);types[kind]+=i.compress_size
 groups['/'.join(src.split('/')[:3]) if src.startswith(('art/','audio/')) else src.split('/')[0]]+=i.compress_size
out=root/'docs/review309';out.mkdir(parents=True,exist_ok=True)
(out/'before-files.json').write_text(json.dumps(rows,indent=2));
with (out/'before-files.csv').open('w') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(sorted(rows,key=lambda r:-r['bytes']))
print('TOTAL',Path('/downloads/Rancho-3.0.8.apk').stat().st_size,'TYPES',dict(types))
print('GROUPS');print('\n'.join(f'{v:10d} {k}' for k,v in sorted(groups.items(),key=lambda x:-x[1])[:60]))
print('TOP');print('\n'.join(f"{r['bytes']:10d} {r['path']}" for r in sorted(rows,key=lambda r:-r['bytes'])[:60]))
