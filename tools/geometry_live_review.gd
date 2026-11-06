extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");save.begin_trial_session();var gs:Node=root.get_node("GameState")
 var out:=Image.create(1280,1440,false,Image.FORMAT_RGBA8)
 for n in range(11,15):
  gs.selected_level=n
  var level:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
  for i in range(8):await physics_frame
  await RenderingServer.frame_post_draw
  var shot:=root.get_texture().get_image();shot.convert(Image.FORMAT_RGBA8);shot.resize(640,720,Image.INTERPOLATE_LANCZOS);out.blit_rect(shot,Rect2i(0,0,640,720),Vector2i((n-11)%2*640,(n-11)/2*720))
  for j in range(level._pens_data.size()):
   level.player.global_position=level._pens_data[j]["door_position"]
   await create_timer(1.5).timeout
   assert(level._pen_released[j],"physical latch opens level%d pen%d"%[n,j])
  print("GEOMETRY_OPEN_LEVEL_",n," PASS")
  level.queue_free();await process_frame
 out.save_png("/downloads/geometry11-14-fixed.png")
 save.end_trial_session();quit()
