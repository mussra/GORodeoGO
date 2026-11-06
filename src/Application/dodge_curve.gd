class_name DodgeCurve
extends RefCounted
## Uniform sampling rejects pen jitter; corner cutting produces a bounded curve.
static func smooth(points:PackedVector2Array,limit:float)->PackedVector2Array:
 if points.size()<2:return PackedVector2Array()
 var sampled:=PackedVector2Array([Vector2.ZERO]);var origin:Vector2=points[0];var travelled:float=0.0;var last:Vector2=origin
 for i in range(1,points.size()):
  var target:Vector2=points[i];var delta:Vector2=target-last
  if delta.length()<4.0:continue
  var step:Vector2=delta.limit_length(maxf(0.0,limit-travelled))
  var count:int=maxi(1,ceili(step.length()/8.0))
  for j in range(1,count+1):sampled.append(last+step*float(j)/count-origin)
  travelled+=step.length();last+=step
  if travelled>=limit:break
 if travelled<15:return PackedVector2Array()
 # Two Chaikin passes stay inside the local convex hull and preserve endpoints.
 for pass_index in range(2):
  var curve:=PackedVector2Array([sampled[0]])
  for i in range(sampled.size()-1):
   curve.append(sampled[i].lerp(sampled[i+1],.25));curve.append(sampled[i].lerp(sampled[i+1],.75))
  curve.append(sampled[-1]);sampled=curve
 return sampled
