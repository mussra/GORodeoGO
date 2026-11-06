from PIL import Image,ImageDraw,ImageFont
src=Image.open('/downloads/rancho-potro-cuqui-propuesta.png').convert('RGB').resize((1313,875));out=Image.new('RGB',(1280,720),'#10252d');d=ImageDraw.Draw(out);f='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
def text(x,y,t,n=24,c='#fff0ce'):d.text((x,y),t,font=ImageFont.truetype(f,n),fill=c)
text(28,18,'RESULTADO DEL CRUCE · PROPUESTA',28)
foal=src.crop((860,28,1205,405));foal.thumbnail((470,500));foal=foal.resize((440,480));out.paste(foal,(420,90))
p=Image.open('/downloads/gorodeo/gallop-apk/art/player/walk_side/frame_00.png').convert('RGBA');p.thumbnail((145,145));out.paste(p,(80,150),p);q=p.transpose(Image.Transpose.FLIP_LEFT_RIGHT);out.paste(q,(1050,150),q)
text(55,110,'PROGENITOR A',22);text(1015,110,'PROGENITOR B',22);text(62,310,'Miniatura',20);text(1030,310,'Miniatura',20)
d.line((220,255,395,365),fill='#73a89a',width=3);d.line((1050,255,885,365),fill='#73a89a',width=3)
text(465,585,'CRÍA · DETALLES GRANDES',24)
text(28,642,'Maqueta de jerarquía, no pantalla implementada. Potrillo aún pendiente de aprobación.',22)
text(28,680,'Tamaño en pantalla, no tamaño físico en partida. Padres ilustrados con sprite actual.',18,'#9cbbbd')
out.save('/downloads/rancho-cruce-jerarquia-propuesta.png')
