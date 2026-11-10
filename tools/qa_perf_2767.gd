extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 PixelLabTrial.initialized=true;PixelLabTrial.enabled=true;PixelLabTrial.masks_enabled=true;PixelLabTrial.pig_enabled=true
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-perf67.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits=[];SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var start=Time.get_ticks_msec();var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 print("PERF67 rider_frames=",world.player._sprite_swap._frames.get_frame_count("walk_side")," masks=",PixelLabTrial.masks_active())
 var elapsed=Time.get_ticks_msec()-start
 var layer=CanvasLayer.new();layer.layer=99;add_child(layer);var title=Label.new();world._toasts.clear();world._toasts.column.visible=false;title.position=Vector2(25,60);title.add_theme_font_size_override("font_size",24);title.text="2.7.67 · Frontera: 9 zonas listas · cálculo limitado a cercanía";layer.add_child(title)
 await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/frontier2767.png")
 Input.action_press("move_right")
 await get_tree().create_timer(4).timeout
 Input.action_release("move_right");get_tree().quit()
