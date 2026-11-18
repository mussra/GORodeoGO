extends Node
var pref_exists:bool
var pref_bytes:PackedByteArray
func _ready():run.call_deferred()
func shot(label_:String):
 await get_tree().create_timer(.2).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/qa258-"+label_+".png")
func touch(p:Vector2,down:bool,index:int=0):
 var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=index;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2,index:int=0):
 var e:=InputEventScreenDrag.new();e.position=get_viewport().get_final_transform()*p;e.index=index;Input.parse_input_event(e);Input.flush_buffered_events()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;GameState.brand_intro_played=true
 pref_exists=FileAccess.file_exists(GameState.CONTROL_PREF258)
 if pref_exists:pref_bytes=FileAccess.get_file_as_bytes(GameState.CONTROL_PREF258)
 assert(GameState.set_movement258(true))
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await get_tree().create_timer(.3).timeout;menu._show_settings();await shot("settings")
 var pick:OptionButton=menu.find_child("MovementMode258",true,false);pick.show_popup();await shot("choices");pick.get_popup().hide();menu.free()
 var host:=Node2D.new();host.set_script(load("res://tests/integration/touch_host224.gd"));add_child(host);await get_tree().create_timer(.2).timeout
 touch(Vector2(180,400),true);await get_tree().process_frame;drag(Vector2(500,400));await shot("anchored-far")
 drag(Vector2(220,400));await shot("anchored-back");assert(Input.get_action_strength("move_right")>.1)
 touch(Vector2(900,400),true,1);await get_tree().process_frame;drag(Vector2(980,400),1);await shot("two-fingers");assert(host.player.lasso.is_charging())
 touch(Vector2(980,400),false,1);touch(Vector2(220,400),false);await get_tree().process_frame
 host.free()
 if pref_exists:
  var f:=FileAccess.open(GameState.CONTROL_PREF258,FileAccess.WRITE);f.store_buffer(pref_bytes);f.close()
 else:DirAccess.remove_absolute(GameState.CONTROL_PREF258)
 get_tree().quit()
