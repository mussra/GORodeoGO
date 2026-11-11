"""Bake only Ant's three grass crops into a seamless, light, irregular field."""
from pathlib import Path
import numpy as np
from PIL import Image
from scipy.ndimage import gaussian_filter
root=Path(__file__).resolve().parents[2];N=1024;S=176
rng=np.random.default_rng(910752026)
src=Image.open(root/'art/world/modular87/source/ant-road-grass-sheet-20261111.png').convert('RGB')
boxes=[(264,84,663,482),(693,84,1083,482),(1112,84,1511,482)]
patches=[np.asarray(src.crop(b).resize((S,S),Image.Resampling.LANCZOS),dtype=float) for b in boxes]
acc=np.zeros((N,N,3));weight=np.zeros((N,N))
y,x=np.mgrid[:S,:S];w=np.maximum(.001,np.sin(np.pi*(x+.5)/S)**2*np.sin(np.pi*(y+.5)/S)**2)
# Strong position jitter, rotations and flips. Normalized weights avoid dark alpha seams.
for cy in range(-1,14):
 for cx in range(-1,14):
  px=int(cx*N/12+rng.uniform(-45,45))%N;py=int(cy*N/12+rng.uniform(-45,45))%N
  a=np.rot90(patches[int(rng.integers(3))],int(rng.integers(4)))
  if rng.random()<.5:a=a[:,::-1]
  yy=(np.arange(S)+py)%N;xx=(np.arange(S)+px)%N
  acc[np.ix_(yy,xx)]+=a*w[:,:,None];weight[np.ix_(yy,xx)]+=w
assert weight.min()>0
rgb=acc/weight[:,:,None]
# Remove broad source shading, keep the supplied leaf detail on a light field.
low=gaussian_filter(rgb,(30,30,0),mode='wrap')
target=np.array([139,181,37]);rgb=target+(rgb-low)*.83
# Sparse irregular small darker islands, never entire rows.
shade=np.zeros((N,N));Y,X=np.mgrid[:N,:N]
for i in range(32):
 px,py=rng.uniform(0,N,2);rx,ry=rng.uniform(10,27,2)
 dx=np.minimum(abs(X-px),N-abs(X-px));dy=np.minimum(abs(Y-py),N-abs(Y-py))
 shade+=np.exp(-((dx/rx)**2+(dy/ry)**2))*rng.uniform(.025,.065)
rgb*=1-np.minimum(shade,.09)[:,:,None]
out=root/'art/world/derived88/grass-cache91.png';Image.fromarray(np.uint8(np.clip(rgb,0,255))).save(out)
lum=rgb.mean(2);print('row mean range',np.ptp(lum.mean(1)),'column mean range',np.ptp(lum.mean(0)),'min coverage',weight.min())
