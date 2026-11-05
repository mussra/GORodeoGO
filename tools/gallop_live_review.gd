extends SceneTree
var level:Node
var frame:=0
func _initialize()->void:call_deferred("setup")
func setup()->void:
 root.get_node("GameState").selected_level=3
 root.get_node("SaveData").dual_lasso_intro_shown=true
 level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
 await physics_frame
 for b in level._active_bulls:b.set_physics_process(false)
 level.player.global_position=Vector2(900,800)
 AudioServer.set_bus_mute(0,true)
func _process(_d:float)->bool:
 if level==null:return false
 frame+=1
 var dirs=[Vector2.RIGHT,Vector2(1,1).normalized(),Vector2.DOWN,Vector2(-1,1).normalized(),Vector2.LEFT,Vector2(-1,-1).normalized(),Vector2.UP,Vector2(1,-1).normalized()]
 var idx=mini((frame-1)/45,7)
 for action in ["move_right","move_left","move_up","move_down"]:Input.action_release(action)
 var v=dirs[idx]
 if v.x>0:Input.action_press("move_right")
 if v.x<0:Input.action_press("move_left")
 if v.y>0:Input.action_press("move_down")
 if v.y<0:Input.action_press("move_up")
 if frame==120:call_deferred("shot")
 if frame>=360:quit()
 return false
func shot()->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/gorodeo/gallop-live-gameplay.png")
