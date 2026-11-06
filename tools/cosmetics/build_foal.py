from PIL import Image,ImageDraw
from pathlib import Path
R=Path(__file__).resolve().parents[2];out=R/'art/foal';out.mkdir(exist_ok=True)
a=Image.new('RGBA',(96,96));d=ImageDraw.Draw(a)
d.polygon([(29,45),(22,44),(15,54),(10,66),(19,63),(27,52)],fill='#eee3b9',outline='#463a2d')
d.ellipse((24,40,65,67),fill='#975936',outline='#4a3028',width=2)
for x,y in [(30,61),(39,62),(56,61),(62,59)]:
 d.polygon([(x,y),(x+5,y),(x+3,81),(x-1,81)],fill='#975936',outline='#4a3028');d.rectangle((x-2,80,x+4,83),fill='#3a3534')
d.polygon([(56,48),(59,25),(66,19),(75,23),(79,39),(73,48),(67,45),(65,58)],fill='#975936',outline='#4a3028')
d.polygon([(62,23),(61,12),(66,20),(69,21),(72,13),(74,26)],fill='#975936',outline='#4a3028')
d.polygon([(60,24),(55,30),(56,48),(60,53),(64,43),(66,26)],fill='#eee3b9',outline='#4a3028')
d.ellipse((73,33,84,43),fill='#d3b48c',outline='#4a3028');d.rectangle((74,27,77,30),fill='#201e22');d.point((75,27),fill='white');d.point((80,38),fill='#49382c')
a.save(out/'base.png')
# Separate masks for genetics on static foal, no rider or tack.
m=Image.new('RGB',(96,96));pix=a.load();mp=m.load()
for y in range(96):
 for x in range(96):
  c=pix[x,y]
  if c[:3]==(151,89,54):mp[x,y]=(255,0,0)
  elif c[:3]==(238,227,185):mp[x,y]=(0,255,0)
p=R/'art/horse_masks/foal';p.mkdir(exist_ok=True);m.save(p/'frame_00.png')
