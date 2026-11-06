extends SceneTree
var checks:int=0
func check(value:bool,title:String)->void:
 checks+=1
 if not value:push_error("FAIL "+title);quit(1)
func _initialize()->void:call_deferred("run")
func run()->void:
 var c:=HorseCollection.new();c.seed_trial();check(c.horses.size()==1,"one starter")
 c.add_trial_parents();c.add_trial_parents();check(c.horses.size()==3,"test parents idempotent")
 check(c.breed("original","original",{}).is_empty(),"distinct parents")
 check(c.breed("missing","original",{}).is_empty(),"owned parents")
 var before:Dictionary=c.export_state()
 var child:Dictionary=c.breed("trial_a","trial_b",{"coat":0,"pattern":0,"mane":1})
 check(child.stats=={"speed":280.0,"handling":1250.0,"power":0.8,"dodge":1.0},"best functional values")
 check(child.traits.coat==3 and child.traits.mane==5,"parent choices")
 check(c.horses.size()==4 and child.parents==["trial_a","trial_b"],"parent retention")
 check(c.find("trial_a")==before.horses[1],"unchanged parent")
 check(c.grant_achievement(2).id=="achievement_2","achievement random grant")
 check(c.grant_achievement(2).is_empty(),"achievement no duplicate")
 var d:=HorseCollection.new();check(d.restore(c.export_state()),"restore valid")
 var bad:Dictionary=c.export_state();bad.horses[0].parents=[child.id,child.id];check(not d.restore(bad),"reject cycle")
 var save=root.get_node("SaveData");var old_path:String=save.save_path;var old:Dictionary=save.horse_collection.export_state()
 save.horse_collection=c;save.save_path="user://qa_horses.dat"
 check(save.save_progress(),"save");save.load_progress();check(save.horse_collection.find(child.id)==child,"reload child")
 check(save.select_horse(child.id),"equip");save.load_progress();check(save.horse_collection.selected==child.id,"reload selected")
 save.save_path="user://nonexistent-dir/fail.dat";var snap:Dictionary=save.horse_collection.export_state()
 check(save.breed_horses("trial_a","trial_b",{}).is_empty(),"failed save returns no child")
 check(save.horse_collection.export_state()==snap,"failed save rollback")
 check(not save.select_horse("original"),"failed equip");check(save.horse_collection.selected==child.id,"failed equip rollback")
 save.save_path=old_path;save.horse_collection.restore(old);DirAccess.remove_absolute("user://qa_horses.dat")
 print("HORSE_CHECKS_PASSED ",checks);quit()
