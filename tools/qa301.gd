extends SceneTree
var game:Node
var output301:String=OS.get_environment("RANCHO_QA_OUTPUT")
func _initialize():run.call_deferred()
func touch301(point:Vector2,down:bool,index:int):
 var e:=InputEventScreenTouch.new();e.position=root.get_final_transform()*point;e.pressed=down;e.index=index;Input.parse_input_event(e);Input.flush_buffered_events()
func run():
 if output301.is_empty():output301="user://review301"
 DirAccess.make_dir_recursive_absolute(output301)
 root.size=Vector2i(1600,720);TranslationServer.set_locale('es')
 var state=root.get_node('GameState');var save=root.get_node('SaveData')
 state.sound_enabled=false;state.brand_intro_played=true;state.selected_level=1
 save.save_path='user://qa301isolated.cfg';save.horse_collection.seed_trial();save.equipment_owned.append('scare_whip265');save.equipment_equipped.scare_whip='scare_whip265';save.rodeo_intro240=true
 game=load('res://src/Presentation/level_0.tscn').instantiate();root.add_child(game);current_scene=game
 await create_timer(1.).timeout
 for extent in [Vector2i(1600,720),Vector2i(1280,720),Vector2i(1280,960)]:
  root.size=extent
  for i in 15:await process_frame
  await RenderingServer.frame_post_draw
  root.get_texture().get_image().save_png(output301+'/301-level-'+str(extent.x)+'x'+str(extent.y)+'.png')
 root.size=Vector2i(1600,720)
 for i in 12:await process_frame
 var button=game.hud.get_node('ScareButton265')
 DirAccess.remove_absolute(ProjectSettings.globalize_path(WhipKindness301.PREF_PATH))
 touch301(Vector2(150,400),true,0)
 await physics_frame
 var drift:=InputEventScreenDrag.new();drift.index=0;drift.position=root.get_final_transform()*Vector2(30,420);Input.parse_input_event(drift);Input.flush_buffered_events()
 for i in 3:await physics_frame
 var at=button.get_global_rect().get_center()
 touch301(at,true,1);await process_frame
 drift=InputEventScreenDrag.new();drift.index=1;drift.position=root.get_final_transform()*(at+Vector2(18,3));Input.parse_input_event(drift);Input.flush_buffered_events()
 await process_frame;touch301(at+Vector2(18,3),false,1)
 for i in 3:await process_frame
 var move=Input.get_vector('move_left','move_right','move_up','move_down')
 print('TWO_FINGERS_301 ',JSON.stringify({'moving':str(move),'cooldown':button.cooldown265,'lasso_charging':game.player.lasso.is_charging(),'lasso_flying':game.player.lasso.is_in_flight(),'notice':button.get_parent().get_child(button.get_parent().get_child_count()-1).get_class()}))
 assert(move.length()>.1 and button.cooldown265>4. and not game.player.lasso.is_charging() and not game.player.lasso.is_in_flight())
 await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output301+'/301-first-use.png')
 touch301(Vector2(30,420),false,0)
 game.free()
 var equip=load("res://src/Presentation/equipment_panel.gd").new();root.add_child(equip)
 for i in 16:await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(output301+'/301-equipo.png')
 equip.free();quit()
