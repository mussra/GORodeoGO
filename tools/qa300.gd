extends Node
func _ready():
 process_mode=Node.PROCESS_MODE_ALWAYS
 run.call_deferred()
func shot(label_:String):
 for i in 12:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/ui300-'+label_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa300scratch.cfg';SaveData.horse_collection.seed_trial();SaveData.highest_level_completed=3
 var menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu);get_tree().current_scene=self
 await get_tree().create_timer(1.).timeout;await shot('menu')
 menu._show_games213();await shot('juegos');menu._games213.free();menu._games213=null
 menu._show_equipment();await shot('equipo');menu._equipment_panel.hide()
 menu._show_settings();await shot('ajustes');menu.get_node('Settings213').free()
 # Show all button states on real in-engine controls as an extra visual check.
 var row=HBoxContainer.new();row.position=Vector2(60,640);menu.add_child(row)
 for state in ['normal','hover','pressed','disabled']:
  var b=Button.new();b.custom_minimum_size=Vector2(270,55);b.text=state;b.add_theme_stylebox_override('normal',ButtonSkin272.style(state,true));b.add_theme_color_override('font_color',Color('fff1d2'));row.add_child(b)
 await shot('estados');menu.free()
 var packed=load('res://src/Presentation/level_0.tscn').instantiate()
 var level=packed.get_node('HUD');packed.remove_child(level);packed.free();add_child(level)
 await get_tree().create_timer(.8).timeout
 var hud=level
 if hud==null:
  for c in level.get_children():
   if c.get_script()==load('res://src/Presentation/hud.gd'):hud=c
 if hud!=null:
  hud._pause_panel.show();await shot('pausa')
 else:push_error('HUD not found')
 level.free();get_tree().quit()
