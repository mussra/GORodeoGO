from genetic_sheet import *
# Static texture experiment only. Original alpha, tack and rider retained.
out=a.copy();wave=(np.sin(x*.22+y*.12)+np.cos(y*.29-x*.09)+2)/4
neb=np.exp(-((y-(.45*x+21))/9)**2)
col=np.stack([30+105*wave+45*neb,28+40*wave+60*neb,80+100*wave+55*neb],2)*np.clip(mx/195,.3,1.2)[:,:,None]
mask=coat|mane
out[:,:,:3][mask]=np.clip(col,0,255)[mask]
for xx,yy in [(27,48),(32,60),(60,56),(69,38),(77,45),(62,65),(24,69),(72,67),(53,73),(67,28)]:
 if mask[yy,xx]:out[yy,xx,:3]=[244,247,255]
sp=Image.fromarray(out);sp.save(R/'art/galaxy_static_example.png')
sheet=Image.new('RGB',(960,620),'#f4efec');d=ImageDraw.Draw(sheet)
def txt(pos,s,size=22,b=False,fill='#251f21'):d.text(pos,s,font=ImageFont.truetype(bold if b else font,size),fill=fill)
txt((32,25),'RANCHO / GALAXY',32,True)
txt((32,73),'Acabado adicional propuesto: nebulosa violeta y estrellas.',22)
for xx,bg,label in [(32,'#c8bb8b','Fondo claro'),(480,'#46534e','Fondo oscuro')]:
 d.rounded_rectangle((xx,120,xx+416,475),14,fill=bg)
 p=sp.resize((288,288),Image.Resampling.NEAREST);sheet.paste(p,(xx+10,135),p)
 sheet.paste(sp,(xx+300,230),sp)
 txt((xx+280,345),'96 × 96 px',15,fill='white' if xx>100 else '#251f21')
 txt((xx+22,433),label,20,True,fill='white' if xx>100 else '#251f21')
txt((32,507),'Mismo sprite lateral. Se conservan jinete, silla y silueta.',20)
txt((32,543),'Sin rareza asignada, sin receta y sin animación validada.',20)
txt((32,582),'Propuesta estática · No APK · No sustituye oro, cristal ni hielo',17)
sheet.save('/downloads/rancho-galaxy-propuesta.png')
