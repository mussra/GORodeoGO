extends Node
func _ready()->void:call_deferred("run")
func shot(name:String)->void:
 await get_tree().create_timer(.4).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/atlas2753-"+name+".png")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection.seed_trial()
 var panel:=HorsePanel.new();add_child(panel);panel.show_page("atlas")
 await shot("families")
 panel.atlas_family={"coat":10,"pattern":1,"mane":2,"eyes":10,"finish":"normal"};panel.atlas_page=0;panel.show_page("atlas_variants")
 await shot("spots")
 panel.open_atlas_filters();await shot("filters")
 for child in panel.get_children():
  if child is FilterDrawer:child.queue_free()
 panel.atlas_filters={"eyes":3,"legs":0};panel.refresh();await shot("eyes-legs")
 get_tree().quit()
