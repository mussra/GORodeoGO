extends Node
var menu:HorsePanel
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/galaxy143-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.debug_mode=false;SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 SaveData.horse_collection.find("trial_a").traits.finish="galaxy";SaveData.horse_collection.find("trial_b").traits.finish="galaxy"
 var child:=SaveData.horse_collection.breed("trial_a","trial_b",{});child.name="Cría de dos Galaxy"
 var before:=SaveData.horse_collection.export_state();menu=HorsePanel.new();add_child(menu);await get_tree().create_timer(.3).timeout
 menu.focus_id=child.id;menu.show_page("detail");await shot("ficha")
 menu.show_page("collection");await get_tree().process_frame;await get_tree().process_frame
 for n in menu.content.get_children():
  if n is ScrollContainer:n.scroll_vertical=10000
 await shot("coleccion")
 menu.open_section("pasture141");await shot("rancho")
 for n in menu.content.get_children():
  if n is RanchPasturePanel141:n.family_id=child.id;n.refresh()
 await shot("familia")
 menu.show_page("breed");menu.parent_a="trial_a";menu.parent_b="trial_b";await shot("prevision")
 assert(before==SaveData.horse_collection.export_state());print("PURE143_UI_OK no mutation")
 get_tree().quit()
