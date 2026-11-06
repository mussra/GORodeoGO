"""Clip recoloring to the two visible iris interiors, never surrounding hide."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFilter
import numpy as np,cv2
R=Path(__file__).resolve().parents[2]
AREAS={
 'art/portraits/adult_eyes.png':[
 [(755,233),(765,231),(774,234),(780,242),(781,251),(778,259),(771,265),(762,267),(752,263),(747,256),(746,247),(749,239)],
 [(858,236),(862,237),(866,242),(867,251),(864,259),(860,263),(856,263),(855,253),(856,243)]],
 'art/foal/eyes.png':[
 [(207,113),(214,111),(220,114),(226,120),(230,130),(227,138),(221,142),(213,143),(207,139),(203,132),(202,124),(204,117)],
 [(268,96),(271,97),(273,105),(274,114),(272,118),(269,115),(267,108),(267,101)]]}
for name,areas in AREAS.items():
 p=R/name;m=Image.open(p).convert('L');clip=Image.new('L',m.size);d=ImageDraw.Draw(clip)
 for poly in areas:d.polygon(poly,fill=255)
 clip=clip.filter(ImageFilter.GaussianBlur(.4))
 clipped=np.minimum(np.array(m),np.array(clip))
 count,labels,stats,_=cv2.connectedComponentsWithStats((clipped>10).astype('uint8'))
 keep=np.zeros_like(clipped)
 for label in range(1,count):
  if stats[label,cv2.CC_STAT_AREA]>=12:keep[labels==label]=clipped[labels==label]
 Image.fromarray(keep).save(p)
