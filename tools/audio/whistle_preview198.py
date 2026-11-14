"""Separate no-cost synthesized whistle preview. Does not overwrite game music."""
from pathlib import Path
import json, hashlib
import numpy as np
from scipy.io import wavfile
ROOT=Path(__file__).resolve().parents[2]
sr,pcm=wavfile.read(ROOT/'audio/music/race198.wav')
base=pcm.astype(np.float64)/32768;N=len(base);beat=60/156
whistle=np.zeros((N,2));rng=np.random.default_rng(198);events=[]
# Two-bar phrases with two-bar rests, repeated once. G major throughout.
phrases={0:[(0,79,1.25),(1.5,83,.75),(2.5,81,.5),(3.25,79,.6)],1:[(0,81,.75),(1,79,1.5),(3,74,.65)],4:[(0,79,1.25),(1.5,83,.75),(2.5,86,1.1)],5:[(0,83,.8),(1.25,81,.75),(2.5,79,1.1)],8:[(0,79,1.25),(1.5,83,.75),(2.5,81,.5),(3.25,79,.6)],9:[(0,81,.75),(1,79,1.5),(3,74,.65)],12:[(0,79,1.25),(1.5,83,.75),(2.5,86,1.1)],13:[(0,83,.8),(1.25,81,.75),(2.5,79,1.1)]}
for bar,phrase in phrases.items():
 for start,midi,dur in phrase:
  n=round(dur*beat*sr);t=np.arange(n)/sr;freq=440*2**((midi-69)/12)
  # Soft tongued onset, slight upward scoop and restrained late vibrato.
  vibrato=.0025*np.sin(2*np.pi*5.3*t)*np.minimum(t/.15,1)
  scoop=-.006*np.exp(-t/.025)
  phase=2*np.pi*np.cumsum(freq*(1+vibrato+scoop))/sr
  env=np.minimum(t/.035,1)*np.minimum((t[-1]-t)/.065,1)
  breath=rng.normal(0,1,n);breath=np.convolve(breath,np.ones(5)/5,mode='same')
  x=(np.sin(phase)+.035*np.sin(2*phase)+.012*breath)*env*.115
  at=round((bar*4+start)*beat*sr);idx=(at+np.arange(n))%N
  whistle[idx,0]+=x*.72;whistle[idx,1]+=x*.69
  events.append({'beat':bar*4+start,'midi':midi,'length_beats':dur})
# A quiet delayed reflection; original corrected Ganjo samples stay untouched.
whistle+=np.roll(whistle,round(.09*sr),axis=0)*.1
mix=base+whistle;peak=np.max(np.abs(mix));gain=min(1,10**(-1/20)/peak);mix*=gain
out=Path('/downloads/Rancho-Carreras-198-Silbido-Prueba.wav');wavfile.write(out,sr,np.round(mix*32767).astype(np.int16))
Path('/downloads/Silbido-198-Metricas.json').write_text(json.dumps({'sample_rate':sr,'duration':N/sr,'whistle_notes':len(events),'synth':'sinusoidal with small second harmonic, breath, onset scoop and 5.3 Hz vibrato','key':'G major','bpm':156,'original_track_unchanged':True,'mix_gain':gain,'peak_dbfs':float(20*np.log10(np.max(np.abs(mix)))),'clipped_samples':int(np.sum(np.abs(mix)>=1)),'sha256':hashlib.sha256(out.read_bytes()).hexdigest(),'events':events},indent=2))
print(out);print('notes',len(events),'peak',peak,'mix_gain',gain)
