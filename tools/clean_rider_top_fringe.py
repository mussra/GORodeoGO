"""Remove only near-transparent fringe and isolated top pixels from existing rider art."""
from PIL import Image
from pathlib import Path
import json
report=[]
for p in sorted(Path('art/experimental/pixellab/rider').glob('*/frame_*.png')):
 im=Image.open(p).convert('RGBA');pix=im.load();changed=[]
 # JPEG-style transparent fringe: invisible alpha <=8, restricted to head region.
 for y in range(32):
  for x in range(im.width):
   if 0<pix[x,y][3]<=8:pix[x,y]=(0,0,0,0);changed.append([x,y])
 # Actual detached dot above hat in side8. Confirm this exact supplied-art pixel.
 if p.parent.name=='side' and p.stem=='frame_08':
  if pix[59,10][3]>0:pix[59,10]=(0,0,0,0);changed.append([59,10])
 if changed:im.save(p)
 report.append({'file':str(p),'removed':changed})
Path('docs/RIDER_FRINGE_AUDIT83.json').write_text(json.dumps(report,indent=2))
print('inspected',len(report),'frames; changed',sum(bool(x['removed']) for x in report),'pixels',sum(len(x['removed']) for x in report))
