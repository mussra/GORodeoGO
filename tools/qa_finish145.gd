extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 var equipment:=EquipmentPanel.new();add_child(equipment);await get_tree().create_timer(.3).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/finish145-equipo.png");equipment.queue_free();await get_tree().process_frame
 var panel:=FinishPreview145.new();add_child(panel)
 await get_tree().create_timer(.8).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/finish145-estudio.png")
 get_tree().root.size=Vector2i(960,540);await get_tree().create_timer(.2).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/finish145-960.png")
 get_tree().root.size=Vector2i(1280,720)
 if OS.get_environment("FINISH145_VIDEO")=="1":
  for i in 72:
   panel.clocks=i/18.;panel._advance();await get_tree().process_frame;await RenderingServer.frame_post_draw
   get_viewport().get_texture().get_image().save_png("/downloads/finish145-frames/%04d.png"%i)
 print("FINISH145_PREVIEW_OK");get_tree().quit()
