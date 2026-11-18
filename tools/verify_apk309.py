"""Verify export-only source exclusion, unchanged runtime media and preserved originals."""
import json,hashlib,sys
from pathlib import Path
from zipfile import ZipFile
root=Path(__file__).resolve().parents[1]
before,after=map(ZipFile,sys.argv[1:3])
rows=json.loads((root/'docs/review309/before-files.json').read_text())
originals=json.loads((root/'docs/review309/preserved-originals.json').read_text())
allowed=set()
for original in originals:
 path=original['path'];assert hashlib.sha256((root/path).read_bytes()).hexdigest()==original['sha256']
 allowed.add('assets/'+path+'.import')
 allowed.update(r['apk_path'] for r in rows if r['path']==path)
a=set(before.namelist());b=set(after.namelist())
assert a-b==allowed,(a-b)^allowed
assert not b-a,b-a
media=[r for r in rows if r['type'] in ['texture','audio'] and r['apk_path'] in b]
assert all(before.read(r['apk_path'])==after.read(r['apk_path']) for r in media)
print(json.dumps({'preserved_originals':len(originals),'removed_expected_entries':len(allowed),'byte_identical_runtime_media':len(media)},indent=2))
