from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import numpy as np,json
R=Path(__file__).resolve().parents[2];poses=json.loads((R/'tools/mask_editor/reviews/v4-transfer-report.json').read_text());font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',20)
contact=Image.new('RGB',(4*600,4*320),'#f4efec')
def recolor(a,m):
 rgb=a[:,:,:3].astype(float);shade=np.clip(rgb.max(2)/210,.2,1.15);out=a.copy()
 for ch,color in [(0,[225,100,160]),(1,[50,143,235])]:
  z=m[:,:,ch]>0;out[z,:3]=np.clip(np.array(color)*shade[z,None],0,255).astype('uint8')
 return Image.fromarray(out)
for n,p in enumerate(poses):
 v=p['view'];i=p['frame']-1;panel=Image.new('RGB',(600,320),'#f4efec');d=ImageDraw.Draw(panel);d.text((8,4),v+' '+str(i+1)+' | jinete / antes / después',font=font,fill='#302820')
 for c,(actor,ver) in enumerate([('rider',3),('horse',3),('horse',4)]):
  a=np.array(Image.open(R/f'art/experimental/pixellab/{actor}/{v}/frame_{i:02}.png').convert('RGBA'));m=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v{ver}/{actor}/{v}/color_{i:02}.png'));im=recolor(a,m).resize((192,192),Image.Resampling.NEAREST);panel.paste(im,(c*200,45),im)
 contact.paste(panel,((n%4)*600,(n//4)*320))
contact.save('/downloads/v4-transfer-all16.png')
out=Path('/downloads/v4-compare-video');out.mkdir(exist_ok=True);n=0
for view,frames in [('diag_down',range(2,9)),('diag_up',range(9))]:
 for loop in range(4):
  for i in frames:
   canvas=Image.new('RGB',(1280,720),'#f4efec');d=ImageDraw.Draw(canvas);big=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',28)
   d.text((32,20),f'V4 · Salvaje · {view} · frame {i+1:02}/09',font=big,fill='#302820')
   d.text((32,65),'16 poses derivadas del jinete equivalente · 74 correcciones sin cambios · Sin APK',font=font,fill='#62534b')
   for c,(actor,ver,title) in enumerate([('rider',3,'Referencia: corrección de Ant'),('horse',3,'Antes: máscara v3'),('horse',4,'Después: derivada v4')]):
    a=np.array(Image.open(R/f'art/experimental/pixellab/{actor}/{view}/frame_{i:02}.png').convert('RGBA'));m=np.array(Image.open(R/f'art/experimental/pixellab_masks_review_v{ver}/{actor}/{view}/color_{i:02}.png'));im=recolor(a,m).resize((384,384),Image.Resampling.NEAREST);x=32+c*416;d.text((x,120),title,font=font,fill='#302820');canvas.paste(im,(x,170),im)
   d.text((32,600),'Rosa = pelaje y manchas. Azul = crin / cola. Ajuste entre siluetas diferentes.',font=font,fill='#302820')
   d.text((32,640),'Borrador: revisa cuello, crin y patas. Las zonas tapadas por el jinete se continúan.',font=font,fill='#62534b')
   canvas.save(out/f'{n:03}.png');n+=1
print('comparisonframes',n)
