extends Node
var label302:String=OS.get_environment("RANCHO_QA_LABEL")
func _ready():
 process_mode=Node.PROCESS_MODE_ALWAYS;run.call_deferred()
func shot(name_:String):
 for i in 12:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/302-'+label302+'-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa302scratch.cfg';SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.equipment_points=10000;SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear();SaveData.horse_collection.seed_trial();SaveData.rodeo_intro240=true
 var p:=EquipmentPanel.new();add_child(p)
 await shot('equipo-sin-comprar')
 for id in ['scare_whip265','scare_whip_plus265']:
  p._confirm_purchase(id)
  for i in 8:await get_tree().process_frame
  p._confirm.get_ok_button().pressed.emit()
  await shot('comprado-'+id)
 p._equip['scare_whip_plus265'].pressed.emit();await shot('equipado');p.free()
 if label302=='antes':get_tree().quit();return
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 for i in 3600:
  if not world._loading_world and not get_tree().root.has_node('FrontierTransition'):break
  await get_tree().process_frame
 assert(not world._loading_world and not get_tree().root.has_node('FrontierTransition'))
 world._open_navigation();await shot('frontera');world.free();get_tree().paused=false
 var nav:NavigationSheet
 var crowns:=ModeCrowns240.new();add_child(crowns);await shot('coronas');crowns.free()
 var book:=BreedingBook256.new();add_child(book);await shot('libro');book.free()
 nav=NavigationSheet.new();nav.title='FRONTERA · DEBUG';nav.entries=[{'id':'editor','title':'Editor','hint':'Autoría del mundo'},{'id':'modular_preview','title':'Vista de diseño','hint':'Sandbox aislado'},{'id':'country146','title':'País nuevo','hint':'Maqueta sin guardado'},{'id':'country_saved152','title':'País guardado','hint':'Registro separado'}];add_child(nav);await shot('debug-menu');nav.free()
 var trial=load('res://src/Presentation/trial_panel.gd').new();add_child(trial);await shot('debug-herramientas');trial.free()
 var horses:=HorsePanel.new();add_child(horses);await shot('caballeriza');horses.free();get_tree().quit()
