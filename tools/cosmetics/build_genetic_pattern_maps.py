"""Shared deterministic maps sampled by CPU sprites and HD portrait shader."""
from PIL import Image,ImageFilter
import numpy as np
from pathlib import Path
R=Path(__file__).resolve().parents[2];n=512;y,x=np.mgrid[:n,:n];u=x/n;v=y/n
# Periodic jittered Voronoi cells: large interlocking giraffe islands, fine gaps.
rng=np.random.default_rng(239);centers=[]
for j in range(8):
 for i in range(8):centers.append(((i+.5+rng.uniform(-.27,.27))/8,(j+.5+rng.uniform(-.27,.27))/8))
dist=[]
for cx,cy in centers:
 dx=np.abs(u-cx);dy=np.abs(v-cy);dx=np.minimum(dx,1-dx);dy=np.minimum(dy,1-dy);dist.append(np.sqrt(dx*dx+dy*dy))
d=np.sort(np.stack(dist),axis=0);g=np.clip((d[1]-d[0]-.009)/.009,0,1)
Image.fromarray((g*255).astype('uint8')).save(R/'art/patterns/giraffe.png')
# Narrow organic zebra bands, changing width and direction with periodic forks.
phase=u*11+np.sin(v*2*np.pi)*.9+np.sin(v*6*np.pi+u*2*np.pi)*.25
fork=np.sin((u*2+v)*2*np.pi);phase+=.55*np.sin(v*4*np.pi)*np.clip(fork,0,1)
z=np.clip((np.sin(phase*2*np.pi)-.08)*5+.5,0,1)
Image.fromarray((z*255).astype('uint8')).save(R/'art/patterns/zebra.png')

# Cow: rounded, irregular disconnected islands rather than polygonal cells.
rng=np.random.default_rng(188);cow=np.zeros((n,n))
for i in range(13):
 cx,cy=rng.random(2);dx=np.minimum(abs(u-cx),1-abs(u-cx));dy=np.minimum(abs(v-cy),1-abs(v-cy));angle=np.arctan2(v-cy,u-cx)
 radius=rng.uniform(.065,.14)*(1+.19*np.sin(angle*3+i)+.11*np.cos(angle*5-i))
 distance=np.sqrt(dx*dx+dy*dy);cow=np.maximum(cow,np.clip((radius-distance)/.005+.5,0,1))
Image.fromarray((cow*255).astype('uint8')).save(R/'art/patterns/cow.png')
