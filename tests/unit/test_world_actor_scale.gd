extends GutTest
func test_rider_scale_keeps_feet_and_not_physics_host()->void:
 var sprite:=AnimatedSprite2D.new();add_child_autofree(sprite)
 WorldActorScale.rider(sprite)
 assert_almost_eq(sprite.scale.x,1.2,.001)
 assert_almost_eq((44.0+sprite.offset.y)*sprite.scale.y,44.0,.001)
func test_wild_horse_visual_scale_preserves_collision_and_capture()->void:
 var horse=load("res://src/Presentation/wild_horse.gd").new();horse.setup({"pos":Vector2.ZERO,"traits":{"coat":10,"pattern":0,"mane":0},"appearance_scale":.96});add_child_autofree(horse)
 assert_eq(horse.scale,Vector2.ONE)
 assert_almost_eq(horse._art.scale.x,1.152,.001)
 assert_eq(horse.BODY_RADIUS,28.0)
 assert_true(horse.try_capture(Vector2(58,0)));assert_false(horse.try_capture(Vector2(59,0)))
