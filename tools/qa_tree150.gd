extends Node
var world:CountryPreview146
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/tree150-"+id+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);SaveData.save_path="user://tree150-qa.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false)
 world.player.position=world.data.sites.tree;world._process(0.);world.camera.reset_smoothing();await shot("raices")
 world.camera.zoom=Vector2.ONE*.22;world.camera.reset_smoothing();await shot("rio-raices")
 world.player.position=world.data.tree_art.get_center();world.camera.zoom=Vector2.ONE*.072;world.camera.reset_smoothing();await shot("completo")
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("completo-960");print("TREE150_VISUAL_OK");get_tree().quit()
