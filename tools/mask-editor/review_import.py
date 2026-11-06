#!/usr/bin/env python3
"""Validate a mask-review export and write candidates, never source masks."""
import argparse, hashlib, json, math
from pathlib import Path
from PIL import Image, ImageDraw
COLORS={'coat':(255,0,0),'hair':(0,255,0),'hat':(0,0,255),'eye':(255,255,255),'erase':(0,0,0)}
def run():
 p=argparse.ArgumentParser();p.add_argument('project',type=Path);p.add_argument('--output',type=Path,required=True);a=p.parse_args()
 root=Path(__file__).resolve().parents[2];out=a.output.resolve()
 if out.exists():raise ValueError('Output must be a new directory')
 if out==root or root in out.parents:raise ValueError('Output must be outside the repository')
 if a.project.stat().st_size>10000000:raise ValueError('Project too large')
 doc=json.loads(a.project.read_text());manifest=json.loads(Path(__file__).with_name('manifest.json').read_text());known={e['id']:e for e in manifest['assets']}
 if doc.get('format')!='rancho-mask-review' or doc.get('version')!=1 or doc.get('baseline')!='2.0' or not isinstance(doc.get('changes'),list):raise ValueError('Unsupported project')
 prepared=[];seen=set()
 for e in doc['changes']:
  key=e.get('id');meta=known.get(key)
  if not meta or key in seen:raise ValueError('Unknown or duplicate mask')
  seen.add(key);raw=(root/key).read_bytes();digest=hashlib.sha256(raw).hexdigest()
  if digest!=meta['hash'] or e.get('hash')!=digest:raise ValueError('Baseline hash mismatch: '+key)
  im=Image.open(root/key).convert('RGB')
  if im.size!=(meta['width'],meta['height']):raise ValueError('Size mismatch')
  strokes=e.get('strokes')
  if not isinstance(strokes,list) or len(strokes)>20000:raise ValueError('Invalid strokes')
  for s in strokes:
   if s.get('material') not in COLORS or not isinstance(s.get('radius'),(int,float)) or not math.isfinite(s['radius']) or not 0<s['radius']<=200:raise ValueError('Invalid brush')
   pts=s.get('points')
   if not isinstance(pts,list) or not pts or len(pts)>200000:raise ValueError('Invalid points')
   for xy in pts:
    if not isinstance(xy,list) or len(xy)!=2 or any(isinstance(v,bool) or not isinstance(v,(int,float)) or not math.isfinite(v) for v in xy) or not 0<=xy[0]<=im.width or not 0<=xy[1]<=im.height:raise ValueError('Invalid point coordinate')
  prepared.append((key,im,strokes))
 # All entries validated before any output is written.
 out.mkdir(parents=True)
 summary=[]
 for key,im,strokes in prepared:
  scale=4;big=im.resize((im.width*scale,im.height*scale),Image.Resampling.NEAREST);d=ImageDraw.Draw(big)
  for s in strokes:
   pts=[(x*scale,y*scale) for x,y in s['points']];r=s['radius']*scale;color=COLORS[s['material']]
   if len(pts)>1:d.line(pts,fill=color,width=max(1,round(2*r)),joint='curve')
   for x,y in pts:d.ellipse((x-r,y-r,x+r,y+r),fill=color)
  final=big.resize(im.size,Image.Resampling.LANCZOS);target=out/key;target.parent.mkdir(parents=True,exist_ok=True);final.save(target)
  summary.append({'id':key,'strokes':len(strokes),'output':str(target)})
 (out/'review-summary.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps({'masks':len(summary),'output':str(out),'source_changed':False}))
if __name__=='__main__':run()
