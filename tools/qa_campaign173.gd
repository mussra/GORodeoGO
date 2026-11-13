extends Node
func _ready():run.call_deferred()
func shot(label:String):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/campaign173-"+label+".png")
func run():
 TranslationServer.set_locale("es");GameState.brand_intro_played=true;get_tree().root.size=Vector2i(1280,720);SaveData.save_path="user://qa173.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.highest_level_completed=39;SaveData.equipment_points=100000;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.dual_lasso_intro_shown=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await get_tree().create_timer(.8).timeout;menu._show_levels();await get_tree().create_timer(.3).timeout;menu.level_scroll173.scroll_vertical=0;await shot("levels-top");menu.level_scroll173.scroll_vertical=10000;await get_tree().process_frame;await shot("levels40")
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("levels40-small");menu.free();get_tree().root.size=Vector2i(1280,720)
 for n in [21,23,26,30,36,40]:
  GameState.selected_level=n;var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await get_tree().create_timer(.15).timeout;level.set_physics_process(false);level.player.set_physics_process(false);level.player.position=Vector2(250,0);level._camera.reset_smoothing() if level.get("_camera")!=null else false;await shot("level%d"%n)
  if n in [23,40]:
   level.get_node("Camera2D").zoom=Vector2(.6,.6);level.get_node("Camera2D").position=Vector2.ZERO;level.get_node("Camera2D").reset_smoothing();level.get_node("Camera2D").force_update_scroll();await shot("overview%d"%n)
  level.free()
 SaveData.highest_level_completed=40;var panel:=HorsePanel.new();panel.page="market";add_child(panel);await get_tree().process_frame;await shot("market40");panel.free()
 var horse:=SaveData.horse_collection.find("original");horse.completed_levels=range(1,21);panel=HorsePanel.new();panel.page="detail";panel.focus_id="original";add_child(panel);await shot("old-master");panel.free();get_tree().quit()
