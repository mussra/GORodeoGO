extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es")
 RaceCourse190.selected=0;RaceCourse190.start_selected=true
 var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race)
 await get_tree().physics_frame;await get_tree().physics_frame
 race.selector.hide();race.countdown=0.;race.running=true
 for rider in race.riders:rider.set_physics_process(false)
 race.player.velocity=Vector2.RIGHT*260.;race.player.try_capture(race.player.position)
 race._physics_process(0.)
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/race222-parado-960.png")
 print("STOP220 timer=",race.player.slow_left," speed=",race.player.velocity.length()," guidance=",race.guidance.text)
 race.player.slow_left=0.;race._physics_process(0.)
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/race222-limpio-960.png")
 race.free();get_tree().quit()
