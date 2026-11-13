from PIL import Image,ImageDraw,ImageFont
import numpy as np,math
from pathlib import Path
O=Path('/downloads/horn177');R=Path('/downloads/gorodeo/gallop-apk')
font='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
def f(s):return ImageFont.truetype(font,s)
def tint(im,color):
 a=np.asarray(im).astype(float)/255;rgb=a[:,:,:3];lum=rgb@np.array([.2126,.7152,.0722]);lo=np.array(color)/255*.40;mid=np.array(color)/255;hi=np.ones(3)*.99
 # Three-tone ramp retains the source's broad volume and spiral shading.
 v=np.clip((lum-.24)/.74,0,1);low=np.minimum(v/.62,1)[:,:,None];high=np.maximum((v-.62)/.38,0)[:,:,None];dst=lo+(mid-lo)*low;dst=dst*(1-high)+hi*high
 a[:,:,:3]=np.clip(dst,0,1);return Image.fromarray((a*255).astype('uint8'))
def place(canvas,horn,base,tip):
 a=np.asarray(horn)[:,:,3];ys,xs=np.where(a>96);sb=np.array([(xs.min()+xs.max())/2,ys.max()-3.]);st=np.array([xs[np.argmin(ys)],ys.min()+2.]); # base/tip follow actual crop
 sv=st-sb;tv=np.array(tip)-base;angle=math.atan2(tv[1],tv[0])-math.atan2(sv[1],sv[0]);scale=np.linalg.norm(tv)/np.linalg.norm(sv);A=scale*np.array([[math.cos(angle),-math.sin(angle)],[math.sin(angle),math.cos(angle)]]);b=np.array(base)-A@sb;inv=np.linalg.inv(A);off=-inv@b;coef=tuple([*inv[0],off[0],*inv[1],off[1]])
 transformed=horn.transform(canvas.size,Image.Transform.AFFINE,coef,Image.Resampling.BICUBIC);return Image.alpha_composite(canvas,transformed)
colors=[('Marfil original',None),('Azul',(54,115,210)),('Rosa',(207,82,160)),('Verde',(57,151,103)),('Rojo',(196,54,64)),('Negro',(39,45,65))]
h=Image.open(O/'horn-1.png').convert('RGBA')
card=Image.new('RGB',(1200,670),'#f4efec');d=ImageDraw.Draw(card);d.text((32,24),'Cuerno recibido: estudio de tintes',font=f(31),fill='#251f21');d.text((32,68),'Solo color sobre el PNG original. Sin activar en el juego.',font=f(18),fill='#585254')
for i,(name,c) in enumerate(colors):
 hi=tint(h,c) if c else h.copy();hi.save(O/f'tint-{i}.png');hi.thumbnail((160,425));x=24+i*196;y=130;bg=Image.new('RGBA',(180,455),'#ffffff');bg.alpha_composite(hi,((180-hi.width)//2,(455-hi.height)//2));card.paste(bg.convert('RGB'),(x,y));d.text((x,605),name,font=f(19),fill='#251f21')
card.save(O/'tintes.png')
portrait=Image.open(R/'art/portraits/adult_hd.png').convert('RGBA');portrait=place(portrait,h,(828,224),(861,84));portrait.save(O/'portrait-horn.png');portrait.thumbnail((600,630));pc=Image.new('RGB',(700,760),'#26414a');pc.paste(portrait,((700-portrait.width)//2,82),portrait);dd=ImageDraw.Draw(pc);dd.text((26,20),'Prueba de anclaje en retrato',font=f(27),fill='white');dd.text((26,710),'Cuerno 1. Colocacion provisional, sin activar.',font=f(18),fill='white');pc.save(O/'retrato-prueba.png')
specs=[('Lateral','art/experimental/pixellab/rider/side/frame_00.png',(81,36),(91,21),1),('Frontal','art/experimental/pixellab/rider/down/frame_00.png',(48,46),(48,32),5),('Tres cuartos','art/experimental/pixellab/rider/diag_down/frame_00.png',(74,34),(84,19),3),('Beber','art/experimental/drink_preview83/pose_1.png',(86,70),(101,65),1)]
sheet=Image.new('RGB',(1200,890),'#26414a');d=ImageDraw.Draw(sheet);d.text((26,18),'Pruebas sobre sprites existentes',font=f(28),fill='white');d.text((26,58),'Ampliado 4x. Asignacion de vistas y oclusion aun sin aprobar.',font=f(18),fill='white')
for i,(name,path,base,tip,hidx) in enumerate(specs):
 src=Image.open(R/path).convert('RGBA');src=place(src,Image.open(O/f'horn-{hidx}.png'),base,tip);src.save(O/f'pose-{i}.png');big=src.resize((src.width*4,src.height*4),Image.Resampling.NEAREST);x=40+(i%2)*600;y=110+(i//2)*375;sheet.paste(big,(x,y),big);d.text((x+400,y+90),name,font=f(20),fill='white');normal=src;sheet.paste(normal,(x+425,y+140),normal);d.text((x+410,y+250),'1x',font=f(17),fill='white')
sheet.save(O/'poses-prueba.png')
