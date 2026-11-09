extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1600,720)
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate()
 get_tree().root.add_child(world)
 await get_tree().create_timer(.4).timeout
 world._toast("Ups... parece que tendremos que cambiar de estrategia.")
 world._toast("Caballo cansado. Déjalo descansar para recuperar resistencia.")
 world._toast("Cerdo capturado. Ya está a salvo en el rancho.")
 await get_tree().create_timer(.5).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/toasts2743-mundo.png")
 world.queue_free()
 await get_tree().create_timer(.2).timeout
 var level=load("res://src/Presentation/level_0.tscn").instantiate();get_tree().root.add_child(level)
 await get_tree().create_timer(.3).timeout
 var hud=level.hud
 hud.flash_hint("Sin hueco: doble toque en el lazo para soltar un toro antes de lanzar",1.8)
 hud.flash_hint("Otro aviso permanece visible al mismo tiempo.",1.8)
 await get_tree().create_timer(.4).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/toasts2743-nivel.png")
 get_tree().quit()
