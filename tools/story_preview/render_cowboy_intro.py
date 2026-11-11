"""Preview animatic using only the existing transparent menu illustration."""
from PIL import Image, ImageDraw, ImageFont
import math, subprocess, argparse, pathlib
ROOT=pathlib.Path(__file__).resolve().parents[2]
P=argparse.ArgumentParser();P.add_argument('--output',default='/downloads/vaquero-intro-prueba83.mp4');P.add_argument('--duration',type=float,default=32);P.add_argument("--breaks",default="");a=P.parse_args()
breaks=[float(x) for x in a.breaks.split(",")] if a.breaks else [a.duration*k/4 for k in range(1,4)]
W,H=1280,720;FPS=24
font='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
f=ImageFont.truetype(font,36);bold=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',28);small=ImageFont.truetype(font,20)
art=Image.open(ROOT/'art/ui/hero/rider_hd.png').convert('RGBA').resize((600,600),Image.Resampling.LANCZOS)
texts=[('Bienvenido al rancho','Bienvenido al rancho. Tu caballo y tú tenéis dos caminos.'),('Misiones y Frontera','En las misiones, supera retos por niveles. En Frontera, explora y descubre encargos.'),('Una misma aventura','Los dos modos comparten tus caballos y tus puntos. Puedes ir de uno al otro.'),('El mercado','En el mercado puedes comprar y vender caballos. Las ofertas dependen del nivel más alto que hayas superado.')]
def wrap(s,limit=515):
 rows=[];line=''
 for w in s.split():
  candidate=(line+' '+w).strip()
  if f.getlength(candidate)>limit:rows.append(line);line=w
  else:line=candidate
 return rows+[line]
proc=subprocess.Popen(['ffmpeg','-y','-loglevel','error','-f','rawvideo','-vcodec','rawvideo','-pix_fmt','rgb24','-s',f'{W}x{H}','-r',str(FPS),'-i','-','-an','-c:v','libx264','-preset','fast','-crf','19','-pix_fmt','yuv420p','-movflags','+faststart',a.output],stdin=subprocess.PIPE)
for n in range(round(a.duration*FPS)):
 t=n/FPS;idx=sum(t>=b for b in breaks);local=t-([0]+breaks)[idx]
 im=Image.new('RGBA',(W,H),'#10252d');d=ImageDraw.Draw(im)
 d.ellipse((-60,570,660,830),fill='#1e424b');d.line((24,659,1256,659),fill='#365862',width=2)
 d.text((34,27),'RANCHO · PRUEBA DE NARRADOR',font=bold,fill='#f6e8be')
 # Rigid transform keeps the hat brim and the hidden eye region together.
 tilt=.7*math.sin(t*1.35)+.35*math.sin(t*3.1)
 bob=4*math.sin(t*2.6)
 posed=art.rotate(tilt,resample=Image.Resampling.BICUBIC,expand=False)
 im.alpha_composite(posed,(12,65+round(bob)))
 d=ImageDraw.Draw(im)
 d.rounded_rectangle((644,140,1242,614),radius=28,fill='#f9f0d8')
 d.polygon([(644,284),(599,313),(644,329)],fill='#f9f0d8')
 d.text((674,169),'VAQUERO',font=small,fill='#526b67')
 d.text((674,205),texts[idx][0],font=bold,fill='#24423f')
 for j,row in enumerate(wrap(texts[idx][1])):d.text((674,264+j*49),row,font=f,fill='#182e34')
 for k in range(4):d.ellipse((1028+k*43,569,1040+k*43,581),fill='#2c766c' if k==idx else '#c8c9b9')
 d.text((34,677),'Animación de prueba con el arte actual · sin cambiar el juego',font=small,fill='#d2d9d5')
 d.text((1124,677),f'{idx+1} / 4',font=small,fill='#d2d9d5')
 if n in [24,round(a.duration*FPS*.375),round(a.duration*FPS*.625),round(a.duration*FPS*.875)]:im.convert('RGB').save('/downloads/vaquero-prueba-frame-%d.png'%idx)
 proc.stdin.write(im.convert('RGB').tobytes())
proc.stdin.close();assert proc.wait()==0
print(a.output)
