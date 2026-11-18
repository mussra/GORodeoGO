from pathlib import Path
from PIL import Image
import json
import numpy as np
from scipy.ndimage import label,find_objects
ROOT=Path(__file__).resolve().parents[1]
src=ROOT/'art/ui/frontier303/source/ant-sheet.png'
out=ROOT/'art/ui/frontier303';out.mkdir(parents=True,exist_ok=True)
im=Image.open(src).convert('RGBA')
records=[]
for name,col,row in [('book',0,0),('crowns',1,0),('mission',2,0),('debug',0,1),('performance',1,1)]:
 cell=im.crop((col*512,row*512,(col+1)*512,(row+1)*512))
 # Ignore isolated near-transparent specks for framing. Preserve original alpha inside a padded visible contour.
 alpha=np.asarray(cell)[:,:,3];labels,count=label(alpha>16);sizes=np.bincount(labels.ravel());main=int(np.argmax(sizes[1:])+1)
 bounds=find_objects(labels==main)[0];bbox=(max(0,bounds[1].start-4),max(0,bounds[0].start-4),min(512,bounds[1].stop+4),min(512,bounds[0].stop+4))
 art=cell.crop(bbox);art.thumbnail((224,224),Image.Resampling.LANCZOS)
 tile=Image.new('RGBA',(256,256));tile.paste(art,((256-art.width)//2,(256-art.height)//2))
 tile.save(out/(name+'.png'))
 records.append({'name':name,'cell':[col,row],'alpha_bbox':bbox,'size':list(art.size)})
(out/'crops.json').write_text(json.dumps({'source_size':list(im.size),'alpha_extrema':list(im.getchannel('A').getextrema()),'real_alpha':True,'background_removed':False,'crops':records},indent=2))
