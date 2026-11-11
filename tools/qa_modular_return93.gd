extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1598,720)
 SaveData.save_path="user://modular93-return-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_edits=[];SaveData.world_position=Vector2(100,180);SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 var position_before=SaveData.world_position;var edits_before=SaveData.world_edits.duplicate(true)
 world._open_modular_preview93()
 await get_tree().create_timer(.5).timeout
 var preview=get_tree().root.get_node("ModularWorld93")
 assert(not world.visible);assert(world.process_mode==Node.PROCESS_MODE_DISABLED)
 preview.return_requested.emit()
 await get_tree().process_frame;await get_tree().process_frame
 assert(world.visible);assert(world.process_mode!=Node.PROCESS_MODE_DISABLED)
 assert(SaveData.world_position==position_before);assert(SaveData.world_edits==edits_before)
 print("RETURN93 PASS original world restored; saved position and edits unchanged")
 get_tree().quit()
