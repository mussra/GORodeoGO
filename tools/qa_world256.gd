extends Node
func _ready():run.call_deferred()
func shot(label_:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/qa256-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path="user://qa256world.dat";SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1500,780);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 var world=load("res://tools/perf_world242.gd").new();add_child(world);get_tree().current_scene=self
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);world.player.position=Vector2(1500,730);world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 await shot("exterior")
 world._open_npc(SaddleryExterior256.definition());await shot("entered");print("ENTERED_ROOM ",world._npc_dialog is SaddleryRoom256)
 world._npc_dialog.finish();await get_tree().process_frame;print("EXIT_RESUMES ",world.player.is_physics_processing())
 world.player.position=BreedingAdvice256.mentor_position()+Vector2(0,80);world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 await shot("alma-world")
 world._open_npc(BreedingAdvice256.mentor());await shot("mentor-tutorial");print("MENTOR_OPEN ",world._npc_dialog is BreedingBook256)
 world._npc_dialog.finish();await get_tree().process_frame
 world._open_navigation();await shot("world-menu");world._navigation.queue_free();world._navigation_selected("book256");await shot("world-book")
 world.free();get_tree().quit()
