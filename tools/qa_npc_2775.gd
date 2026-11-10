extends Node
var world
func _ready():run.call_deferred()
func shot(path:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.trial_session_active=true;SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(310,270)
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.position=Vector2(310,270)
 await shot("/downloads/npc2775-world.png")
 world._open_npc(NpcQuests.NPCS[0]);await shot("/downloads/npc2775-offer.png")
 await get_tree().create_timer(.8).timeout
 await get_tree().create_timer(.8).timeout
 world._npc_dialog.accepted.emit("farmer_pigs")
 await shot("/downloads/npc2775-active.png")
 for id in ["qa1","qa2","qa3"]:world._quest_event("capture_animal","pig",id)
 world._open_npc(NpcQuests.NPCS[0]);await shot("/downloads/npc2775-goats.png")
 await get_tree().create_timer(.8).timeout
 await get_tree().create_timer(.8).timeout;world._close_npc()
 world.player.position=Vector2(15*1024+5,160)
 await shot("/downloads/npc2775-flower.png")
 await get_tree().create_timer(.8).timeout
 world._flower_button.pressed.emit();await shot("/downloads/npc2775-flower-done.png")
 get_tree().quit()
