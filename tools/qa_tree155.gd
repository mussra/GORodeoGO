extends Node
var world:CountryPreview146
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/tree155-"+id+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);world=CountryPreview146.new();add_child(world);world.player.set_physics_process(false)
 world.player.position=world.data.sites.tree;world._process(0.);world.camera.zoom=Vector2.ONE*.20;world.camera.reset_smoothing();await shot("escala")
 world.camera.zoom=Vector2.ONE*.5;world.camera.reset_smoothing();await shot("raices")
 var debug:=Line2D.new();debug.points=world.data.tree_solid;debug.closed=true;debug.width=10.;debug.default_color=Color("fa4b63");debug.z_index=26;world.add_child(debug);await shot("colision");debug.queue_free()
 world.player.position=world.data.tree_art.position+world.data.tree_art.size*Vector2(.79,.35);world.camera.zoom=Vector2.ONE;world.camera.reset_smoothing();world._process(0.);await shot("copa")
 world.show_map();await get_tree().create_timer(.4,true).timeout;await shot("mapa");print("TREE155_VISUAL_OK");get_tree().quit()
