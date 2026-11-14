extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/memory207-"+id+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var scene=load("res://src/Presentation/jump_memory207.tscn").instantiate();add_child(scene)
 await shot("inicio")
 scene._action();scene.set_physics_process(false);scene.model.sequence.assign([0,2,1]);scene.light=2;scene._refresh();await shot("observa")
 scene.light=-1;scene.model.begin_input();scene._refresh();scene.player.position=Vector2(350,380)
 scene.player.request_jump(Vector2.UP)
 for i in 15:await get_tree().physics_frame
 await shot("salto")
 scene.free();get_tree().quit()
