extends GutTest
func test_shared_selector_uses_same_art_but_distinct_cadence_without_dedicated_gallop()->void:
 var host=Node2D.new();add_child_autofree(host);var placeholder=Polygon2D.new();host.add_child(placeholder)
 var frames=SpriteFrames.new();PixelLabTrial.apply(frames,"rider","walk_side")
 var swap=SpriteSwap.from_frames(host,placeholder,frames)
 assert_eq(RiderGaitVisual.apply(swap,Vector2(117,0),260,WorldGait.PASO,.1),"walk_side")
 var slow:float=swap._sprite.speed_scale
 assert_eq(RiderGaitVisual.apply(swap,Vector2(260,0),260,WorldGait.GALOPE,.1),"walk_side")
 assert_gt(swap._sprite.speed_scale,slow)
 assert_false(frames.has_animation("gallop_side"),"No se inventa un ciclo de galope")
 assert_eq(RiderGaitVisual.apply(swap,Vector2.ZERO,260,WorldGait.PASO,.1),"idle")
 assert_eq(swap._sprite.position.y,0.0)
func test_future_dedicated_gallop_uses_each_available_direction_not_side_only()->void:
 var host=Node2D.new();add_child_autofree(host);var placeholder=Polygon2D.new();host.add_child(placeholder)
 var frames=SpriteFrames.new();var tex=load("res://art/experimental/pixellab/rider/down/frame_00.png")
 for name in ["walk_down","gallop_down"]:frames.add_animation(name);frames.add_frame(name,tex)
 var swap=SpriteSwap.from_frames(host,placeholder,frames)
 assert_eq(RiderGaitVisual.apply(swap,Vector2(0,260),260,WorldGait.GALOPE,.1),"gallop_down")
 assert_eq(RiderGaitVisual.apply(swap,Vector2(0,117),260,WorldGait.PASO,.1),"walk_down")
 assert_eq(RiderGaitVisual.from_speed(260,260),WorldGait.GALOPE)
 assert_eq(RiderGaitVisual.from_speed(100,260),WorldGait.PASO)
