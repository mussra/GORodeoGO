extends Node
var world:CountryPreview146
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/island156-"+id+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false)
 for entry in [["sur",Vector2(6200,13480)],["esquina",Vector2(1300,12300)],["norte",Vector2(6200,580)]]:
  world.player.position=entry[1];world.camera.reset_smoothing();await shot(entry[0])
 world.player.position=CountryRoute146.BOUNDS.get_center();world.camera.zoom=Vector2.ONE*.045;world.camera.reset_smoothing();await shot("isla-completa");CountryExploration148.reveal(world.visited_cells,Vector2(6200,580));world.show_map();await shot("mapa-costa");print("ISLAND156_VISUAL_OK");get_tree().quit()
