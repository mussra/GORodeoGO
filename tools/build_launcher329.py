"""Reuse the existing rider pixels; no generated or redrawn artwork."""
from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import math,json
root=Path(__file__).resolve().parents[1]
im=Image.open(root/'art/icon.png').convert('RGBA')
# The rider does not touch the original decorative frame. This inner crop
# excludes that frame; only the flat green background is made transparent.
rider=im.crop((46,27,202,230))
for y in range(rider.height):
 for x in range(rider.width):
  r,g,b,a=rider.getpixel((x,y))
  if g>r and g>b and abs(g-b)<30:rider.putpixel((x,y),(r,g,b,0))
rider=rider.crop(rider.getbbox())
# Keep even the bounding-box corners inside the 66dp-diameter safe circle.
scale=252/math.hypot(*rider.size)
rider=rider.resize((round(rider.width*scale),round(rider.height*scale)),Image.Resampling.LANCZOS)
fg=Image.new('RGBA',(432,432));fg.alpha_composite(rider,((432-rider.width)//2,(432-rider.height)//2))
bg=Image.new('RGBA',(432,432),(54,101,92,255))
folder=root/'art/launcher329';fg.save(folder/'foreground.png');bg.save(folder/'background.png')
# Legacy launcher fallback has equal visual scale to the adaptive viewport.
combined=Image.alpha_composite(bg,fg)
combined.crop((72,72,360,360)).resize((192,192),Image.Resampling.LANCZOS).save(folder/'legacy.png')
preview=Image.new('RGB',(900,350),'#14262c');draw=ImageDraw.Draw(preview)
font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',19)
for i,shape in enumerate(['circle','rounded','square']):
 tile=combined.crop((72,72,360,360)).resize((200,200),Image.Resampling.LANCZOS)
 mask=Image.new('L',(200,200));md=ImageDraw.Draw(mask)
 if shape=='circle':md.ellipse((0,0,199,199),fill=255)
 elif shape=='rounded':md.rounded_rectangle((0,0,199,199),radius=47,fill=255)
 else:md.rectangle((0,0,199,199),fill=255)
 preview.paste(tile,(50+i*300,30),mask);draw.text((110+i*300,250),'Rancho',font=font,fill='#fff1d2')
 preview.paste(tile.resize((48,48)),(125+i*300,290),mask.resize((48,48)))
preview.save(root/'docs/review329/launcher-masks.png')
points=[(x,y) for y in range(432) for x in range(432) if fg.getpixel((x,y))[3]>0]
radius=max(math.hypot(x-215.5,y-215.5) for x,y in points)
assert radius<132,(radius,fg.getbbox())
(folder/'geometry.json').write_text(json.dumps({'canvas':432,'bbox':fg.getbbox(),'max_radius':radius,'safe_radius':132,'source':'art/icon.png'},indent=2))
print('Safe radius',radius,'bbox',fg.getbbox())
