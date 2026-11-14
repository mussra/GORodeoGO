from PIL import Image,ImageDraw
from scipy.ndimage import label,find_objects,binary_dilation
import numpy as np
from pathlib import Path
import argparse
p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('output');a=p.parse_args();im=Image.open(a.source);out=Path(a.output);out.mkdir(parents=True,exist_ok=True);board=Image.new('RGB',(900,340),'#17333d')
for i,name in enumerate(['atlas','frontier','levels']):
 cell=im.crop((round(i*im.width/3),0,round((i+1)*im.width/3),im.height));ar=np.array(cell);labs,n=label(ar[:,:,3]>150);counts=np.bincount(labs.ravel());keep=np.zeros(labs.shape,bool)
 for j,sl in enumerate(find_objects(labs),1):
  if counts[j]>100 and not (sl[0].stop<115 and sl[1].stop<110):keep|=labs==j
 mask=binary_dilation(keep,iterations=2);ar[:,:,3]=np.where(mask & (ar[:,:,3]>40),ar[:,:,3],0);clean=Image.fromarray(ar);clean=clean.crop(clean.getbbox());clean.save(out/(name+'.png'));print(name,clean.size)
 t=clean.copy();t.thumbnail((280,280));board.paste(t,(i*300+(300-t.width)//2,40+(280-t.height)//2),t);ImageDraw.Draw(board).text((i*300+10,10),name,fill='white')
board.save('/downloads/menu189-crops.png')
