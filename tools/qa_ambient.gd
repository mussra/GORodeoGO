extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-ambient.cfg";SaveData.trial_session_active=true;SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(0,520)
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_physics_process(false)
 var preview=load("res://tools/preview_ambient_yard.gd").new();world.add_child(preview)
 var layer=CanvasLayer.new();layer.layer=110;add_child(layer)
 var strip=ColorRect.new();strip.color=Color("10252d");strip.position=Vector2(10,655);strip.size=Vector2(935,52);layer.add_child(strip)
 var label=Label.new();label.text="PREVIEW AMBIENTAL · animales decorativos · florista pendiente de arte";label.position=Vector2(20,669);label.add_theme_font_size_override("font_size",18);layer.add_child(label)
 await get_tree().create_timer(.7).timeout
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/ambient-farm-florist.png")
 await get_tree().create_timer(4).timeout;get_tree().quit()
