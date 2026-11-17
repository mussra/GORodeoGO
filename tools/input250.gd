extends Node
func _ready():call_deferred("run")
func tap(c:Control):
 var p:Vector2=get_tree().root.get_final_transform()*c.get_global_rect().get_center()
 print("TAP ",c.name," disabled=",c.disabled if c is BaseButton else false," at=",p)
 for down in [true,false]:
  var e:=InputEventScreenTouch.new();e.index=0;e.position=p;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events();await get_tree().process_frame;await get_tree().process_frame
 await get_tree().create_timer(.3).timeout
func run():
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");GameState.brand_intro_played=true;GameState.sound_enabled=false;SaveData.debug_mode=false;SaveData.rodeo_intro240=false;SaveData.victories240=ModeVictories240.fresh()
 var main=load("res://src/Presentation/main_menu.tscn").instantiate();get_tree().root.add_child(main);get_tree().current_scene=main;await get_tree().create_timer(1.).timeout
 var menu=get_tree().current_scene;menu._show_games213();await get_tree().create_timer(.4).timeout
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/games250-locked.png")
 var sheet=menu._games213
 for mode in ["bulls","race","duel","joust","memory"]:
  var old=menu._games213;await tap(old.canvas.get_node("Navigate_"+mode));assert(is_instance_valid(old));assert(menu._games213==old);assert(old.canvas.get_node("GameAccess239").text=="Para jugar: "+ModeAccess240.requirement(mode));print("PASS locked feedback ",mode)
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/games250-feedback.png")
 await tap(menu._games213.canvas.get_node("Navigate_crowns240"));print("CROWNS ",menu.get_children().filter(func(c):return c is ModeCrowns240).size())
 for c in menu.get_children():
  if c is ModeCrowns240:await tap(c.canvas.get_node("NavigationBack"))
 menu._show_games213();await get_tree().create_timer(.3).timeout;await tap(menu._games213.canvas.get_node("NavigationBack"));assert(not is_instance_valid(menu._games213));print("PASS back")
 for mode in ["bulls","race","duel","joust","memory"]:
  SaveData.debug_mode=true
  if not is_instance_valid(menu):
   menu=load("res://src/Presentation/main_menu.tscn").instantiate();get_tree().root.add_child(menu);get_tree().current_scene=menu;await get_tree().create_timer(.4).timeout
  menu._show_games213();await get_tree().create_timer(.4).timeout
  if mode=="bulls":
   await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/games250-unlocked.png")
  await tap(menu._games213.canvas.get_node("Navigate_"+mode))
  if mode=="bulls":assert(menu._drawer.visible);menu.free()
  else:
   assert(get_tree().current_scene.scene_file_path==menu_path(mode));get_tree().current_scene.free()
  menu=null;await get_tree().process_frame;print("PASS unlocked launch ",mode)
 get_tree().current_scene=null;get_tree().quit()
func menu_path(mode:String)->String:
 return {"race":"res://src/Presentation/race190.tscn","duel":"res://src/Presentation/duel193.tscn","joust":"res://src/Presentation/joust196.tscn","memory":"res://src/Presentation/jump_memory207.tscn"}[mode]
