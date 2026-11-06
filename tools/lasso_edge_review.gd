extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var gs:Node=root.get_node("GameState");gs.selected_level=5
 var save:Node=root.get_node("SaveData");save.dual_lasso_intro_shown=true
 var level:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level);await physics_frame
 for b in level._active_bulls:b.set_physics_process(false);b.global_position=Vector2(1500,1500)
 level.player.set_physics_process(false);level.player.global_position=Vector2.ZERO
 for offset in [Vector2(180,0),Vector2(-180,-80),Vector2(0,180),Vector2(8,5)]:
  var rope:Node=load("res://src/Presentation/lasso_rope.gd").new();rope.rider=level.player;rope.start=Vector2.ZERO;rope.landing=offset;rope.progress=1.0;root.add_child(rope)
 for i in range(10):await process_frame
 root.get_texture().get_image().save_png("/downloads/lazo-union-borde.png");quit()
