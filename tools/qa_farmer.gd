extends Node
var world
func _ready():run.call_deferred()
func shot(path:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-farmer.cfg";SaveData.trial_session_active=true;SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(310,270)
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.position=Vector2(310,270)
 await shot("/downloads/farmer-world.png");await get_tree().create_timer(2).timeout
 world._open_npc(NpcQuests.NPCS[0]);await shot("/downloads/farmer-quest.png");await get_tree().create_timer(3).timeout
 world._npc_dialog.accepted.emit("farmer_pigs");await get_tree().create_timer(1).timeout
 for id in ["qa1","qa2","qa3"]:world._quest_event("capture_animal","pig",id)
 world._open_npc(NpcQuests.NPCS[0]);await shot("/downloads/farmer-thanks.png");await get_tree().create_timer(2).timeout;get_tree().quit()
