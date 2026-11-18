extends Node
func _ready():run.call_deferred()
func shot(name_:String):
 for i in 10:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/305-'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1600,900);TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://qa305scratch.cfg';SaveData._load_valid=true;SaveData.trial_session_active=true;SaveData.dual_lasso_intro_shown=true;SaveData.horse_collection.seed_trial();GameState.selected_level=5
 var level=load('res://src/Presentation/level_0.tscn').instantiate();add_child(level)
 await get_tree().create_timer(.5).timeout
 level.set_process(false);level.player.set_physics_process(false)
 for b in level._active_bulls:b.set_physics_process(false);b.global_position=Vector2(260,150)
 var bull=level._active_bulls[0];var held=level._active_bulls[1]
 held.global_position=level.pen.global_position+Vector2(15,70);held.try_capture(held.global_position)
 bull.set_is_chaser(true)
 var overlay:=CanvasLayer.new();add_child(overlay)
 var note:=Label.new();note.position=Vector2(650,255);note.add_theme_font_size_override('font_size',22);overlay.add_child(note);ToastStack.backdrop(note)
 var rider:Vector2=level.pen.global_position+Vector2(35,0)
 level.player.global_position=rider;bull.global_position=rider+Vector2(43,0);bull._touching_player=false;bull._touch_grace_remaining=0.;bull._check_player_contact()
 assert(level.player._stun_time_remaining==0. and held.controller.is_held())
 note.text='QA 3.0.5 · DENTRO DEL RANCHO\nContacto a través del límite:\nsin golpe y sin soltar captura.'
 await shot('dentro')
 for i in 90:bull._physics_process(1./60.)
 assert(not bull.pen_rect.grow(bull.RANCH_MARGIN305).has_point(bull.global_position))
 note.text='QA 3.0.5 · RANCHO SEGURO\nEl perseguidor se retira: margen de 100 px.\nDentro no se acerca, no golpea ni sueltas captura.'
 await shot('distancia')
 level.player.global_position=level.pen.global_position+Vector2(55,0);bull.global_position=level.player.global_position+Vector2(43,0);bull._check_player_contact()
 assert(level.player._stun_time_remaining>0. and not held.controller.is_held())
 note.text='QA 3.0.5 · FUERA DEL RANCHO\nMismo contacto: aturdimiento\ny captura soltada (regla anterior).'
 await shot('fuera');level.free();get_tree().quit()
