"""Prepare the world ribbon and feathered grass copies. Originals unchanged."""
from PIL import Image
from pathlib import Path
import numpy as np
root=Path(__file__).resolve().parents[2];out=root/'art/world/derived88'
Image.open(out/'straight.png').crop((0,48,192,144)).save(out/'ribbon.png')
source=Image.open(root/'art/world/modular87/source/ant-road-grass-sheet-20261111.png').convert('RGB')
for i,b in enumerate([(264,84,663,482),(693,84,1083,482),(1112,84,1511,482)]):
 im=source.crop(b).resize((192,192),Image.Resampling.LANCZOS).convert('RGBA');a=np.array(im)
 y,x=np.mgrid[:192,:192];edge=np.minimum.reduce([x,y,191-x,191-y]);a[:,:,3]=np.uint8(np.clip(edge/32,0,1)*255)
 Image.fromarray(a).save(out/f'grass-blend-{i}.png')
