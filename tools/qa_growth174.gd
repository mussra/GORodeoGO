extends Node
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720);SaveData.save_path="user://qa_growth174.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var a:=HorseMarket.buy(SaveData.horse_collection,{"traits":{"coat":3,"pattern":6,"mane":5,"finish":"galaxy"}});var b:=HorseMarket.buy(SaveData.horse_collection,{"traits":{"coat":4,"pattern":6,"mane":5,"finish":"galaxy"}});var h:=SaveData.horse_collection.breed(a.id,b.id,{})
 for progress in [0,9,10]:
  get_tree().root.size=Vector2i(960,540) if progress==9 else Vector2i(1280,720)
  h.growth174=progress;var panel:=HorsePanel.new();panel.page="detail";panel.focus_id=h.id;add_child(panel);await get_tree().process_frame;await get_tree().process_frame
  for child in panel.find_children("*","ScrollContainer",true,false):
   if child is ScrollContainer:child.scroll_vertical=10000
  await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/growth174-%d.png"%progress);panel.free()
 get_tree().quit()
