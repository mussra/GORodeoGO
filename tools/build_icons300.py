from pathlib import Path
from PIL import Image
import numpy as np
from scipy.ndimage import label,binary_dilation
ROOT=Path(__file__).resolve().parents[1]
d=ROOT/'art/ui/icons300'
names=['hat','back','horse','adorn','finish','buy','equip','saddle','reins','stirrups','shoes','spurs','blanket','hat_gala','whip','long']
im=Image.open(d/'source/original.png').convert('RGBA');arr=np.asarray(im)
labels,count=label(arr[:,:,3]>10)
areas=np.bincount(labels.ravel());groups={i:[] for i in range(16)}
# The generator did not respect equal cell bounds. Assign whole connected shapes
# by their centroid, never cut the hat brims at a nominal grid line.
for component in range(1,count+1):
 if areas[component]<200:continue
 yy,xx=np.where(labels==component)
 cell=int(yy.mean()//(im.height/4))*4+int(xx.mean()//(im.width/4))
 groups[cell].append(component)
for n,name in enumerate(names):
 mask=binary_dilation(np.isin(labels,groups[n]),iterations=3)
 alpha=arr[:,:,3].copy();alpha[~mask]=0
 piece=im.copy();piece.putalpha(Image.fromarray(alpha));piece=piece.crop(piece.getchannel('A').getbbox())
 piece.thumbnail((232,232),Image.Resampling.LANCZOS)
 out=Image.new('RGBA',(256,256));out.alpha_composite(piece,((256-piece.width)//2,(256-piece.height)//2));out.save(d/(name+'.png'))
