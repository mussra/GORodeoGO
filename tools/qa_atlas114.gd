extends Node
func _ready():run.call_deferred()
func shot(name_):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/atlas114-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414);TranslationServer.set_locale("es");SaveData.trial_session_active=true;SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var panel=HorsePanel.new();add_child(panel);panel.size=get_viewport().get_visible_rect().size;panel.layout();panel.page="atlas";panel.atlas_owned_first=true;panel.atlas_page=0;panel._refresh();await shot("despues-arriba")
 print("ATLAS114 before ",panel.atlas_entries().size())
 panel.atlas_owned_first=false;panel.atlas_page=0;panel._refresh();await shot("despues-natural")
 print("ATLAS114 after ",panel.atlas_entries().size())
 panel.atlas_filters={"rarity":4};panel.atlas_owned_first=true;panel.atlas_page=0;panel._refresh();await shot("legendarios")
 get_tree().quit()
