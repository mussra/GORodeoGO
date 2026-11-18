from pathlib import Path
from PIL import Image
import json
root=Path(__file__).resolve().parents[1];im=Image.open(root/'art/ui/logo304/source/ant-logo.png').convert('RGBA')
a=im.getchannel('A');box=a.point(lambda p:255 if p>16 else 0).getbbox();box=(max(0,box[0]-4),max(0,box[1]-4),min(im.width,box[2]+4),min(im.height,box[3]+4))
art=im.crop(box);art.save(root/'art/ui/logo304/logo.png')
(root/'art/ui/logo304/manifest.json').write_text(json.dumps({'original_size':im.size,'alpha_extrema':a.getextrema(),'crop':box,'result':art.size,'background_removed':False},indent=2))
