extends "res://tools/qa_pasture141.gd"
func click(at:Vector2):
 var down:=InputEventMouseButton.new();down.position=at;down.button_index=MOUSE_BUTTON_LEFT;down.pressed=true;Input.parse_input_event(down)
 await get_tree().process_frame
 var up:=InputEventMouseButton.new();up.position=at;up.button_index=MOUSE_BUTTON_LEFT;up.pressed=false;Input.parse_input_event(up)
 await get_tree().process_frame;await get_tree().process_frame
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.trial_session_active=false;SaveData.debug_mode=false
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.breed("trial_a","trial_b",{})
 var menu:=HorsePanel.new();add_child(menu)
 await get_tree().create_timer(.3).timeout;await shot("menu")
 await click(Vector2(200,623));assert(menu.page=="pasture141");await shot("menu-corrales")
 await click(Vector2(220,290));assert(menu.page=="detail");assert(menu.focus_id=="original");await shot("menu-ficha")
 await click(Vector2(1150,45));assert(menu.page=="pasture141")
 get_tree().root.size=Vector2i(960,540);await get_tree().create_timer(.3).timeout;await shot("960x540")
 await click(Vector2(865,34));assert(menu.page=="hub")
 print("PASTURE141_REAL_POINTER_OK")
 get_tree().quit()
