extends SceneTree
func _initialize()->void:
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents();var old:=c.export_state()
 assert(c.restore(old));assert(c.export_state()==old);assert(HorseCollection.eye_index(c.find("original").traits)==10)
 var added:=c.add_random_trial_pair();assert(added[0].traits.has("eyes"));assert(c.valid_traits(added[0].traits))
 added[0].traits.eyes=3;added[1].traits.eyes=4
 assert(c.preview(added[0].id,added[1].id,{"eyes":0}).eyes==3)
 assert(c.preview(added[0].id,added[1].id,{"eyes":1}).eyes==4)
 var child:=c.breed("trial_a",added[0].id,{"eyes":1});assert(child.traits.eyes==3)
 var clone:=HorseCollection.new();assert(clone.restore(c.export_state()));assert(clone.export_state()==c.export_state())
 var t:Dictionary=added[0].traits.duplicate();t.eyes=20;assert(not c.valid_traits(t));t.eyes="blue";assert(not c.valid_traits(t))
 print("EYES_OLD_NEW_PARENT_CHOICE_CHILD_ROUNDTRIP_VALIDATION_PASS");quit()
