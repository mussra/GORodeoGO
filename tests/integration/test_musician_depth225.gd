extends GutTest
func test_musician_uses_same_depth_layer_as_rider_and_feet_pivot():
 var host:=Node2D.new();host.y_sort_enabled=true;add_child(host)
 var musician:=GanjoMusician205.new();host.add_child(musician)
 var player=load("res://src/Presentation/world_player.gd").new();host.add_child(player);await wait_physics_frames(2)
 assert_eq(musician.z_index,player.z_index);assert_eq(musician.z_index,0)
 var sprite:AnimatedSprite2D=musician.get_node("Artist");var texture:Texture2D=sprite.sprite_frames.get_frame_texture("play",0)
 var bounds:Rect2=NpcScale214.visible_bounds(texture)
 assert_almost_eq((bounds.end.y-float(texture.get_height())*.5+sprite.offset.y)*sprite.scale.y,0.,.1)
 host.free();await wait_physics_frames(2)
