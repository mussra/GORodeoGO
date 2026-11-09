extends Node
var world
var goat
func _ready()->void:call_deferred("run")
func shot(n:String)->void:
 await get_tree().create_timer(.3).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/chase2758-"+n+".png")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-chase58.dat";SaveData.world_seed=7781;SaveData.world_edits=[];SaveData.world_position=Vector2(-360,400)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 await get_tree().create_timer(.5).timeout
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 goat=world._prototype_goats.get_child(0);goat.position=Vector2(-200,400);world.player.position=Vector2(-360,400)
 world._on_lasso_prey_captured(goat)
 goat.state=WorldGoats.tick(goat.state,160,true,1.5)
 goat.movement=Vector2.LEFT
 await shot("goat")
 # Exercise real contact path and assert rope/active capture cleanup.
 goat.position=world.player.position+Vector2(40,0);world._tick_goats(.016)
 assert(not goat.roped);assert(world._lasso_state=="");assert(world.player._stun_time_remaining>0)
 await shot("escape")
 # Add a pig only in this QA scene; production pigs use generated pens.
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2(-200,400)});world.add_child(pig)
 world.player._stun_time_remaining=0
 world._on_lasso_prey_captured(pig);pig.state=WorldPigs.chase_tick(pig.state,160,250,true,1)
 pig.movement=Vector2.DOWN
 await shot("pig")
 print("CHASE_QA: goat contact releases rope and stuns; pig holds and runs")
 get_tree().quit()
