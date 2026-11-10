from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
f='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf';font=ImageFont.truetype(f,27);small=ImageFont.truetype(f,21)
views={'side':'Lateral','down':'Abajo','up':'Arriba','diag_down':'Diagonal abajo','diag_up':'Diagonal arriba'}
for kind,title in [('rider','Caballo con jinete'),('horse','Caballo salvaje')]:
 out=Path('/downloads/pattern-video-'+kind);out.mkdir(exist_ok=True)
 for vnum,(view,label) in enumerate(views.items()):
  for step in range(36):
   frame=step%9;c=Image.new('RGB',(1280,720),'#eee8e0');d=ImageDraw.Draw(c)
   d.text((28,22),title+' · '+label+f' · frame {frame+1:02}/09',font=font,fill='#2b2320')
   d.text((28,65),'Prueba de patrones reales · máscaras v2 · mapas por pose experimentales',font=small,fill='#5a4f46')
   for x,p,name in zip([32,448,864],[2,10,11],['Moteado rojo · crema','Jirafa · ocre/castaño','Vaca · crema/oscuro']):
    im=Image.open(f'/downloads/pattern-preview-v2/{kind}/{view}/{p}/frame_{frame:02}.png').convert('RGBA').resize((384,384),Image.Resampling.NEAREST)
    d.text((x,122),name,font=small,fill='#2b2320')
    for yy in range(0,384,24):
     for xx in range(0,384,24):d.rectangle((x+xx,170+yy,x+xx+23,170+yy+23),fill='#fff' if (xx//24+yy//24)%2 else '#d5cec5')
    c.paste(im,(x,170),im)
   d.text((28,595),'Cabeza / cuello / tronco + seguimiento entre poses. No es correspondencia 3D.',font=small,fill='#2b2320')
   d.text((28,635),'Puede haber deriva en giros y crin/cola. No aplicado a la APK.',font=small,fill='#6b5e55')
   c.save(out/f'{vnum*36+step:03}.png')
 contact=Image.new('RGB',(1280,3600))
 for i in range(5):contact.paste(Image.open(out/f'{i*36:03}.png'),(0,i*720))
 contact.save(f'/downloads/pattern-{kind}-all.png')
