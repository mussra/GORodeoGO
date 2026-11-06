from PIL import Image
from collections import deque
im=Image.open('/downloads/rancho-potro-cuqui-propuesta.png').convert('RGB').resize((1313,875)).crop((865,28,1200,405))
w,h=im.size;p=im.load();seen=set();q=deque()
def bg(x,y):
 r,g,b=p[x,y];return g>r*1.13 and b>r*1.12
for x in range(w):
 for y in (0,h-1):
  if bg(x,y):q.append((x,y));seen.add((x,y))
for y in range(h):
 for x in (0,w-1):
  if bg(x,y):q.append((x,y));seen.add((x,y))
while q:
 x,y=q.popleft()
 for a,b in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
  if 0<=a<w and 0<=b<h and (a,b) not in seen and bg(a,b):seen.add((a,b));q.append((a,b))
out=Image.new('RGBA',im.size);mask=Image.new('RGB',im.size)
for y in range(h):
 for x in range(w):
  if (x,y) in seen:continue
  r,g,b=p[x,y];out.putpixel((x,y),(r,g,b,255))
  # Cream mane/tail, forelock and pale feathering are explicit green channels.
  mane=r>g*1.01 and g>b*1.05 and g>100 and r/g<1.75 and (y<145 or x<150 or y>300)
  # Keep eyes, muzzle, facial blaze, hooves and inner ear details out of coat mask.
  coat=(r>g*1.28 and r>b*1.6 and r>85 and y>100)
  if x>215 and y<205:coat=False
  if y>330:coat=False
  mask.putpixel((x,y),(0,255,0) if mane else ((255,0,0) if coat else (0,0,0)))
b=out.getbbox();out=out.crop(b);mask=mask.crop(b)
out.save('/downloads/approved-foal-extracted.png');mask.save('/downloads/approved-foal-mask.png')
print(out.size)
