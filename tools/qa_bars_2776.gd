extends Node
var panel
func _ready():run.call_deferred()
func shot(path:String):
 for i in 6:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.trial_session_active=false;SaveData.save_path="user://qa-bars76.cfg";SaveData.debug_mode=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var h=SaveData.horse_collection.find("original");h.stats={"speed":282,"handling":1260,"power":.8,"dodge":.92,"calm":1.6};h.can_jump=true;h.mastery={"jump":62,"dodge":35}
 panel=HorsePanel.new();panel.page="detail";panel.focus_id="original";add_child(panel)
 await shot("/downloads/bars2776-ficha-top.png")
 var scroll:ScrollContainer=find_scroll(panel);scroll.scroll_vertical=350
 await shot("/downloads/bars2776-ficha.png")
 await get_tree().create_timer(.8).timeout
 panel.page="atlas";panel.atlas_filters={"coat":10};panel.refresh()
 await shot("/downloads/bars2776-atlas.png")
 find_scroll(panel).scroll_vertical=230
 await shot("/downloads/bars2776-atlas-bars.png")
 await get_tree().create_timer(.8).timeout
 panel.queue_free();await get_tree().process_frame
 var training=TrainingPanel.new();training.mentor="original";training.learner="trial_a";add_child(training)
 await shot("/downloads/bars2776-training.png")
 await get_tree().create_timer(.8).timeout
 training.queue_free();await get_tree().process_frame
 SaveData.horse_collection.find("original")["can_jump"]=false
 SaveData.horse_collection.training_pair={"mentor":"trial_a","learner":"original","skill":"jump"};SaveData.horse_collection.selected="original";GameState.selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level)
 await shot("/downloads/bars2776-hud.png")
 level._trigger_win();await shot("/downloads/bars2776-result.png")
 await get_tree().create_timer(.8).timeout;get_tree().quit()
func find_scroll(node:Node)->ScrollContainer:
 if node is ScrollContainer:return node
 for c in node.get_children():
  var found=find_scroll(c)
  if found!=null:return found
 return null
