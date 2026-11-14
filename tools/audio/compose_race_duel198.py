"""Original Ganjo arrangements, deterministic notes and circular release tails. CC0 source samples."""
from pathlib import Path
import json, urllib.request, urllib.parse, re, hashlib
import numpy as np
from scipy.io import wavfile
from scipy.signal import resample_poly
ROOT=Path(__file__).resolve().parents[2]; SR=48000
SOURCE='https://raw.githubusercontent.com/sfzinstruments/ganjo/ccff5cd5cd3b513873a48994c07724d9d3c39e1c/'
CACHE=Path('/tmp/ganjo198-samples');CACHE.mkdir(exist_ok=True)
names=['E3','F3','F#3','G3','A3','B3','C#4','D4','E4','F4','F#4','G4','A4','B4','C#5','D#5','G5']
semitones={'C':0,'D':2,'E':4,'F':5,'G':7,'A':9,'B':11}
samples={};sources=[]
for name in names:
 path='Common/Banjo_Common - '+name+'.wav';local=CACHE/(name.replace('#','sharp')+'.wav')
 if not local.exists():local.write_bytes(urllib.request.urlopen(SOURCE+urllib.parse.quote(path)).read())
 rate,x=wavfile.read(local);x=x.astype(np.float64)/(2**(x.dtype.itemsize*8-1))
 if x.ndim>1:x=x.mean(axis=1)
 if rate!=SR:x=resample_poly(x,SR,rate)
 x=x/(max(np.max(np.abs(x)),1e-6));m=12*(int(name[-1])+1)+semitones[name[0]]+('#' in name)
 samples[m]=x;sources.append({'note':name,'url':SOURCE+urllib.parse.quote(path),'sha256':hashlib.sha256(local.read_bytes()).hexdigest()})
def sound(midi,duration):
 base=min(samples,key=lambda k:abs(k-midi));x=samples[base]
 ratio=2**((midi-base)/12);n=min(int(len(x)/ratio),int(duration*SR));x=np.interp(np.arange(n)*ratio,np.arange(len(x)),x)
 x*=np.minimum(1,np.arange(n)/(SR*.003));x*=np.minimum(1,(n-1-np.arange(n))/(SR*.045))
 return x
metrics={}
for title,bpm,chords in [('race',156,[(55,59,62),(48,52,55),(52,55,59),(50,54,57)]),('duel',132,[(50,53,57),(46,50,53),(48,52,55),(45,49,52)])]:
 beat=60/bpm;N=round(16*4*beat*SR);mix=np.zeros((N,2));events=[]
 def note(t,midi,gain,length,pan):
  x=sound(midi,length)*gain;at=round(t*beat*SR)%N
  inds=(at+np.arange(len(x)))%N
  mix[inds,0]+=x*np.sqrt((1-pan)/2);mix[inds,1]+=x*np.sqrt((1+pan)/2);events.append([round(t,3),midi,round(gain,3)])
 for bar in range(16):
  chord=chords[(bar//2)%4];root=chord[0]
  # Alternating low thumb and bright three-finger rolls; same instrument only.
  for b in range(4):note(bar*4+b,root if b%2==0 else root+7,.27,.6,-.12)
  roll=[0,1,2,1,0,2,1,2] if title=='race' else [0,2,1,2,0,1,2,1]
  for k,i in enumerate(roll):
   pitch=chord[i]+12
   if bar%4==3 and k>=6:pitch+=(-2 if title=='duel' else 2)
   if title=='race' and bar in [7,15] and k==7:pitch+=1 # G# -> A, D chord turnaround only
   note(bar*4+k*.5,pitch,.34 if k%2==0 else .24,.48,.2)
  melody=([12,16,19,21,19,16,14,12] if title=='race' else [12,15,19,17,15,14,12,11])
  offset=melody[bar%8]
  if title=='race' and bar in [5,13]:offset=15 # G# -> G over E minor, six notes total
  for k in ([.25,1.75,2.5] if title=='race' else [0,1.5,3.]):note(bar*4+k,root+offset,.36,.7,-.2)
 # Gentle room taps, circular so the tail carries across the loop.
 dry=mix.copy()
 for delay,gain in [(.07,.12),(.13,.07)]:mix+=np.roll(dry,int(delay*SR),axis=0)*gain
 mix-=mix.mean(axis=0);peak=np.max(np.abs(mix));mix*=10**(-2.5/20)/peak
 # Equal endpoint and short seam ramp to avoid a click on each loop.
 seam=240
 target=(mix[0]+mix[-1])/2
 mix[:seam]=np.linspace(target,mix[seam],seam)
 mix[-seam:]=np.linspace(mix[-seam],target,seam)
 pcm=np.round(np.clip(mix,-1,1)*32767).astype(np.int16)
 out=ROOT/'audio/music'/f'{title}198.wav';wavfile.write(out,SR,pcm)
 metrics[title]={'bpm':bpm,'bars':16,'duration':N/SR,'frames':N,'sample_rate':SR,'peak_dbfs':float(20*np.log10(np.max(np.abs(pcm.astype(float)))/32768)),'rms_dbfs':float(20*np.log10(np.sqrt(np.mean((pcm.astype(float)/32768)**2)))),'boundary_delta':int(np.max(np.abs(pcm[0].astype(int)-pcm[-1].astype(int)))),'clipped_samples':int((np.abs(pcm.astype(int))>=32767).sum()),'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'notes':len(events)}
(ROOT/'audio/music/metrics198.json').write_text(json.dumps({'tracks':metrics,'sample_sources':sources},indent=2))
print(json.dumps(metrics,indent=2))
