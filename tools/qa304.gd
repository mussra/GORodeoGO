extends Node
func _ready():
 process_mode=Node.PROCESS_MODE_ALWAYS;run.call_deferred()
func shot(name_:String):
 for i in 12:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/304-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa304scratch.cfg';SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.horse_collection.seed_trial();SaveData.rodeo_intro240=true
 SaveData.victories240=ModeVictories240.fresh();RaceCupSession194.path_override='user://qa304cup.cfg';DirAccess.remove_absolute(RaceCupSession194.path_override)
 var m=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(m)
 await get_tree().create_timer(.8).timeout;await shot('principal')
 m._show_games213();await shot('juegos');m.free()
 var crowns:=ModeCrowns240.new();add_child(crowns);await shot('pendientes');crowns.free()
 for mode in ModeVictories240.MODES:SaveData.victories240.wins[mode]=1
 var cup=RaceCup194.fresh()
 for goal in RaceCup194.CHALLENGES:cup.completed.append(goal.id)
 cup.last_sequence=cup.completed.size()
 RaceCupStore194.write_state(RaceCupSession194.path(),cup)
 crowns=ModeCrowns240.new();add_child(crowns);await shot('conseguidas');crowns.free()
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 for i in 3600:
  if not world._loading_world and not get_tree().root.has_node('FrontierTransition'):break
  await get_tree().process_frame
 assert(not world._loading_world and not get_tree().root.has_node('FrontierTransition'))
 world._open_navigation();await shot('frontera');world.free();get_tree().paused=false
 DirAccess.remove_absolute(RaceCupSession194.path_override);get_tree().quit()
