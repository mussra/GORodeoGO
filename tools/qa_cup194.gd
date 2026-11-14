extends Node
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/cup194-"+id+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_path="user://cup194qa-never-main.dat"
 RaceCupSession194.path_override="user://cup194qa-isolated.cfg"
 if FileAccess.file_exists(RaceCupSession194.path()):DirAccess.remove_absolute(RaceCupSession194.path())
 var selector=load("res://src/Presentation/race190.tscn").instantiate();add_child(selector);await shot("selector");selector.free()
 var view=load("res://src/Presentation/race_cup194.tscn").instantiate();add_child(view);await shot("goal");view.free()
 RaceCupSession194.begin()
 var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);race.selector.hide();race.player.next_gate=17;race.player.finish_time=55.;race._finish();await shot("story")
 if is_instance_valid(race.story_dialog):race.story_dialog.free();race.story_dialog=null
 await shot("result");race.free()
 view=load("res://src/Presentation/race_cup194.tscn").instantiate();add_child(view);await shot("next-goal");view.free()
 var state:Dictionary=RaceCupStore194.read_state(RaceCupSession194.path()).state
 state.completed.clear();state.last_sequence=RaceCup194.CHALLENGES.size()
 for goal in RaceCup194.CHALLENGES:state.completed.append(goal.id)
 RaceCupStore194.write_state(RaceCupSession194.path(),state)
 view=load("res://src/Presentation/race_cup194.tscn").instantiate();add_child(view);await shot("complete");view._play();await shot("claimed");view.free()
 var horse_panel:=HorsePanel.new();horse_panel.page="detail";horse_panel.focus_id=CupRewards195.HORSE;add_child(horse_panel);await shot("horse");horse_panel.free()
 RaceCupSession194.pending_result={"sequence":99};RaceCupSession194.pending_path=RaceCupSession194.path();RaceCupSession194.last_notice="No se ha guardado este resultado. Vuelve a la copa y reintenta antes de cerrar el juego. El progreso anterior sigue protegido."
 view=load("res://src/Presentation/race_cup194.tscn").instantiate();add_child(view);await shot("pending");view.free();RaceCupSession194.pending_result.clear();RaceCupSession194.pending_path=""
 DirAccess.remove_absolute(SaveData.save_path)
 print("CUP194_QA main_saved=",FileAccess.file_exists(SaveData.save_path))
 DirAccess.remove_absolute(RaceCupSession194.path());RaceCupSession194.path_override="";get_tree().quit()
