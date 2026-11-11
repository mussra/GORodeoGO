extends Node
func _ready():run.call_deferred()
func shot(path):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://quest-hud83.cfg";SaveData.trial_session_active=true;SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_seed=752026;SaveData.world_position=Vector2(-325,-75)
 var h=SaveData.horse_collection.find(SaveData.horse_collection.selected);h.can_jump=false;h.can_dodge=false
 get_tree().change_scene_to_file("res://src/Presentation/frontier_world.tscn")
 while get_tree().current_scene==null or get_tree().current_scene._loading_world or get_tree().root.get_node_or_null("FrontierTransition")!=null:await get_tree().process_frame
 var world=get_tree().current_scene
 await shot("/downloads/quest-hud83-collapsed.png")
 world._quest_toggle.pressed.emit()
 await shot("/downloads/quest-hud83-expanded.png")
 get_tree().quit()
