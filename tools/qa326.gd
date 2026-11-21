extends Node
func _ready():run.call_deferred()
func shot326(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/bullet326-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.performance_osd245=false;SaveData.debug_mode=false;GameState.brand_intro_played=true;SaveData.story_intro319=true;GameState.controls_world323=false;SaveData.save_path='user://qa326-visual-only.cfg';SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.equipment_owned.append('scare_whip265');SaveData.equipment_equipped.scare_whip='scare_whip265';SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_position=WorldNominal98.home()+Vector2(-200,240);SaveData.world_edits=[]
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 await get_tree().create_timer(5.).timeout
 world.set_physics_process(false);world.set_process(false)
 var goat=world._prototype_goats.get_child(0);goat.position=world.player.position+Vector2(150,0);goat.set_process(false);world._on_lasso_prey_captured(goat)
 world.player.dodge.available=true
 await get_tree().create_timer(.2).timeout;await shot326('world-ready')
 var button=world.get_node('DodgeActions326/DodgeButton326');button.pressed.emit()
 var touch=InputEventScreenTouch.new();touch.index=0;touch.position=Vector2(150,490);touch.pressed=true;Input.parse_input_event(touch)
 await get_tree().create_timer(.03).timeout
 var drag=InputEventScreenDrag.new();drag.index=0;drag.position=Vector2(225,465);Input.parse_input_event(drag)
 await get_tree().create_timer(.03).timeout;world._tick_goats(.1);await shot326('world-linked-goat')
 world.player.dodge.cancel();world.free()
 SaveData.begin_trial_session();SaveData.dual_lasso_intro_shown=true;GameState.selected_level=5
 var level=load('res://src/Presentation/level_0.tscn').instantiate();add_child(level)
 await get_tree().create_timer(.5).timeout;level.player.set_physics_process(false);level.player.position+=Vector2(-70,90);level.player.set_physics_process(true);await get_tree().create_timer(.1).timeout;await shot326('rodeo-ready');level.free();get_tree().quit()
