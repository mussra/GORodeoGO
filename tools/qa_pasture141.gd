extends Node
var panel:RanchPasturePanel141
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/rancho141-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.trial_session_active=true;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 for i in 15:
  var t:Dictionary={"coat":(i*3)%20,"pattern":i%12,"mane":5 if i>12 else i%6,"eyes":20 if i>12 else i%22,"finish":"galaxy" if i>12 else "normal"}
  SaveData.horse_collection.horses.append({"id":"qa141_"+str(i),"name":"Caballo del rancho "+str(i),"parents":[],"traits":t,"stage":"adult"})
 var child:=SaveData.horse_collection.breed("trial_a","trial_b",{})
 var before:Dictionary=SaveData.horse_collection.export_state();var start:int=Time.get_ticks_msec()
 panel=RanchPasturePanel141.new();add_child(panel)
 print("PASTURE141_BUILD_MS ",Time.get_ticks_msec()-start)
 await get_tree().create_timer(.5).timeout;await shot("todos")
 panel.page_index=1;panel.refresh();await shot("pagina2")
 panel.tier=4;panel.page_index=0;panel.refresh();await shot("legendarios")
 panel.family_id=child.id;panel.refresh();await shot("familia")
 assert(before==SaveData.horse_collection.export_state())
 print("PASTURE141_OK actors=",panel.animated.size()," total horses=",SaveData.horse_collection.horses.size())
 get_tree().quit()
