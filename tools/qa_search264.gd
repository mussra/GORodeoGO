extends Node
func _ready():run.call_deferred()
func click_at(p:Vector2):
 for down in [true,false]:
  var e:=InputEventMouseButton.new();e.position=p;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events();await get_tree().process_frame
func shot(label_:String):
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/search264-"+label_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;SaveData.save_path="user://qa264scratch.cfg";SaveData.interior_search264={}
 var room:=FloristRoom262.new();add_child(room);await get_tree().create_timer(.15).timeout
 for i in 4:await click_at(Vector2(560,450))
 assert(room.message.text==InteriorSearch264.EMPTY_HINT);await shot("empty-four")
 await click_at(Vector2(612,250));assert(room.message.text.contains("Le mostraré"));await shot("found")
 for i in 4:await click_at(Vector2(612,250))
 assert(room.message.text==InteriorSearch264.EXHAUSTED_HINT);await shot("exhausted")
 await click_at(Vector2(380,676));assert(is_instance_valid(room.exit_dialog264));await shot("exit-dialog")
 room.exit_dialog264.closed.emit();await get_tree().process_frame
 var workshop:=SaddleryRoom256.new();add_child(workshop);await get_tree().create_timer(.1).timeout
 await click_at(Vector2(370,280));assert(workshop.message.text.contains("Juanito"));await shot("juanito-found")
 workshop.finish();assert(is_instance_valid(workshop.exit_dialog264));await shot("juanito-exit");workshop.exit_dialog264.closed.emit();await get_tree().process_frame
 print("SEARCH264_GUI pass: empty4, found silent-empty, exhausted4, exit conversation, workshop same flow")
 get_tree().quit()
