extends Node
func _ready():run.call_deferred()
func snap(panel:HorsePanel,label_:String):
 var started:=Time.get_ticks_usec();panel._refresh();await RenderingServer.frame_post_draw
 print("PAGE261 ",label_," ms=",(Time.get_ticks_usec()-started)/1000.," cards=",panel.content.get_node("AtlasVisibleGrid117").get_child_count())
 get_viewport().get_texture().get_image().save_png("/downloads/atlas261-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;SaveData.save_path="user://qa261.dat";SaveData.horse_collection.seed_trial()
 var panel:=HorsePanel.new();panel.page="atlas_variants";panel.atlas_family={"coat":0,"pattern":4,"mane":4};add_child(panel);await get_tree().create_timer(.2).timeout
 await snap(panel,"light-legs")
 panel.page="atlas";panel.atlas_filters={"rarity":3};panel.atlas_page=7;await snap(panel,"filtered-first")
 panel.atlas_page=8;await snap(panel,"filtered-next");panel.atlas_page=7;await snap(panel,"filtered-back")
 panel.free();get_tree().quit()
