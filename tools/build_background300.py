from pathlib import Path
from PIL import Image,ImageOps,ImageEnhance,ImageFilter
import numpy as np,shutil
r=Path(__file__).resolve().parents[1];d=r/'art/ui/background300';d.mkdir(exist_ok=True,parents=True)
(d/'source').mkdir(exist_ok=True)
bg=ImageOps.fit(Image.open(d/'source/original.png').convert('RGB'),(1280,720),Image.Resampling.LANCZOS)
for name in ['main','content']:
 a=ImageEnhance.Color(bg).enhance(.8 if name=='main' else .45)
 if name=='content':a=a.filter(ImageFilter.GaussianBlur(5))
 a=a.convert('RGBA');scrim=Image.new('RGBA',a.size,(7,24,32,180))
 if name=='main':
  alpha=np.zeros((720,1280),dtype=np.uint8)
  for x in range(1280):alpha[:,x]=round(255*(.70-.38*min(x/780,1)))
  scrim.putalpha(Image.fromarray(alpha))
 a.alpha_composite(scrim);a.convert('RGB').save(d/(name+'.png'))
