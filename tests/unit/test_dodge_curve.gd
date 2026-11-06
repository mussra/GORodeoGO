extends GutTest
func test_short_jitter_is_not_a_regate()->void:
 assert_eq(DodgeCurve.smooth(PackedVector2Array([Vector2.ZERO,Vector2(1,1),Vector2(2,1)]),260).size(),0)
func test_corner_smoothed_preserves_end_and_length_limit()->void:
 var out:=DodgeCurve.smooth(PackedVector2Array([Vector2.ZERO,Vector2(100,0),Vector2(100,100)]),260);assert_eq(out[0],Vector2.ZERO);assert_eq(out[-1],Vector2(100,100))
 var largest:float=0;var length:float=0
 for i in range(1,out.size()):
  length+=out[i].distance_to(out[i-1])
  if i>1:
   var a:Vector2=out[i-1]-out[i-2];var b:Vector2=out[i]-out[i-1]
   if a.length()>.01 and b.length()>.01:largest=maxf(largest,absf(a.angle_to(b)))
 assert_lt(largest,PI/3);assert_lte(length,200.01)
func test_overlong_trace_never_exceeds_authorized_distance()->void:
 var out:=DodgeCurve.smooth(PackedVector2Array([Vector2.ZERO,Vector2(500,0),Vector2(500,500)]),260);var length:float=0
 for i in range(1,out.size()):length+=out[i].distance_to(out[i-1])
 assert_lte(length,260.01);assert_eq(out[-1],Vector2(260,0))
