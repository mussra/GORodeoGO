extends Node
func _ready():run.call_deferred()
func shot(name_):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/coleccion118-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414);TranslationServer.set_locale("es");SaveData.trial_session_active=true;SaveData.horse_collection=HorseCollection.new()
 for i in range(8):
  SaveData.horse_collection.horses.append({"id":"sample%d"%i,"parents":[],"name":"Lavanda con estrellas"+(" %d"%(i+1) if i>0 else ""),"stage":"adult","traits":{"coat":16 if i<3 else i,"pattern":6,"mane":1},"stats":{"speed":260+i*3,"handling":900,"power":.7,"dodge":1.0},"can_jump":i==1})
 SaveData.horse_collection.selected="sample1"
 var panel=HorsePanel.new();add_child(panel);panel.page="collection";panel._refresh();await shot("agrupado")
 panel.content.find_child("ToggleAppearance118",true,false).pressed.emit();await shot("desplegado")
 panel.content.find_child("Ficha118_sample1",true,false).pressed.emit();await shot("ficha")
 panel.show_page("family");await shot("genealogia")
 panel.get_node("HorseGenealogyOverlay118").queue_free();await shot("volver-lista")
 get_tree().quit()
