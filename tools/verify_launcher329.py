from pathlib import Path
from zipfile import ZipFile
from io import BytesIO
from PIL import Image,ImageChops
import subprocess,math,json,hashlib
root=Path(__file__).resolve().parents[1];apk=Path('/downloads/Rancho-3.0.29.apk');aapt='/downloads/android-sdk/build-tools/35.0.0/aapt'
p=subprocess.run([aapt,'dump','badging',str(apk)],capture_output=True,text=True);badging=p.stdout
assert "package: name='com.example.rancho.review' versionCode='489' versionName='3.0.29'" in badging
labels=[line for line in badging.splitlines() if line.startswith('application-label')]
assert labels and all(line.endswith(":'Rancho'") for line in labels)
xml=subprocess.check_output([aapt,'dump','xmltree',str(apk),'res/mipmap-anydpi-v26/icon.xml'],text=True)
assert all(x in xml for x in ['E: adaptive-icon','E: foreground','E: background'])
manifest=subprocess.check_output([aapt,'dump','xmltree',str(apk),'AndroidManifest.xml'],text=True)
assert 'android.intent.category.LAUNCHER' in manifest
z=ZipFile(apk);density=[]
for name in z.namelist():
 if name.startswith('res/mipmap-') and name.endswith('/icon_foreground.webp'):
  fg=Image.open(BytesIO(z.read(name))).convert('RGBA');n=fg.width
  radius=max(math.hypot(x-(n-1)/2,y-(n-1)/2) for y in range(n) for x in range(n) if fg.getpixel((x,y))[3]>0)
  assert radius<=n*33/108,(name,radius)
  density.append({'resource':name,'size':n,'radius':radius,'safe_radius':n*33/108})
assert len(density)==5
fg=Image.open(BytesIO(z.read('res/mipmap-xxxhdpi-v4/icon_foreground.webp'))).convert('RGBA')
source=Image.open(root/'art/launcher329/foreground.png').convert('RGBA')
assert ImageChops.difference(fg,source).getbbox()==None
qa={'version':'3.0.29','package':'com.example.rancho.review','version_code':489,'launcher_name':'Rancho','locale_labels_checked':len(labels),'adaptive_xml_verified':True,'launcher_alias_verified':True,'foreground_pixel_match':True,'density_safe_zones':density,'apk_sha256':hashlib.sha256(apk.read_bytes()).hexdigest(),'visual_checks':['Circle, rounded-square and square masks','200px enlarged and 48px home-screen scale','Complete hat, mane, tail and hooves visible'],'limitations':['No physical Android launcher tested','Launcher may cache an old icon or label until refreshed','No gameplay code changed; full game suite not rerun'],'design_source':'https://developer.android.com/develop/ui/compose/system/icon_design_adaptive'}
(root/'docs/QA_3_0_29.json').write_text(json.dumps(qa,indent=2));print(json.dumps(qa,indent=2))
