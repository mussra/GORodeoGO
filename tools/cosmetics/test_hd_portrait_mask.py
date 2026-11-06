"""Material ownership checks for the HD portrait, not an Android visual test."""
from pathlib import Path
from PIL import Image
ROOT=Path(__file__).resolve().parents[2]
im=Image.open(ROOT/'art/portraits/adult_hd_mask.png').convert('RGB')
def pixel(x,y):return im.getpixel((round((x-240)*im.width/800),round(y*im.height/840)))
checks=0
for x,y in [(713,111),(880,166),(890,165),(985,184),(810,360),(570,704),(600,787),(870,720),(740,720)]:
 assert max(pixel(x,y))<10,(x,y,pixel(x,y));checks+=1
for x,y in [(810,371),(620,586),(860,240),(870,270)]:
 assert pixel(x,y)[0]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(640,80),(740,100),(600,120)]:
 assert pixel(x,y)[2]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(832,190),(840,198),(829,214),(889,211),(882,163),(901,165)]:
 assert max(pixel(x,y))<10,(x,y,pixel(x,y));checks+=1
for x,y in [(854,196),(884,182),(888,238),(902,303)]:
 assert pixel(x,y)[0]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(1000,183),(994,202)]:
 assert pixel(x,y)[1]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(914,150),(930,162),(957,171)]:
 assert pixel(x,y)[1]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(972,195),(991,223),(892,344)]:
 assert pixel(x,y)[0]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(983,210),(966,200)]:
 assert max(pixel(x,y))<10,(x,y,pixel(x,y));checks+=1
for x,y in [(766,139),(760,149)]:
 assert pixel(x,y)[1]<10 and pixel(x,y)[2]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(1009,189),(940,82),(745,244)]:
 assert pixel(x,y)[1]>240,(x,y,pixel(x,y));checks+=1
assert pixel(887,344)[0]>240,pixel(887,344);checks+=1
for x,y in [(924,180),(928,190),(932,200),(936,210),(940,220),(944,230)]:
 assert pixel(x,y)[0]>240,(x,y,pixel(x,y));checks+=1
for x,y in [(951,200),(947,190)]:
 assert max(pixel(x,y))<10,(x,y,pixel(x,y));checks+=1
for x,y in [(908,145),(923,156)]:
 assert pixel(x,y)[1]>240,(x,y,pixel(x,y));checks+=1
print(f'HD_PORTRAIT_MATERIAL_OWNERSHIP_PASS {checks} checks')
