extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540)
 var parade:=LoadingParade.new();add_child(parade)
 while not parade.prepared:await get_tree().process_frame
 parade.set_process(false);parade.rider.position=Vector2(485,490);parade.rider.visible=true
 var xs:Dictionary={"goat":100.,"pig":280.,"horse":800.,"farmer":1130.}
 for actor in parade.actors:actor.sprite.position=Vector2(xs[actor.kind],490);actor.sprite.visible=true
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/loading228-proportions-960.png")
 parade.free();get_tree().quit()
