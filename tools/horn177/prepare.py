from PIL import Image,ImageDraw,ImageFont
import numpy as np,json
from pathlib import Path
out=Path('/downloads/horn177');im=Image.open('/downloads/image-0107cf55.png');arr=np.array(im)
boxes=[(55,218,298,782),(390,218,610,782),(678,220,910,782),(984,222,1200,780),(1267,218,1490,782)]
meta=[]
for i,box in enumerate(boxes,1):
 crop=im.crop(box);a=np.array(crop);a[a[:,:,3]<12,3]=0;crop=Image.fromarray(a);crop.save(out/f'horn-{i}.png');meta.append({'id':i,'source_box':box,'assigned_view':None,'approved':False})
(out/'manifest.json').write_text(json.dumps(meta,indent=2))
root=Path('/downloads/gorodeo/gallop-apk')
sources=['art/experimental/pixellab/rider/side/frame_00.png','art/experimental/pixellab/rider/down/frame_00.png','art/experimental/pixellab/rider/diag_down/frame_00.png','art/experimental/pixellab/rider/diag_up/frame_00.png','art/experimental/pixellab/rider/up/frame_00.png','art/experimental/drink_preview83/pose_1.png']
canvas=Image.new('RGB',(1152,560),'#26414a');d=ImageDraw.Draw(canvas)
for i,p in enumerate(sources):
 base=Image.open(root/p).convert('RGBA');base.thumbnail((360,230),Image.Resampling.NEAREST);x=(i%3)*384;y=(i//3)*280;canvas.paste(base,(x,y),base);d.text((x+8,y+244),p.split('/')[-2],fill='white')
canvas.save(out/'pose-reference.png')
