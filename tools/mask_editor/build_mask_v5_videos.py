from PIL import Image,ImageDraw,ImageFont
import numpy as np
from pathlib import Path
R=Path('/downloads/gorodeo/gallop-apk')
f='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf';font=ImageFont.truetype(f,25);small=ImageFont.truetype(f,20);big=ImageFont.truetype(f,30)
labels={'side':'Lateral','down':'Abajo','up':'Arriba','diag_down':'Diagonal abajo','diag_up':'Diagonal arriba'}
for kind,title in [('rider','Caballo con jinete'),('horse','Caballo salvaje')]:
 out=Path('/downloads/maskvideo-v5-'+kind);out.mkdir(exist_ok=True);idx=0
 for view,label in labels.items():
  for step in range(27):
   frame=step%9
   src=Image.open(R/f'art/experimental/pixellab/{kind}/{view}/frame_{frame:02}.png').convert('RGBA');a=np.array(src);rgb=a[:,:,:3].astype(float)
   m=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v5/{kind}/{view}/color_{frame:02}.png'))
   spots=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v5/{kind}/{view}/spots_{frame:02}.png'))[:,:,0]>0
   result=rgb.copy();shade=np.clip(rgb.max(2)/210,.2,1.15)
   result[m[:,:,0]>0]=np.array([225,100,160])*shade[m[:,:,0]>0,None]
   result[m[:,:,1]>0]=np.array([50,143,235])*shade[m[:,:,1]>0,None]
   arr=a.copy();arr[:,:,:3]=np.clip(result,0,255).astype('uint8');recolor=Image.fromarray(arr)
   arr2=a.copy();arr2[spots,:3]=np.clip(rgb[spots]*.4+np.array([255,50,100])*.6,0,255).astype('uint8');pattern=Image.fromarray(arr2)
   canvas=Image.new('RGB',(1280,720),'#f4efec');d=ImageDraw.Draw(canvas)
   d.text((32,20),f'{title} · {label} · frame {frame+1:02}/09',font=big,fill='#2b2320')
   d.text((32,64),'Revisión v5 · manchas = máscara de pelaje · no aplicado a la APK',font=small,fill='#6b5e55')
   for x,im,name in zip([32,448,864],[src,recolor,pattern],['Original PixelLab','Pelaje rosa · crin azul','Manchas = pelaje (misma zona)']):
    d.text((x,115),name,font=small,fill='#2b2320')
    for yy in range(384):
     for xx in range(0,384,24):
      if (xx//24+yy//24)%2==0:d.line((x+xx,170+yy,x+xx+23,170+yy),fill='#ddd5cc')
    canvas.paste(im.resize((384,384),Image.Resampling.NEAREST),(x,170),im.resize((384,384),Image.Resampling.NEAREST))
   d.text((32,590),'Revisa: zonas sin teñir, crin/cola mal incluidas, jinete/silla/cascos invadidos.',font=small,fill='#2b2320')
   d.text((32,628),'Manchas usan exactamente la zona roja del pelaje. Sin mapas UV nuevos.',font=small,fill='#6b5e55')
   canvas.save(out/f'{idx:03}.png');idx+=1
 print(kind,idx,'frames')
