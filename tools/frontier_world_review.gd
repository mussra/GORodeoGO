extends SceneTree
## Frontier world preview: ranch, taming, discovery map, and gait frames for a GIF.
func _initialize()->void:call_deferred("run")
func _snap(path:String)->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func run()->void:
 root.size=Vector2i(1599,719)
 var SD:Node=root.get_node("SaveData")
 SD.save_path="user://frontier-review-save.dat"
 TranslationServer.set_locale("es")
 SD.world_seed=0;SD.world_discovered.clear();SD.world_tamed.clear();SD.world_missions.clear()
 var c=SD.horse_collection
 c.seed_trial()
 DirAccess.make_dir_recursive_absolute("/tmp/frontier")
 var world:Node2D=load("res://src/Presentation/frontier_world.tscn").instantiate()
 root.add_child(world)
 await create_timer(.4).timeout
 await _snap("/downloads/frontier-ranch.png")
 # find the closest herd chunk and approach it calmly
 var herd_pos:=Vector2.ZERO
 var found:=false
 for radius in range(1,5):
  for cx in range(-radius,radius+1):
   for cy in range(-radius,radius+1):
    var chunk:Dictionary=WorldMap.generate(SD.world_seed,cx,cy)
    if not chunk.get("herd",{}).is_empty():
     herd_pos=chunk.herd.pos;found=true;break
   if found:break
  if found:break
 if found:
  world.player.position=herd_pos+Vector2(120,40)
  await create_timer(.3).timeout
  # stand still and calm: progress builds
  await create_timer(2.8).timeout
  await _snap("/downloads/frontier-taming.png")
 # discovery map
 world._toggle_map()
 await create_timer(.25).timeout
 await _snap("/downloads/frontier-map.png")
 world._toggle_map()
 # job board: stand at the sign and open it
 world.player.position=Vector2(145,60)
 await create_timer(.2).timeout
 world._open_board()
 await create_timer(.25).timeout
 await _snap("/downloads/frontier-board.png")
 if is_instance_valid(world._board_panel):world._board_panel.queue_free()
 # gait frames: paso, trote, galope
 var strengths:Array=[0.2,0.6,1.0]
 var names:Array=["paso","trote","galope"]
 for g in range(3):
  Input.action_press("move_right",strengths[g])
  await create_timer(.45).timeout
  for i in range(6):
   await create_timer(.12).timeout
   await _snap("/tmp/frontier/gait_%s_%d.png"%[names[g],i])
  Input.action_release("move_right")
  await create_timer(.3).timeout
 print("frontier review done; herd found: ",found)
 quit()
