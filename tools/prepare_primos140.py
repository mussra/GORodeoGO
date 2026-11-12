from PIL import Image,ImageDraw,ImageFont
from collections import deque
from pathlib import Path
import hashlib,json
root=Path(__file__).resolve().parents[1];outputs=[]
for mode in ['normal','sorpresa']:
 src=root/f'art/npc/source/primos140/loco-{mode}-original.png';im=Image.open(src).convert('RGBA');w,h=im.size;rgb=im.load();seen=bytearray(w*h);q=deque()
 def bg(x,y):
  r,g,b,a=rgb[x,y]
  return min(r,g,b)>85 and max(r,g,b)-min(r,g,b)<34
 def add(x,y):
  i=y*w+x
  if not seen[i] and bg(x,y):seen[i]=1;q.append((x,y))
 for x in range(w):add(x,0);add(x,h-1)
 for y in range(h):add(0,y);add(w-1,y)
 # Verified enclosed negative space between staff and leg, not beard/socks.
 sx,sy=(490,850) if mode=='normal' else (460,900)
 add(sx,sy)
 while q:
  x,y=q.popleft()
  for xx,yy in [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]:
   if 0<=xx<w and 0<=yy<h:add(xx,yy)
 alpha=Image.new('L',(w,h));alpha.putdata([0 if v else 255 for v in seen]);im.putalpha(alpha)
 # Tiny isolated opaque backdrop fragments, if any, are removed outside the connected subject.
 bbox=alpha.getbbox();crop=im.crop(bbox);ch=144;cw=round(crop.width*ch/crop.height)
 sprite=crop.resize((cw,ch),Image.Resampling.NEAREST);canvas=Image.new('RGBA',(192,192));canvas.alpha_composite(sprite,((192-cw)//2,184-ch))
 out=root/f'art/npc/loco-{mode}140.png';canvas.save(out);canvas.save(f'/downloads/primos140/loco-{mode}192.png')
 outputs.append({'mode':mode,'source':str(src.relative_to(root)),'source_sha256':hashlib.sha256(src.read_bytes()).hexdigest(),'source_size':list((w,h)),'crop':bbox,'sprite_size':[cw,ch],'canvas':[192,192],'display_scale':.625,'display_visible_height':90})
# Actual game-scale size and enlarged nearest-neighbor inspection, without touching originals.
board=Image.new('RGB',(960,640),(38,78,45));draw=ImageDraw.Draw(board);font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',22)
for i,mode in enumerate(['normal','sorpresa']):
 im=Image.open(root/f'art/npc/loco-{mode}140.png');large=im.resize((384,384),Image.Resampling.NEAREST)
 board.paste(large,(i*480+42,62),large);small=im.resize((120,120),Image.Resampling.NEAREST);board.paste(small,(i*480+170,470),small)
 draw.text((i*480+30,20),mode+' - derivado 192px, vista 2x',font=font,fill='white');draw.text((i*480+48,600),'Abajo: 90px visibles en el juego',font=font,fill='white')
board.save('/downloads/primos140/comparacion.png')
# Check the transparent negative spaces on both requested backgrounds at 2x.
checks=Image.new('RGB',(800,460),(20,20,24));d=ImageDraw.Draw(checks)
for row,bg in enumerate([(20,20,24),(38,110,45)]):
 for col,mode in enumerate(['normal','sorpresa']):
  tile=Image.new('RGBA',(400,230),bg+(255,));sp=Image.open(root/f'art/npc/loco-{mode}140.png').resize((240,240),Image.Resampling.NEAREST);tile.alpha_composite(sp,(80,-8));checks.paste(tile.convert('RGB'),(col*400,row*230))
checks.save('/downloads/primos140/huecos-corregidos-2x.png')
Path('/downloads/primos140/metadata.json').write_text(json.dumps(outputs,indent=2))
print(json.dumps(outputs,indent=2))
