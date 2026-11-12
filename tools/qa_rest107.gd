extends Node2D
var actor:Node2D
func _ready():run.call_deferred()
func capture(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/reposo107-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1100,680);RenderingServer.set_default_clear_color(Color("688966"))
 SaveData.horse_collection.seed_trial();SaveData.hat_color="blue"
 actor=load("res://src/Presentation/world_player.gd").new();add_child(actor);actor.position=Vector2(550,440);actor.set_physics_process(false)
 actor._sprite_swap._sprite.scale=Vector2.ONE*4.;actor._sprite_swap._sprite.offset.y=-44
 var title=Label.new();title.position=Vector2(40,30);title.add_theme_font_size_override("font_size",32);add_child(title)
 title.text="Reposo: patas apoyadas · sin cambiar la marcha"
 var swap:SpriteSwap=actor._sprite_swap;swap.rest107.wait=5.
 RiderGaitVisual.apply(swap,Vector2.ZERO,270,0,.1);await capture("apoyado")
 title.text="Gesto tras espera aleatoria de 5 a 10 segundos"
 swap.rest107.elapsed=swap.rest107.wait+1.;RiderGaitVisual.apply(swap,Vector2.ZERO,270,0,.01);await capture("gesto")
 title.text="Movimiento: se conserva la animación de marcha"
 RiderGaitVisual.apply(swap,Vector2(180,0),270,1,.1)
 await get_tree().create_timer(.35).timeout;await capture("marcha")
 get_tree().quit()
