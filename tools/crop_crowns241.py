"""Crop the supplied provisional U-shaped garlands. Keep filenames stable for replacement."""
from pathlib import Path
from PIL import Image, ImageOps
import json,hashlib
import sys
round_style='--round' in sys.argv
source=Path('docs/crowns241/source_round.png' if round_style else 'docs/crowns241/source.png')
im=Image.open(source).convert('RGBA')
out=Path('art/ui/crowns241/round' if round_style else 'art/ui/crowns241');out.mkdir(exist_ok=True)
manifest={'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'source_mode':im.mode,'source_size':list(im.size),'transparent_corner':im.getpixel((0,0))[3]==0,'canvas':512,'margin':32,'shape':'round' if round_style else 'U','icons':[]}
for i,name in enumerate(['bulls','race','duel','joust','memory','cup']):
 x=i%3*512;y=i//3*512
 cell=im.crop((x,y,x+512,y+512))
 # Reject faint generation residue without cutting the antialiased art edges.
 a=cell.getchannel('A');box=a.point(lambda p:255 if p>32 else 0).getbbox()
 print(name,box)
 crop=cell.crop(box);alpha=crop.getchannel('A').point(lambda p:0 if p<=4 else p);crop.putalpha(alpha)
 crop.thumbnail((448,448),Image.Resampling.LANCZOS)
 canvas=Image.new('RGBA',(512,512),(0,0,0,0));canvas.alpha_composite(crop,((512-crop.width)//2,(512-crop.height)//2));canvas.save(out/(name+'.png'))
 gray=ImageOps.grayscale(canvas).convert('RGBA');gray.putalpha(canvas.getchannel('A').point(lambda p:round(p*.65)));gray.save(out/(name+'_pending.png'))
 manifest['icons'].append({'mode':name,'source_cell':[x,y,512,512],'trim_bbox':box,'art_size':list(crop.size),'files':[name+'.png',name+'_pending.png']})
Path('docs/crowns241/ASSET_MANIFEST_round.json' if round_style else 'docs/crowns241/ASSET_MANIFEST.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2))
