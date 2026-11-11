"""Local browser QA: real pointer stroke, export/import and persistent reload."""
from pathlib import Path
import subprocess,tempfile,urllib.request,json,time,base64,shutil
import websocket
port=9359;profile=tempfile.mkdtemp(prefix='hat-editor83-')
proc=subprocess.Popen(['google-chrome-stable','--headless=new','--no-sandbox','--disable-dev-shm-usage','--remote-allow-origins=*',f'--remote-debugging-port={port}','--user-data-dir='+profile,Path('/downloads/editor-mascaras-sombreros-v10.html').as_uri()],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
try:
 for _ in range(100):
  try:tabs=json.load(urllib.request.urlopen(f'http://localhost:{port}/json'));break
  except Exception:time.sleep(.1)
 ws=websocket.create_connection(next(t for t in tabs if t['type']=='page')['webSocketDebuggerUrl']);seq=0
 def call(method,params={}):
  global seq;seq+=1;ws.send(json.dumps(dict(id=seq,method=method,params=params)))
  while True:
   r=json.loads(ws.recv())
   if r.get('id')==seq:break
  if 'error' in r:raise RuntimeError(r)
  return r['result']
 def js(code):
  r=call('Runtime.evaluate',dict(expression=code,awaitPromise=True,returnByValue=True))
  if 'exceptionDetails' in r:raise RuntimeError(r)
  return r['result'].get('value')
 time.sleep(.6)
 for width,height in [(390,844),(1280,900)]:
  call('Emulation.setDeviceMetricsOverride',dict(width=width,height=height,deviceScaleFactor=1,mobile=width==390))
  result=js("(async()=>{openEditor(ASSETS.findIndex(a=>a.id==='hat-pixellab-side-00'));await loadArt();view='result';render();return {tools:materialsFor(art().kind),count:ASSETS.length,strokes:INCLUDED_PROJECT.changes.reduce((n,c)=>n+c.strokes.length,0)}})()")
  assert result==dict(tools=['hat','erase'],count=196,strokes=303),result
  time.sleep(.2)
  data=call('Page.captureScreenshot',dict(format='png',captureBeyondViewport=False))['data'];Path(f'/downloads/editor-hats-v10-{width}.png').write_bytes(base64.b64decode(data))
 # Work on the source-coordinate hat through actual dispatched pointer events.
 js("view='overlay';render();$('cv').scrollIntoView({block:'center'});material='hat';radius=1")
 p=js("(()=>{const r=cv.getBoundingClientRect();return {x:r.left+47*r.width/96,y:r.top+17*r.height/96}})()")
 for kind in ['mousePressed','mouseReleased']:
  call('Input.dispatchMouseEvent',dict(type=kind,x=p['x'],y=p['y'],button='left',buttons=1 if kind=='mousePressed' else 0,clickCount=1))
 exported=js("projectJson()") if js("typeof projectJson")=='function' else js("exportJSON()")
 # Function name may vary: inspect the UI's own export handler fallback.
 project=json.loads(exported)
 assert project['baseline']=='rancho-20261111-hat-v10'
 old=json.loads(Path('/downloads/rancho-mascaras-beber-v9-completo.json').read_text())
 assert project['bases'][:101]==old['bases']
 byid={c['id']:c['strokes'] for c in project['changes']}
 assert all(byid[c['id']]==c['strokes'] for c in old['changes'])
 assert len(byid['hat-pixellab-side-00'])==1
 rendered=js("work.toDataURL('image/png')")
 call('Page.reload');time.sleep(.6)
 js("(async()=>{openEditor(ASSETS.findIndex(a=>a.id==='hat-pixellab-side-00'));await loadArt();render()})()")
 assert js("work.toDataURL('image/png')")==rendered
 status=js("(async()=>{const f=new File(["+json.dumps(exported)+"],'complete.json');await $('importFile').onchange({target:{files:[f],value:''}});return $('notice').textContent})()")
 assert status.startswith('Proyecto importado.'),status
 assert js("work.toDataURL('image/png')")==rendered
 print(json.dumps(dict(widths=[390,1280],old_bases_exact=True,old_strokes_exact=303,new_hat_stroke=1,reload_pixel_exact=True,import_pixel_exact=True)))
finally:
 proc.terminate();proc.wait(timeout=10);shutil.rmtree(profile,ignore_errors=True)
