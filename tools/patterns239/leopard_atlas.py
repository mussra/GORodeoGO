from PIL import Image,ImageDraw,ImageFilter
from pathlib import Path
import random,math
root=Path(__file__).resolve().parents[2];w,h=936,983
edge=Image.new('L',(w,h));inner=Image.new('L',(w,h));e=ImageDraw.Draw(edge);c=ImageDraw.Draw(inner);rng=random.Random(23912)
for yy in range(-50,h+60,69):
 for xx in range(-50,w+60,69):
  x=xx+rng.uniform(-17,17);y=yy+rng.uniform(-17,17);radius=rng.uniform(20,28);angle=rng.uniform(0,6.28);ratio=rng.uniform(.7,1.05)
  pts=[]
  for k in range(32):
   a=k/32*math.tau;rr=radius*(1+.13*math.sin(a*3+angle)+.08*math.cos(a*5-angle));dx=math.cos(a)*rr;dy=math.sin(a)*rr*ratio;pts.append((x+dx*math.cos(angle)-dy*math.sin(angle),y+dx*math.sin(angle)+dy*math.cos(angle)))
  c.polygon(pts,fill=255)
  # Thick broken irregular rings; alternating single and double openings.
  start=rng.randrange(32);segments=[(0,24)] if rng.random()<.55 else [(0,12),(16,28)]
  for lo,hi in segments:
   seg=[pts[(start+i)%32] for i in range(lo,hi)];e.line(seg,fill=255,width=rng.randint(10,15),joint='curve')
  if rng.random()<.25:e.ellipse((x+radius+5,y-4,x+radius+12,y+4),fill=255)
edge=edge.filter(ImageFilter.GaussianBlur(.55));inner=inner.filter(ImageFilter.GaussianBlur(.55));im=Image.merge('RGB',(edge,inner,Image.new('L',(w,h))));atlas=Image.open(root/'art/patterns/wild238.png').convert('RGB');atlas.paste(im.resize((512,512),Image.Resampling.LANCZOS),(0,0));atlas.save(root/'art/patterns/wild238.png')
