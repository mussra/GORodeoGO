#!/usr/bin/env python3
"""Compare replacement horse PNGs with the current art and masks.
Usage: python tools/validate_horse_art111.py NEW_ROOT --kind horse --out /tmp/art-review
NEW_ROOT contains side/frame_00.png etc. Pillow required. No art is generated.
Metrics flag changes, not semantic correctness. A human must inspect all overlays
and rendered recolorings. Identical alpha does not prove body/mane/UV alignment.
"""
import argparse,json
from pathlib import Path
from PIL import Image,ImageChops,ImageDraw
p=argparse.ArgumentParser();p.add_argument('new_root',type=Path);p.add_argument('--kind',choices=['horse','rider'],default='horse');p.add_argument('--out',type=Path,required=True);a=p.parse_args()
root=Path(__file__).resolve().parents[1];old=root/'art/experimental/pixellab'/a.kind;masks=root/'art/experimental/pixellab_masks_review_v5'/a.kind
rows=[];a.out.mkdir(parents=True,exist_ok=True)
for view in ['side','down','up','diag_down','diag_up']:
 sheet=Image.new('RGB',(4*96*3,9*(96*3+22)),(38,46,44));draw=ImageDraw.Draw(sheet)
 for i in range(9):
  name=f'frame_{i:02d}.png';replacement=a.new_root/view/name;record={'view':view,'frame':i,'missing':not replacement.exists()};rows.append(record)
  if not replacement.exists():continue
  before=Image.open(old/view/name).convert('RGBA');after=Image.open(replacement).convert('RGBA');mask=Image.open(masks/view/f'color_{i:02d}.png').convert('RGBA')
  record['size']=list(after.size);record['size_ok']=after.size==before.size
  if not record['size_ok']:continue
  ba=list(before.getchannel('A').getdata());aa=list(after.getchannel('A').getdata());mp=list(mask.getdata())
  intersection=sum(x>127 and y>127 for x,y in zip(ba,aa));union=sum(x>127 or y>127 for x,y in zip(ba,aa));record['alpha_iou']=intersection/max(1,union)
  masked=[max(r,g)>5 for r,g,b,alpha in mp];record['mask_pixels_outside_new_alpha']=sum(m and alpha<32 for m,alpha in zip(masked,aa));record['mask_pixels_outside_old_alpha']=sum(m and alpha<32 for m,alpha in zip(masked,ba))
  overlay=after.copy();color=Image.new('RGBA',after.size,(0,0,0,0));color.putdata([(255,40,60,110) if r>=g and r>5 else ((30,210,255,110) if g>5 else (0,0,0,0)) for r,g,b,alpha in mp]);overlay=Image.alpha_composite(overlay,color)
  delta=ImageChops.difference(before,after).convert('RGB')
  for col,image in enumerate([before,after,overlay,delta]):sheet.paste(image.resize((288,288),Image.Resampling.NEAREST).convert('RGB'),(col*288,i*310))
  draw.text((4,i*310+289),f'{view}/{name}: old | new | region mask overlay | pixel difference',fill='white')
 sheet.save(a.out/f'{view}-comparison.png')
(a.out/'metrics.json').write_text(json.dumps({'kind':a.kind,'rows':rows,'warning':'Metrics cannot validate anatomy, mane/body assignment or UV semantics. Inspect all views and recolored animation in game.'},indent=2))
print(json.dumps({'frames':len(rows),'missing':sum(r['missing'] for r in rows),'bad_dimensions':sum(not r.get('size_ok',True) for r in rows),'out':str(a.out)}))
