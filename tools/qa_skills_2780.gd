extends Node
func _ready():run.call_deferred()
func shot(path:String):
 for i in 8:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.trial_session_active=false;SaveData.save_path="user://qa-skills80.cfg";SaveData.debug_mode=false
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var h=SaveData.horse_collection.find("trial_b");h.name="Violeta jirafa";h.traits={"coat":6,"pattern":10,"mane":0,"spots":6,"finish":"normal"}
 var panel=HorsePanel.new();panel.page="detail";panel.focus_id=h.id;add_child(panel)
 await shot("/downloads/skills2780-top.png")
 find_scroll(panel).scroll_vertical=350
 await shot("/downloads/skills2780-acquired.png")
 await get_tree().create_timer(1).timeout
 h.traits.pattern=0;h.traits.spots=4;h.name="Violeta liso";panel.refresh()
 h.can_jump=true;h.can_dodge=true;h.mastery={"jump":100.0,"dodge":38.0};panel.refresh()
 for i in 5:await get_tree().process_frame
 find_scroll(panel).scroll_vertical=350
 await shot("/downloads/skills2780-mastery.png")
 await get_tree().create_timer(1).timeout;get_tree().quit()

func find_scroll(node:Node)->ScrollContainer:
 if node is ScrollContainer:return node
 for c in node.get_children():
  var found=find_scroll(c)
  if found!=null:return found
 return null
