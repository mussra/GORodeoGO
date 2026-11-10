extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var SaveData=root.get_node("SaveData");root.size=Vector2i(1280,720);PixelLabTrial.initialized=true;PixelLabTrial.pig_enabled=true;PixelLabTrial.goat_enabled=true;PixelLabTrial.bull_enabled=true
 SaveData.save_path="user://qa-visual69-isolated.dat";SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits.clear();SaveData.world_tamed.clear();SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.gd").new();root.add_child(world)
 while world._loading_world:await process_frame
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":world.player.position+Vector2(100,40)});world.add_child(pig);pig.set_process(false);pig.movement=Vector2.DOWN;pig.state.flee=true;pig._process(0)
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":world.player.position+Vector2(-100,40)});world.add_child(goat);goat.set_process(false);goat.movement=Vector2.RIGHT;goat._process(0)
 for i in 4:await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/world2769.png")
 world.queue_free();await process_frame
 var level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
 for i in 5:await process_frame
 for bull in level.all_bulls:bull.set_physics_process(false);bull._sprite_swap.play("flee_diag_down")
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/level2769.png");level.queue_free();await process_frame;quit()
