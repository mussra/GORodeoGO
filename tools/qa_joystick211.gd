extends Node
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var scene=load("res://src/Presentation/jump_memory207.tscn").instantiate();add_child(scene)
 for i in 4:await get_tree().physics_frame
 scene.model.sequence.assign([0,1]);scene.model.begin_input();scene._refresh();scene.set_physics_process(false)
 var origin:=Vector2(180,470);var dest:=origin+Vector2(55,-15)
 var press:=InputEventScreenTouch.new();press.index=1;press.position=get_viewport().get_final_transform()*origin;press.pressed=true;Input.parse_input_event(press);Input.flush_buffered_events()
 var drag:=InputEventScreenDrag.new();drag.index=1;drag.position=get_viewport().get_final_transform()*dest;Input.parse_input_event(drag);Input.flush_buffered_events()
 for i in 3:await get_tree().physics_frame
 var overlay:=CanvasLayer.new();overlay.layer=70;add_child(overlay)
 var marker:=Node2D.new();overlay.add_child(marker)
 marker.draw.connect(func():
  marker.draw_circle(origin,4.,Color("e8ffff"));marker.draw_circle(dest,5.,Color("89ffe6"))
  marker.draw_string(ThemeDB.fallback_font,Vector2(28,614),"Punto blanco: inicio del toque | Punto verde: dedo al arrastrar",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color.WHITE))
 marker.queue_redraw();await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/joystick211-memoria.png")
 print("ORIGIN211 actual input=",Input.get_vector("move_left","move_right","move_up","move_down")," origin=",origin," finger=",dest)
 var release:=InputEventScreenTouch.new();release.index=1;release.pressed=false;release.position=drag.position;Input.parse_input_event(release);Input.flush_buffered_events()
 await get_tree().process_frame;scene.free();get_tree().quit()
