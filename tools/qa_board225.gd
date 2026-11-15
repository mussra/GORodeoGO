extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/board225-"+id+"-960.png")
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");GameState.brand_intro_played=true
 SaveData.save_path="user://board225-visual-only.cfg";SaveData.world_seed=7781;SaveData.world_generator_version=3;SaveData.world_position=Vector2(310,190);SaveData.world_quests={};SaveData.world_missions={};SaveData.repeat_contract165=ProgressionEconomy165.new_contract()
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.7).timeout
 var farmer:Dictionary=world._npcs98().filter(func(n):return n.id=="farmer")[0];world.player.position=farmer.position
 world._open_npc(farmer);world._npc_dialog.accepted.emit("farmer_pigs");await get_tree().process_frame
 world._open_board();await shot("farmer")
 SaveData.world_missions["herd_1,0"]="encargo";world._open_board();await shot("both")
 SaveData.accept_repeat_contract165();SaveData.record_pig104("board225-proof");world._open_board();await shot("progress")
 world.free();get_tree().quit()
