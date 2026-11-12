extends Node
var frontier:Node2D
var world:CountryPreview146
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/country146-"+id+".png")
func run():
 process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.save_path="user://country146-qa.dat"
 frontier=load("res://src/Presentation/frontier_world.gd").new();add_child(frontier)
 while frontier._loading_world:await get_tree().process_frame
 frontier.player.set_physics_process(false);await get_tree().create_timer(1.2,true).timeout;frontier._open_navigation();await get_tree().create_timer(.3,true).timeout;await shot("menu")
 frontier._navigation.canvas.get_node("Navigate_country146").pressed.emit();await get_tree().process_frame
 for child in get_tree().root.get_children():
  if child is CountryPreview146:world=child
 assert(world!=null);world.player.set_physics_process(false)
 await shot("entrada")
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("entrada-960")
 get_tree().root.size=Vector2i(1280,720);await get_tree().process_frame
 for pair in [["raices",world.data.sites.tree],["rio",world.data.bank[2]],["fuente",world.data.sites.source]]:
  world.player.position=pair[1];await get_tree().process_frame;world.camera.reset_smoothing();await shot(pair[0])
 # Whole topology is QA evidence, not an initial in-game map disclosure.
 world.player.position=Vector2(6250,7000);world.camera.zoom=Vector2.ONE*.048;await get_tree().process_frame;await shot("topologia")
 print("COUNTRY146_VISUAL_OK visited=",world.ledger.maps.water146.visited);world.return_requested.emit();await get_tree().process_frame;await shot("regreso");get_tree().quit()
