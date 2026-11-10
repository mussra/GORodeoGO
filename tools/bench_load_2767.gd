extends Node
func _ready()->void:call_deferred("run")
func run()->void:

 SaveData.save_path="user://qa-load67.dat";SaveData.world_seed=7781;SaveData.world_edits=[];SaveData.world_tamed=[];SaveData.world_position=Vector2(-360,400);SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var start=Time.get_ticks_usec();var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 print("LOAD67 ready_ms=",(Time.get_ticks_usec()-start)/1000.0," chunks=",world._chunks.size()," cache=",load("res://src/Presentation/wild_horse_art.gd").frame_cache.size())
 var frames:int=0
 while world._chunks.size()<9 and frames<600:await get_tree().process_frame;frames+=1
 print("LOAD67 all9_ms=",(Time.get_ticks_usec()-start)/1000.0," frames=",frames," chunks=",world._chunks.size())
 get_tree().quit()
