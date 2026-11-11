from PIL import Image,ImageDraw
import numpy as np,json
im=Image.open('art/experimental/drink_preview83/source_ant.png').convert('RGB');meta=[];outputs=[]
for i in range(2):
 crop=im.crop((i*(im.width//2),0,(i+1)*(im.width//2),im.height));a=np.asarray(crop).astype(float);r,g,b=a[:,:,0],a[:,:,1],a[:,:,2]
 # Green screen dominance, retaining original painted RGB elsewhere. Decontaminate partial edges.
 dom=g-np.maximum(r,b);alpha=np.clip((125-dom)/90,0,1);alpha[g<np.maximum(r,b)+20]=1
 mask=alpha>.5;ys,xs=np.where(mask);bbox=(int(xs.min()),int(ys.min()),int(xs.max()+1),int(ys.max()+1))
 clean=a.copy();edge=(alpha>0)&(alpha<1);clean[:,:,1][edge]=np.minimum(g[edge],np.maximum(r[edge],b[edge])+10)
 rgba=np.dstack([clean,np.rint(alpha*255)]).astype('uint8');sprite=Image.fromarray(rgba).crop(bbox)
 # Common scale and translation: original paired poses share feet coordinates. No pose-specific stretch.
 outputs.append((sprite,bbox));meta.append({'pose':i,'source_bbox':bbox})
scale=83/max(s.height for s,_ in outputs)
for i,(s,box) in enumerate(outputs):
 size=(round(s.width*scale),round(s.height*scale));s=s.resize(size,Image.Resampling.LANCZOS)
 # Canvas feet baseline y90; use source x425 as common hoof reference, not silhouette center.
 anchor=round((im.width*.23957-box[0])*scale);x=48-anchor;y=91-s.height
 out=Image.new('RGBA',(112,96));out.alpha_composite(s,(x,y));out.save(f'art/experimental/drink_preview83/pose_{i}.png');meta[i].update(canvas=[112,96],position=[x,y],scale=scale)
# Native-size and enlarged comparison on ordinary dark and pale backgrounds.
out=Image.new('RGB',(1000,530),'#18333a');d=ImageDraw.Draw(out)
paths=['art/experimental/pixellab/rider/side/frame_00.png','art/experimental/drink_preview83/pose_0.png','art/experimental/drink_preview83/pose_1.png']
for i,p in enumerate(paths):
 s=Image.open(p).convert('RGBA');s=s.resize((s.width*3,s.height*3),Image.Resampling.NEAREST);out.paste(s,(i*330+10,60),s)
 d.text((i*330+12,20),['ACTUAL','NUEVA: CABEZA ARRIBA','NUEVA: CABEZA ABAJO'][i],fill='white')
 d.line((i*330,333,(i+1)*330,333),fill='#8ed5a5')
 s=Image.open(p).convert('RGBA');out.paste(s,(i*330+95,380),s)
d.text((20,494),'Misma altura y referencia de pies. Dos poses enviadas; sin crear intermedios ni recolor.',fill='white');out.save('/downloads/drink-art-comparison83.png')
json.dump(meta,open('art/experimental/drink_preview83/alignment.json','w'),indent=2)
print(meta)
