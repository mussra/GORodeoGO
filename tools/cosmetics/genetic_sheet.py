from PIL import Image,ImageDraw,ImageFont
import numpy as np, colorsys
from pathlib import Path
R=Path(__file__).resolve().parents[2]
im=Image.open(R/'art/player/walk_side/frame_00.png').convert('RGBA');a=np.array(im);y,x=np.mgrid[:96,:96]
def poly(pts):
 m=Image.new('L',(96,96));ImageDraw.Draw(m).polygon(pts,fill=255);return np.array(m)>0
rider=poly([(35,27),(59,27),(61,37),(60,48),(59,60),(59,67),(53,72),(45,69),(43,61),(37,58),(34,48)])
rgb=a[:,:,:3].astype(float);mx=rgb.max(2);mn=rgb.min(2)
# Separate only horse coat orange, leaving rider and dark tack unchanged.
coat=(rgb[:,:,0]>rgb[:,:,1]*1.16)&(rgb[:,:,1]>rgb[:,:,2]*1.25)&(mx>95)&(y>30)&~rider&(a[:,:,3]>0)
mane=((x<25)&(y>40)&(y<76)|((x>58)&(x<75)&(y>25)&(y<51)))&(mx>120)&((mx-mn)<150)&(rgb[:,:,0]>rgb[:,:,2])&~rider&(a[:,:,3]>0)
# Torso-only masks keep the pattern off face, reins, saddle and mane.
body=coat&poly([(23,43),(38,41),(42,55),(58,64),(67,58),(70,66),(55,73),(31,71),(23,62)])
patterns={
 'Liso':np.zeros((96,96),bool),
 'Parches':(((x-30)**2/70+(y-53)**2/50<1)|((x-58)**2/45+(y-66)**2/25<1))&body,
 'Moteado':sum(((x-cx)**2+(y-cy)**2<rr**2) for cx,cy,rr in [(28,49,3),(34,57,3),(26,63,3),(39,65,3),(57,65,3),(64,63,2)])>0,
 'Trasera blanca':body&(x<36),
 'Patas claras':coat&(y>72)}
patterns['Moteado'] &= body
palette=[('Negro','#273440'),('Blanco','#e9e2d3'),('Dorado','#dda92c'),('Azul','#246bc5'),('Verde','#398c54'),('Rojo','#bd3e3e'),('Violeta','#8550ad'),('Turquesa','#27a6a0'),('Rosa','#d45f9d'),('Naranja','#e07730'),('Castaño','#975936'),('Gris','#8b96a0'),('Crema','#e3c388'),('Cobre','#bb6d45'),('Lima','#9db543'),('Marino','#334b84'),('Lavanda','#a192d1'),('Coral','#dc7972'),('Celeste','#72b7de'),('Ciruela','#774c77')]
crins={'Negra':'#222c37','Blanca':'#fff3d3','Dorada':'#f0ba2e','Azul':'#347ef0','Roja':'#e04c52','Arcoíris':None}
def hx(v):return np.array(tuple(bytes.fromhex(v[1:])))
def colorize(name,pat,crin):
 out=a.copy();base=hx(dict(palette)[name]);shade=np.clip(mx/205,.25,1.18)
 out[:,:,:3][coat]=np.clip(base[None,None,:]*shade[:,:,None],0,255)[coat]
 spots=patterns[pat]&coat
 out[:,:,:3][spots]=np.clip(np.array([244,237,216])[None,None,:]*shade[:,:,None],0,255)[spots]
 if crins[crin]:c=np.broadcast_to(hx(crins[crin]),(96,96,3))
 else:
  c=np.array([[colorsys.hsv_to_rgb(((yy-25)/38)%1,.8,1) for xx in range(96)] for yy in range(96)])*255
 out[:,:,:3][mane]=np.clip(c*shade[:,:,None],0,255)[mane]
 return Image.fromarray(out)
examples=[('Negro','Liso','Blanca'),('Azul','Parches','Dorada'),('Dorado','Moteado','Negra'),('Verde','Trasera blanca','Roja'),('Rojo','Patas claras','Blanca'),('Violeta','Liso','Arcoíris'),('Turquesa','Parches','Negra'),('Castaño','Moteado','Azul'),('Ciruela','Trasera blanca','Dorada'),('Marino','Patas claras','Arcoíris'),('Coral','Parches','Blanca'),('Naranja','Moteado','Negra')]
W,H=1200,1180; sheet=Image.new('RGB',(W,H),'#f4efec');d=ImageDraw.Draw(sheet)
font='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf';bold=font.replace('.ttf','-Bold.ttf')
def txt(pos,s,size=22,b=False,fill='#251f21'):d.text(pos,s,font=ImageFont.truetype(bold if b else font,size),fill=fill)
txt((36,22),'RANCHO / VARIEDAD GENÉTICA',32,True)
txt((36,67),'12 ejemplos sobre el sprite real. Propuesta, no catálogo final.',22)
txt((36,105),'20 pelajes × 5 patrones × 6 crines = 600 combinaciones de diseño',23,True,fill='#347768')
txt((36,141),'Sin contar ojos ni equipo. Compatibilidad y legibilidad aún por validar.',19)
for idx,(name,pat,crin) in enumerate(examples):
 col=idx%3;row=idx//3;left=30+col*390;top=184+row*204
 d.rounded_rectangle((left,top,left+372,top+191),12,fill='white')
 # enlarged 1.5x for inspection, source-sized beside it
 sp=colorize(name,pat,crin);sp.save(R/f'art/genetic_example_{idx+1:02}.png')
 d.rectangle((left+12,top+8,left+360,top+142),fill='#c8bb8b')
 sheet.paste(sp.resize((144,144),Image.Resampling.NEAREST),(left+16,top-1),sp.resize((144,144),Image.Resampling.NEAREST))
 sheet.paste(sp,(left+229,top+10),sp)
 txt((left+221,top+111),'96 × 96 px',13)
 txt((left+12,top+146),f'{idx+1:02}  {name} / {pat}',17,True)
 txt((left+12,top+170),'Crin '+crin,16)
txt((36,1010),'20 pelajes candidatos',20,True)
for i,(n,c) in enumerate(palette):
 xx=36+(i%10)*116;yy=1044+(i//10)*47;d.rounded_rectangle((xx,yy,xx+26,yy+24),5,fill=c);txt((xx+31,yy+4),n,11)
txt((36,1142),'Vista estática lateral · Jinete y silla conservados · Sin APK ni reglas de herencia',17)
sheet.save('/downloads/rancho-genetica-12-ejemplos.png')
print('/downloads/rancho-genetica-12-ejemplos.png')
