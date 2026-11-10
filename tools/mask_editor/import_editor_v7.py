"""Render v7 JSON with the editor's own canvas engine. Default is dry output only.

python import_editor_v7.py exported.json --editor /path/editor.html --out /tmp/masks
Add --apply only after visual review. Scope is foal and portrait, never PixelLab.
"""
import argparse,base64,json,subprocess,time,urllib.request,tempfile,shutil
from pathlib import Path
import websocket
from PIL import Image
ap=argparse.ArgumentParser();ap.add_argument('project',type=Path);ap.add_argument('--editor',type=Path,required=True);ap.add_argument('--out',type=Path,required=True);ap.add_argument('--apply',action='store_true');args=ap.parse_args()
root=Path(__file__).resolve().parents[2];manifest=json.loads((root/'tools/mask_editor/v7-import-manifest.json').read_text());doc=json.loads(args.project.read_text())
if doc.get('baseline')!='rancho-20261110-v7' or doc.get('format')!='rancho-mask-review' or doc.get('version')!=2:raise ValueError('Not a complete v7 project')
bases={x['id']:x for x in doc['bases']}
if len(bases)!=97:raise ValueError('Expected 97 distinct base masks')
for id,item in manifest.items():
 if bases[id]['hash']!=item['hash']:raise ValueError('Unexpected base hash: '+id)
profile=tempfile.mkdtemp(prefix='rancho-mask-import-');port=9347
proc=subprocess.Popen(['google-chrome-stable','--headless=new','--no-sandbox','--disable-dev-shm-usage','--remote-allow-origins=*','--remote-debugging-port='+str(port),'--user-data-dir='+profile,args.editor.resolve().as_uri()],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
try:
 for _ in range(100):
  try:tabs=json.load(urllib.request.urlopen(f'http://localhost:{port}/json'));break
  except Exception:time.sleep(.1)
 ws=websocket.create_connection(next(t for t in tabs if t['type']=='page')['webSocketDebuggerUrl']);seq=0
 def js(code):
  global seq;seq+=1;ws.send(json.dumps(dict(id=seq,method='Runtime.evaluate',params=dict(expression=code,awaitPromise=True,returnByValue=True))))
  while True:
   r=json.loads(ws.recv())
   if r.get('id')==seq:break
  if 'exceptionDetails' in r['result']:raise RuntimeError(r)
  return r['result']['result'].get('value')
 time.sleep(.5)
 status=js("(async()=>{const f=new File(["+json.dumps(json.dumps(doc))+"],'project.json');await $('importFile').onchange({target:{files:[f],value:''}});return $('notice').textContent})()")
 if not status.startswith('Proyecto importado.'):raise ValueError(status)
 args.out.mkdir(parents=True,exist_ok=True);report=[]
 for id,item in manifest.items():
  data=js("(async()=>{index=ASSETS.findIndex(a=>a.id==="+json.dumps(id)+");await loadArt();render();return work.toDataURL('image/png')})()")
  path=args.out/(id+'.png');path.write_bytes(base64.b64decode(data.split(',',1)[1]));im=Image.open(path).convert('RGB')
  if im.size!=(item['w'],item['h']):raise ValueError('Unexpected dimensions')
  # Painting transparent canvas has no meaning in the game. Clip those pixels only.
  src=Image.open(root/item['source']).convert('RGBA');px=im.load();alpha=src.getchannel('A').load()
  for y in range(im.height):
   for x in range(im.width):
    if alpha[x,y]==0:px[x,y]=(0,0,0)
  im.save(path)
  report.append(dict(id=id,output=str(path),game_path=item['path']))
 if args.apply:
  for x in report:shutil.copyfile(x['output'],root/x['game_path'])
 print(json.dumps(dict(applied=args.apply,scope='foal+portrait only; PixelLab not applied',masks=report),indent=2))
finally:
 proc.terminate();proc.wait(timeout=10);shutil.rmtree(profile,ignore_errors=True)
