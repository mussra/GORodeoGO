extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");SaveData.save_path="user://hats235-visual-only.cfg";SaveData._load_valid=true;SaveData.hat_designs235={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("trial_a").traits={"coat":5,"pattern":6,"spots":3,"mane":1,"finish":"normal"};SaveData.save_progress()
 var hat:=HatPanel.new();add_child(hat);await get_tree().process_frame
 hat._color.select(6);hat._finish.select(6);hat._ink.select(3);hat._update_preview();await shot("unlocked")
 SaveData.sell_market_horse("trial_a");hat._update_preview();await shot("after-sale")
 hat._color.select(9);hat._update_preview();await shot("locked")
 hat.free();get_tree().quit()
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/hats235-"+id+"-960.png")
