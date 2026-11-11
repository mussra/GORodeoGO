extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720)
 var demo=load("res://tools/demo_galaxy.tscn").instantiate();add_child(demo)
 for stage in 4:
  demo.stage=stage;demo.build()
  for i in 5:await get_tree().process_frame
  await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/galaxy-demo-%d.png"%stage)
  await get_tree().create_timer(3).timeout
 get_tree().quit()
