extends Node
func _ready():run.call_deferred()
func shot(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/slots334-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.performance_osd245=false;GameState.brand_intro_played=true
 var base='user://visual334-'+str(Time.get_ticks_usec());DirAccess.make_dir_absolute(base);SaveData.save_path=base+'/normal.cfg';SaveData.load_progress();SaveData.story_intro319=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.save_progress();SaveData.slots334=SaveSlots334.new();SaveData.slots334.root=base+'/slots';SaveData.slots334.setup(SaveData.save_path,base+'/debug.cfg');SaveData.slots334.attach(SaveData)
 var menu=load('res://src/Presentation/main_menu_cartoon.tscn').instantiate();add_child(menu);await get_tree().create_timer(.6).timeout;await shot('menu')
 var panel=SaveSlotsPanel334.new();menu.add_child(panel);await get_tree().create_timer(.2).timeout;await shot('list');panel.name_dialog('','Nueva partida');await get_tree().create_timer(.2).timeout;await shot('name');menu.free()
 var world=load('res://src/Presentation/frontier_world.gd').new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 while get_tree().root.get_node_or_null('FrontierTransition')!=null:await get_tree().process_frame
 world.player.position=world.garden212.plot+Vector2(0,150);await get_tree().create_timer(.3).timeout;await shot('lucia')
 world.garden212.open();await get_tree().create_timer(4.).timeout;await shot('garden');world.garden212.close()
 var hidden=[]
 for layer in world.find_children('*','CanvasLayer',true,false):
  if layer.visible:hidden.append(layer);layer.hide()
 await RenderingServer.frame_post_draw
 SaveData.slots334.thumbnail(get_viewport().get_texture().get_image(),SaveData)
 for layer in hidden:layer.show()
 world.free();var list_=SaveSlotsPanel334.new();add_child(list_);await get_tree().create_timer(.2).timeout;await shot('thumbnail');get_tree().quit()
