extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 SaveData.horse_collection.find("trial_a").traits={"coat":18,"pattern":3,"mane":4,"eyes":10,"finish":"normal"}
 SaveData.horse_collection.find("trial_a").name="Celeste de trasera blanca"
 SaveData.horse_collection.find("trial_b").traits={"coat":12,"pattern":4,"mane":5,"eyes":10,"finish":"normal"}
 SaveData.horse_collection.find("trial_b").name="Crema de patas claras"
 var panel=HorsePanel.new();panel.page="breed";panel.parent_a="trial_a";panel.parent_b="trial_b";add_child(panel)
 for i in 6:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/cruzar2774.png")
 SaveData.horse_collection.find("trial_a").traits={"coat":6,"pattern":0,"mane":0,"eyes":10,"legs":9,"spots":4,"finish":"normal"}
 SaveData.horse_collection.find("trial_a").name="Morado liso"
 SaveData.horse_collection.find("trial_b").traits={"coat":19,"pattern":9,"mane":4,"eyes":20,"finish":"normal"}
 SaveData.horse_collection.find("trial_b").name="Ciruela cebra"
 panel.choices["pattern"]=1;panel.choices["eyes"]=1;panel.refresh()
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/cruzar2774-zebra.png")

 await get_tree().create_timer(1).timeout
 SaveData.horse_collection.find("trial_a").traits["legs"]=1;SaveData.horse_collection.find("trial_b").traits["legs"]=0
 panel.refresh()
 await get_tree().create_timer(1).timeout
 panel.choices["legs"]=1;panel.refresh()
 await get_tree().create_timer(1).timeout
 get_tree().quit()
