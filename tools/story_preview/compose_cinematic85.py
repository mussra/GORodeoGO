"""Compose captured game frames, original narration and cinematic captions."""
from PIL import Image, ImageDraw, ImageFont
from pathlib import Path
import subprocess,math
root=Path(__file__).resolve().parents[2]
W,H,FPS=1280,720,24
font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',28)
small=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',16)
head=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',23)
texts=[(0,5.4,'BIENVENIDO AL RANCHO','Bienvenido al rancho. Tu caballo y tú tenéis dos caminos.'),(5.4,12.1,'MISIONES Y FRONTERA','En las misiones, supera retos por niveles.\nEn Frontera, explora y descubre encargos.'),(12.1,16.9,'UNA MISMA AVENTURA','Los dos modos comparten tus caballos y tus puntos.\nPuedes ir de uno al otro.'),(16.9,24.1667,'EL MERCADO','En el mercado puedes comprar y vender caballos.\nLas ofertas dependen del nivel más alto que hayas superado.')]
# Reuse a tree as a near-camera foreground layer, no new raster illustration.
foliage=Image.open(root/'art/world/cartoon/pine.png').convert('RGBA').resize((210,350),Image.Resampling.LANCZOS)
cmd=['ffmpeg','-y','-loglevel','error','-f','rawvideo','-pix_fmt','rgb24','-s','1280x720','-r','24','-i','-','-i','/downloads/speech-20261111-140058-2ec5d4b7.wav','-map','0:v','-map','1:a','-c:v','libx264','-preset','fast','-crf','21','-maxrate','3500k','-bufsize','7000k','-pix_fmt','yuv420p','-c:a','aac','-b:a','128k','-af','apad','-t','24.166667','-movflags','+faststart','/downloads/vaquero-cinematico85.mp4']
p=subprocess.Popen(cmd,stdin=subprocess.PIPE)
for n in range(580):
 t=n/FPS;shot=next(x for x in texts if x[0]<=t<x[1]);a,b,title,body=shot;u=(t-a)/(b-a)
 im=Image.open(f'/downloads/cinematic85-frames/{n:04d}.png').convert('RGBA')
 # Discrete foreground pass at the edge gives depth without hiding the rider.
 if a in [0,16.9]:im.alpha_composite(foliage,(-145+int(80*u),290-int(35*u)))
 d=ImageDraw.Draw(im)
 d.rectangle((0,0,W,52),fill='#08181e');d.rectangle((0,598,W,H),fill='#08181e')
 d.text((40,17),'RANCHO',font=head,fill='#f5d994');d.text((W-310,19),title,font=small,fill='#f4ead1')
 rows=body.split('\n')
 for j,line in enumerate(rows):
  tw=d.textlength(line,font=font);d.text(((W-tw)/2,616+j*36),line,font=font,fill='#fff5dc')
 # Short fades at scene changes, plus gentle opening/closing, keep shot cuts clean.
 fade=min(1.,(t-a)/.17,(b-t)/.17,t/.5,(24.1667-t)/.6)
 if fade<1:im=Image.blend(Image.new('RGBA',im.size,'#08181e'),im,max(0.,fade))
 if n in [60,200,360,500]:im.convert('RGB').save(f'/downloads/vaquero-cinematico85-frame-{n}.jpg',quality=94)
 p.stdin.write(im.convert('RGB').tobytes())
p.stdin.close();assert p.wait()==0
print('/downloads/vaquero-cinematico85.mp4')
