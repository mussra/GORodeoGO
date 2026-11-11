extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);SaveData.horse_collection=HorseCollection.new()
 var panel=UnicornAtlasPanel.new();add_child(panel)
 await get_tree().create_timer(.7).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/atlas-unicorns83.png");get_tree().quit()
