"""Regression: recover approved source pixels, keep all masks aligned, never redraw hooves."""
from pathlib import Path
from PIL import Image, ImageFilter
ROOT = Path(__file__).resolve().parents[2]
source = Image.open(ROOT/'docs/concepts/approved-adult-hd/source.png').convert('RGBA')
w, h = source.size
alpha = source.getchannel('A').filter(ImageFilter.MinFilter(3)).filter(ImageFilter.GaussianBlur(.45))
source.putalpha(alpha)
expected = source.crop((round(240*w/1313), 0, round(1040*w/1313), h+12))
portrait = Image.open(ROOT/'art/portraits/adult_hd.png').convert('RGBA')
assert portrait.size == (936, 1036)
assert portrait.tobytes() == expected.tobytes(), 'Portrait must be exact approved pixels, not generated art'
assert portrait.getchannel('A').getbbox()[3] <= portrait.height-12
paths = ['art/lineage_masks/portrait/adult.png', 'art/portraits/adult_light_legs_mask.png',
         'art/portraits/adult_hd_mask.png', 'art/portraits/adult_lower_legs_mask.png',
         'art/portraits/adult_eyes.png', 'art/hat_masks_v10/hat-portrait.png',
         'art/adorn169/portrait.png', 'art/adorn153/portrait.png']
for path in paths:
    mask = Image.open(ROOT/path)
    assert mask.size == portrait.size, (path, mask.size)
    assert mask.crop((0, 983, 936, 1036)).getbbox() is None, path
print('PORTRAIT_324_PASS: exact original pixels, complete hooves, 12px margin, 8 aligned masks')
