extends Node
func _ready():run.call_deferred()
func shot(path:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://effect-anchors85-only.dat";SaveData.trial_session_active=true;SaveData.horse_collection.seed_trial()
 var bg=ColorRect.new();bg.color=Color("206237");bg.size=Vector2(1280,720);add_child(bg)
 var p=load("res://src/Presentation/world_player.gd").new();add_child(p);p.position=Vector2(570,400);p.set_physics_process(false)
 p.dodge.set_process(false);p._sprite_swap.play("walk_side");p._sprite_swap._sprite.stop()
 p.lasso._start_charging();p.lasso._charge_distance=200;p.lasso._update_charge_visual()
 p.dodge.remaining=.2;p.dodge.direction=Vector2.RIGHT
 p.dodge.skid_trail.assign([Vector2(380,400),Vector2(430,400),Vector2(480,400),Vector2(540,400)]);p.dodge.trail_fade=.7;p.queue_redraw()
 await shot("/downloads/effect-anchors85-"+OS.get_environment("ANCHOR_LABEL")+".png")
 p.lasso._cancel_charge();p.lasso._animate_lasso_flight(p.global_position,p.global_position+Vector2(200,0));p.lasso._flight_tween.pause();p.lasso._flight_line.progress=.4
 await shot("/downloads/effect-flight85-"+OS.get_environment("ANCHOR_LABEL")+".png")
 get_tree().quit()
