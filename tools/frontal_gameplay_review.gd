extends SceneTree
# Recorded game simulation at normal time, controlled directional input only.
func _initialize()->void:call_deferred("run")
func run()->void:
 root.get_node("GameState").selected_level=5
 root.get_node("SaveData").dual_lasso_intro_shown=true
 var level:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
 await physics_frame
 level.player.global_position=Vector2(-200,0)
 var layer:=CanvasLayer.new();layer.layer=100;root.add_child(layer)
 var note:=Label.new();note.text="Revision en partida - velocidad normal";note.position=Vector2(20,82);note.add_theme_font_size_override("font_size",18);layer.add_child(note)
 for lap in range(2):
  for keys in [["move_right","move_down"],["move_right","move_up"],["move_left","move_up"],["move_left","move_down"]]:
   for key in keys:Input.action_press(key)
   for i in range(81):await physics_frame
   for key in keys:Input.action_release(key)
 for i in range(30):await physics_frame
 print("FRONTAL_GAMEPLAY_DONE time_scale=",Engine.time_scale," sprite=",level.player._sprite_swap._sprite.animation)
 quit()
