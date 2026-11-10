extends Node
var panel:HorsePanel
func _ready():run.call_deferred()
func shot(path:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.horse_collection=HorseCollection.new()
 panel=HorsePanel.new();panel.page="atlas";panel.atlas_filters={"pattern":10};add_child(panel)
 await shot("/downloads/atlas2774-all.png")
 var entries=panel.atlas_entries();print("GIRAFFE ALL: ",entries.size()," / pages ",ceili(entries.size()/6.0))
 panel.detail_entries=entries;panel.focus_preview=entries[1].horse;panel.detail_origin="atlas";panel.page="detail";panel.refresh()
 await shot("/downloads/atlas2774-detail.png")
 await get_tree().create_timer(.8).timeout
 panel.content.get_node("ItemPager").next.pressed.emit()
 await get_tree().create_timer(.8).timeout
 panel.content.get_node("ItemPager").next.pressed.emit()
 await get_tree().create_timer(.8).timeout
 await get_tree().create_timer(1).timeout
 panel.page="atlas";panel.atlas_filters["spots"]=5;panel.refresh()
 await shot("/downloads/atlas2774-red.png")
 await get_tree().create_timer(.8).timeout
 get_tree().quit()
