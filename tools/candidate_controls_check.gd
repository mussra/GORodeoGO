extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");var before:Dictionary=save.horse_collection.export_state();save.begin_trial_session()
 var panel:Node=load("res://src/Presentation/trial_panel.gd").new();root.add_child(panel)
 for i in range(3):await process_frame
 var picks:Array=[]
 for node in panel.canvas.get_children():
  if node is OptionButton:picks.append(node)
 picks[1].selected=9;picks[3].selected=21;picks[4].selected=1
 for node in panel.canvas.get_children():
  if node is Button and node.text=="USAR ASPECTO TEMPORAL":node.pressed.emit()
 var t:Dictionary=save.horse_collection.find(save.horse_collection.selected).traits
 assert(t.pattern==9 and t.eyes==21 and t.finish=="galaxy")
 panel.queue_free();save.end_trial_session();assert(before==save.horse_collection.export_state())
 save.begin_trial_session();save.horse_collection.add_trial_parents();save.horse_collection.find("trial_b").traits.finish="galaxy"
 var hp:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(hp);hp.parent_a="trial_a";hp.parent_b="trial_b";hp.show_page("breed")
 for i in range(5):await process_frame
 for node in hp.content.get_children():
  if node is Button and node.text=="A · Normal":node.pressed.emit()
 for i in range(3):await process_frame
 assert(hp.choices.finish==1);assert(save.horse_collection.preview("trial_a","trial_b",hp.choices).finish=="galaxy")
 save.end_trial_session();print("CANDIDATE_CONTROLS_OK: selector eyes/pattern/galaxy, apply, restoration, breeding finish toggle");quit()
