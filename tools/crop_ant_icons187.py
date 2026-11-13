from PIL import Image,ImageDraw
import numpy as np
from scipy.ndimage import label,find_objects,binary_dilation
from pathlib import Path
import argparse
parser=argparse.ArgumentParser();parser.add_argument('source');parser.add_argument('output');parser.add_argument('--preview',default='/downloads/icons187-crops.png');args=parser.parse_args()
im=Image.open(args.source);out=Path(args.output);out.mkdir(parents=True,exist_ok=True)
xb=[0,163,318,465,615,765,922,1073,1182];yb=[0,170,330,480,620,770,918,1058,1180,1330]
board=Image.new('RGB',(1200,1350),'#17333d')
for i in range(72):
 cell=im.crop((xb[i%8],yb[i//8],xb[i%8+1],yb[i//8+1]));ar=np.array(cell);labs,n=label(ar[:,:,3]>140);cts=np.bincount(labs.ravel());keep=np.zeros(labs.shape,bool)
 for j,sl in enumerate(find_objects(labs),1):
  if cts[j]>350:keep|=labs==j
 mask=binary_dilation(keep,iterations=2);ar[:,:,3]=np.where(mask & (ar[:,:,3]>40),ar[:,:,3],0);clean=Image.fromarray(ar);clean=clean.crop(clean.getbbox());clean.save(out/f'{i+1:02d}.png')
 thumb=clean.copy();thumb.thumbnail((136,124));at=(i%8*150+(150-thumb.width)//2,i//8*150+23+(124-thumb.height)//2);board.paste(thumb,at,thumb);ImageDraw.Draw(board).text((i%8*150+4,i//8*150+3),str(i+1),fill='white')
board.save(args.preview)
