extends Node
func _ready():run.call_deferred()
func shot332(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/recovery332-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.performance_osd245=false;GameState.brand_intro_played=true;SaveData.save_path='user://visual332-'+str(Time.get_ticks_usec())+'.cfg';SaveData.load_progress();SaveData.story_intro319=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.equipment_points=321;SaveData.points_legacy_credit_applied=true;SaveData.save_progress()
 var cfg=ConfigFile.new();cfg.load(SaveData.save_path);var state=cfg.get_value('horses_trial','state');state.horses[0].traits.coat=999;cfg.set_value('horses_trial','state',state);cfg.save(SaveData.save_path);SaveData.load_progress()
 var menu=load('res://src/Presentation/main_menu_cartoon.tscn').instantiate();add_child(menu);await get_tree().create_timer(1.).timeout;await shot332('notice')
 for child in menu.get_children():
  if child is AcceptDialog:child.hide()
 menu._show_settings();await get_tree().create_timer(.2).timeout
 menu.find_child('SaveDiagnostic330',true,false).pressed.emit();await get_tree().create_timer(.2).timeout;await shot332('diagnostic')
 get_tree().quit()
