extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720)
 var parade:=LoadingParade.new();add_child(parade)
 while not parade.prepared:await get_tree().process_frame
 parade.set_process(false);parade.age=4.;parade._process(0.)
 parade.rider.position=Vector2(580,490)
 var xs:Dictionary={"goat":880.,"pig":1120.,"horse":1350.}
 for actor in parade.actors:actor.sprite.position=Vector2(xs[actor.kind],490);actor.sprite.visible=true
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/loading267-fondo.png")
 parade.age=10.;parade._process(0.)
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/loading267-desfile.png")
 parade.free();get_tree().quit()
