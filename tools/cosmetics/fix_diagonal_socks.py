"""Restore diagonal-up cream socks; tail ownership follows its source layer and bob.
Run after build_horse_masks.py. Does not change the source animation.
"""
from pathlib import Path
from PIL import Image,ImageDraw
import numpy as np,json
R=Path(__file__).resolve().parents[2]
guide=json.loads((R/'tools/gallop_source/support/corrected-guide.json').read_text())
source=Image.open(R/'tools/gallop_source/original/diag_up.png').convert('RGBA').resize((768,768),Image.Resampling.LANCZOS)
outline=Image.new('L',source.size)
ImageDraw.Draw(outline).polygon([(x*8,y*8) for x,y in [(18,54),(34,51),(40,59),(35,72),(33,81),(20,81),(18,76)]],fill=255)
tail=Image.fromarray(np.minimum(np.array(source)[:,:,3],np.array(outline)))
for n in range(12):
 p=R/f'art/horse_masks/walk_diag_up/frame_{n:02}.png'
 mask=np.array(Image.open(p));a=np.array(Image.open(R/f'art/player/walk_diag_up/frame_{n:02}.png'))
 dy=(guide[n][0][0][1]-48)*.85
 if n==10:dy=(41-48)*.85
 shifted=Image.new('L',source.size);shifted.paste(tail,(0,round((dy-3)*8)))
 ta=np.array(shifted.resize((96,96),Image.Resampling.LANCZOS))
 rgb=a[:,:,:3].astype(float);mx=rgb.max(2);mn=rgb.min(2);yy,xx=np.mgrid[:96,:96]
 mask[:,:,1][yy>44]=0
 cream=(mx-mn<115)&(rgb[:,:,0]>130)&(rgb[:,:,1]>110)&(rgb[:,:,2]>90)&(yy>64)
 mask[cream]=0
 hair=(ta>125)&(mx>100)&((mx-mn)<150)&(rgb[:,:,0]>rgb[:,:,2])&(yy>44)
 mask[:,:,1][hair]=255;mask[:,:,0][hair]=0
 Image.fromarray(mask).save(p)
