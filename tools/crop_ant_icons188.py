from PIL import Image,ImageDraw
import numpy as np
from scipy.ndimage import label,find_objects,binary_dilation
from pathlib import Path
import argparse
p=argparse.ArgumentParser();p.add_argument('source');p.add_argument('output');p.add_argument('--preview',default='/downloads/icons188-crops.png');args=p.parse_args()
im=Image.open(args.source);out=Path(args.output);out.mkdir(parents=True,exist_ok=True)
board=Image.new('RGB',(1200,900),'#17333d')
for i in range(12):
 box=(round(i%4*im.width/4),round(i//4*im.height/3),round((i%4+1)*im.width/4),round((i//4+1)*im.height/3));ar=np.array(im.crop(box));labs,n=label(ar[:,:,3]>150);cts=np.bincount(labs.ravel());keep=np.zeros(labs.shape,bool)
 for j,sl in enumerate(find_objects(labs),1):
  if cts[j]>1800:keep|=labs==j
 mask=binary_dilation(keep,iterations=2);ar[:,:,3]=np.where(mask & (ar[:,:,3]>40),ar[:,:,3],0);clean=Image.fromarray(ar);clean=clean.crop(clean.getbbox());clean.save(out/f'{i+1:02d}.png')
 t=clean.copy();t.thumbnail((276,260));pos=(i%4*300+(300-t.width)//2,i//4*300+32+(260-t.height)//2);board.paste(t,pos,t);ImageDraw.Draw(board).text((i%4*300+10,i//4*300+9),str(i+1),fill='white');print(i+1,box,clean.size)
board.save(args.preview)
