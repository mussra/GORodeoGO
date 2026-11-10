extends Node
var pig
var clock:float=0
func _ready()->void:call_deferred("run")
func _process(delta:float)->void:
 clock+=delta
 if is_instance_valid(pig):pig.update_state(true,false,int(clock)%4>=2,Vector2.RIGHT)
func run()->void:
 get_tree().root.size=Vector2i(1280,720)
 var bg=ColorRect.new();bg.color=Color("dfd8c8");bg.size=Vector2(1280,720);add_child(bg)
 var label=Label.new();label.position=Vector2(55,25);label.add_theme_font_size_override("font_size",27);label.add_theme_color_override("font_color",Color("302820"));label.text="2.7.66 - Cerdo PixelLab lateral 9 frames / cabra actual sin cambios";add_child(label)
 PixelLabTrial.initialized=true;PixelLabTrial.pig_enabled=true
 pig=load("res://src/Presentation/wild_pig_art.gd").new();add_child(pig);pig.position=Vector2(360,340);pig.scale=Vector2.ONE*2
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2(940,400)});add_child(goat);goat.goat_art.scale=Vector2.ONE*1.5;goat.movement=Vector2.RIGHT
 var note=Label.new();note.position=Vector2(70,570);note.add_theme_font_size_override("font_size",25);note.add_theme_color_override("font_color",Color("302820"));note.text="Arriba/abajo del cerdo: arte anterior. Izquierda: espejo.\nAjustes: Cerdo PixelLab ON/OFF. Lógica de captura sin cambios.";add_child(note)
 await get_tree().create_timer(1).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/pig2766.png")
 await get_tree().create_timer(4).timeout
 print("PIG66_QA run9=",pig.sprite_frames.get_frame_count("run")," up12=",pig.sprite_frames.get_frame_count("run_up")," goat10=",goat.goat_art.sprite_frames.get_frame_count("right"))
 get_tree().quit()
