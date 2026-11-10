"""Static regression for the adult HD mask, source art and renderer scope."""
import subprocess
from pathlib import Path
from PIL import Image,ImageChops
root=Path(__file__).resolve().parents[3]
def previous(path):
 import io
 return Image.open(io.BytesIO(subprocess.check_output(['git','show','41f3857:'+path],cwd=root))).convert('RGB')
p='art/portraits/adult_hd_mask.png';old=previous(p);new=Image.open(root/p).convert('RGB')
assert new.size==old.size
assert ImageChops.difference(old.getchannel('R'),new.getchannel('R')).getbbox() is None,'coat changed'
assert ImageChops.difference(old.getchannel('B'),new.getchannel('B')).getbbox() is None,'hat changed'
for p in ['art/portraits/adult_hd.png','art/portraits/adult_eyes.png','art/portraits/adult_light_legs_mask.png']:
 assert subprocess.check_output(['git','show','41f3857:'+p],cwd=root)==(root/p).read_bytes(),p+' changed'
print('Adult HD: coat and hat channels identical; source/rider/equipment, eyes and light-legs unchanged')
