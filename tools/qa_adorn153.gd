extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);var preview:=AdornPreview153.new();add_child(preview)
 DirAccess.make_dir_recursive_absolute("/downloads/adorn153-frames")
 for i in 72:
  preview.clock=float(i)/18.;preview._advance();preview.set_process(false)
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/adorn153-frames/%04d.png"%i)
 get_viewport().get_texture().get_image().save_png("/downloads/adorn153-preview.png")
 get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/adorn153-preview-960.png")
 print("ADORN153_PREVIEW_OK");get_tree().quit()
