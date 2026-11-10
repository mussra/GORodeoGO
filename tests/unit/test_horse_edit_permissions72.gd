extends GutTest
var old_debug:bool
var old_trial:bool
var snapshot:Dictionary
func before_each():
 old_debug=SaveData.debug_mode;old_trial=SaveData.trial_session_active;snapshot=SaveData.horse_collection.export_state()
 SaveData.debug_mode=false;SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
func after_each():
 SaveData.debug_mode=old_debug;SaveData.trial_session_active=old_trial;SaveData.horse_collection.restore(snapshot)
func descendants(node:Node,type:String)->Array:
 var result:Array=[]
 for child in node.get_children():
  if child.is_class(type):result.append(child)
  result.append_array(descendants(child,type))
 return result
func panel()->HorsePanel:
 var p=HorsePanel.new();p.page="detail";p.focus_id="original";add_child_autofree(p);return p
func test_normal_detail_has_no_editors_or_save_but_keeps_game_actions():
 var p=panel();await wait_process_frames(3)
 assert_eq(descendants(p.content,"OptionButton").size(),0)
 assert_eq(descendants(p.content,"LineEdit").size(),0)
 var buttons=descendants(p.content,"Button").map(func(b):return b.text)
 for text in ["Emblema","Mustang: patas oscuras","Crecer (prueba)",tr("UI_108")]:assert_false(buttons.has(text))
 assert_true(buttons.has("Usar caballo"));assert_true(buttons.has("Mapa genealógico"))
func test_debug_and_trial_show_editors():
 for mode in ["debug","trial"]:
  SaveData.debug_mode=mode=="debug";SaveData.trial_session_active=mode=="trial"
  var p=panel();await wait_process_frames(3)
  assert_eq(descendants(p.content,"OptionButton").size(),4)
  assert_eq(descendants(p.content,"LineEdit").size(),1)
  assert_true(descendants(p.content,"Button").any(func(b):return b.text=="Emblema"))
  p.queue_free();await wait_process_frames(1)
func test_normal_mutation_methods_cannot_change_horse():
 var before=SaveData.horse_collection.export_state()
 assert_false(SaveData.rename_horse("original","Other"))
 assert_false(SaveData.set_horse_pattern_color("original","coat",3))
 assert_false(SaveData.set_horse_pattern_color("original","pattern",3))
 assert_false(SaveData.set_horse_legs("original",0,true))
 assert_false(SaveData.set_horse_emblem("original",HorseEmblem.DEFAULT))
 assert_false(SaveData.mature_horse_trial("original"))
 assert_eq(SaveData.horse_collection.export_state(),before)
