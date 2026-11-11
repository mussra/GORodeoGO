from PIL import Image
import numpy as np
from scipy.ndimage import binary_propagation, binary_dilation
from pathlib import Path
im=Image.open('art/npc/source/farmer-ant-20261111.jpg').convert('RGB'); a=np.array(im).astype(float);m=a.max(2)
seed=np.zeros(m.shape,bool);seed[0,:]=seed[-1,:]=True;seed[:,0]=seed[:,-1]=True
bg=binary_propagation(seed,mask=m<38)
edge=binary_dilation(bg,iterations=2)
alpha=np.ones(m.shape);alpha[bg]=np.clip((m[bg]-7)/31,0,1);alpha[edge & (m<12)]=0
# Source antialiasing is composited on black. Unpremultiply only the outside transition.
a[edge]=np.clip(a[edge]/np.maximum(alpha[edge,None],.05),0,255)
out=Image.fromarray(np.dstack((a,alpha*255)).astype('uint8'),'RGBA');Path('art/npc').mkdir(exist_ok=True);out.save('art/npc/farmer.png')
# Edge inspection over bright game-like surface.
bgim=Image.new('RGBA',out.size,'#bad694');bgim.alpha_composite(out);bgim.convert('RGB').save('/downloads/farmer-cutout-review.jpg')
print(im.size)
