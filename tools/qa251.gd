extends Node
func _ready():run.call_deferred()
func capture(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/qa251-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");GameState.brand_intro_played=true;GameState.sound_enabled=false;SaveData.save_path="user://qa251scratch.cfg";SaveData.trial_session_active=false;SaveData.horse_collection.seed_trial();SaveData.debug_mode=false;SaveData.rodeo_intro240=false
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);menu._show_games213();await get_tree().create_timer(.4).timeout;await capture("locked")
 menu.free();await get_tree().process_frame
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var horse:=SaveData.horse_collection.find("trial_a");horse.traits.pattern=10;horse.name="Jirafa del Alba"
 SaveData.last_growth251=VictoryGrowth251.apply(SaveData.horse_collection,"trial_a","race")
 SaveData.last_growth251.new_horse=VictoryGrowth251.race_horse(SaveData.horse_collection,1)
 HorseVictory251.present(self)
 for i in 40:
  await get_tree().create_timer(.05).timeout;await capture("anim-%02d"%i)
  if i==5:await capture("reward-start")
  if i==12:await capture("reward-stars")
 await get_tree().create_timer(.9).timeout;await capture("reward-end")
 var view:HorseVictory251=get_children().filter(func(c):return c is HorseVictory251)[0]
 print("GROWTH_ANIMATION ",JSON.stringify({"progress":view.progress,"bar":view.bar.value,"nodes":Performance.get_monitor(Performance.OBJECT_NODE_COUNT),"memory_mib":Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.}))
 var close:Button=view.canvas.get_node("Continue251")
 var point:Vector2=get_viewport().get_final_transform()*close.get_global_rect().get_center()
 for down in [true,false]:
  var event:=InputEventScreenTouch.new();event.position=point;event.pressed=down;Input.parse_input_event(event);Input.flush_buffered_events();await get_tree().process_frame;await get_tree().process_frame
 print("CONTINUE_TOUCH_CLOSED ",not is_instance_valid(view))
 assert(not is_instance_valid(view))
 horse.completed_levels=[1,2,3,4,5,6];horse.race_courses251=[0,1];horse.mode_wins251={"duel":1,"joust":1,"memory":1}
 var champion:=VictoryGrowth251.champion(SaveData.horse_collection,"trial_a")
 SaveData.last_growth251=VictoryGrowth251.apply(SaveData.horse_collection,"trial_a","joust");SaveData.last_growth251.champion=champion
 HorseVictory251.present(self);await get_tree().create_timer(1.).timeout;await capture("mastery")
 var last:HorseVictory251=get_children().filter(func(c):return c is HorseVictory251)[0];last.free()
 var panel:=HorsePanel.new();add_child(panel);panel.focus_id="trial_a";panel.show_page("detail");await get_tree().create_timer(.6).timeout;await capture("family-sheet")
 get_tree().quit()
