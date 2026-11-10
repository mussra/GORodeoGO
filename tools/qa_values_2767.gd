extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-values67.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var panel:=HorsePanel.new();add_child(panel);panel.focus_id="unknown";panel.focus_preview={"traits":{"coat":1,"pattern":10,"mane":5,"spots":18},"stage":"adult"};panel.detail_origin="atlas_variants";panel.page="detail";panel.refresh()
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/detail2767.png")
 panel.page="atlas_variants";panel.atlas_family={"coat":1,"pattern":10,"mane":5};panel.refresh()
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/atlas2767.png")
 panel.page="detail";panel.focus_id="original";panel.refresh()
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/owned2767.png")
 for child in panel.content.get_children():
  if child is ScrollContainer:child.scroll_vertical=1000
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/owned2767-actions.png")
 get_tree().quit()
