"""Crop Ant's transparent three-clock sheet. Keep the original source and resize the UI copies.
No repainting, alpha replacement, recolouring or regenerated art.
"""
from pathlib import Path
from PIL import Image
root=Path(__file__).resolve().parents[2]
im=Image.open(root/'art/ui/skills/source/ant-skill-clocks-20261111.png').convert('RGBA')
assert im.size==(2172,724)
for i,name in enumerate(['stamina','dodge','jump']):
 cell=im.crop((i*724,0,(i+1)*724,724))
 bounds=cell.getchannel('A').getbbox()
 print(name,bounds)
 # Equal original 724px cells retain their existing transparent alpha.
 # 256px UI copies avoid loading 724px textures for a 76px clock.
 cell.resize((256,256),Image.Resampling.LANCZOS).save(root/f'art/ui/skills/{name}.png')
