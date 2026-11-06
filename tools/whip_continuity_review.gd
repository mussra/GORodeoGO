extends SceneTree
var level:Node
var frame:=0
var title:Label
var old_progress:int
var old_intro:bool
var old_owned:Array[String]
var old_equipped:Dictionary
var finishing_samples:Array=[]
func _initialize()->void:call_deferred("setup")
func touch(pressed:bool,pos:Vector2)->void:
 var e:=InputEventScreenTouch.new();e.index=0;e.pressed=pressed;e.position=pos;Input.parse_input_event(e)
func drag(pos:Vector2,relative:Vector2)->void:
 var e:=InputEventScreenDrag.new();e.index=0;e.position=pos;e.relative=relative;Input.parse_input_event(e)
func setup()->void:
 old_progress=root.get_node("SaveData").highest_level_completed
 old_owned=root.get_node("SaveData").equipment_owned.duplicate()
 old_equipped=root.get_node("SaveData").equipment_equipped.duplicate()
 root.get_node("SaveData").equipment_owned.append("whip_basic")
 root.get_node("SaveData").equipment_equipped={"whip":"whip_basic"}
 old_intro=root.get_node("SaveData").dual_lasso_intro_shown
 root.get_node("SaveData").highest_level_completed=10
 root.get_node("SaveData").dual_lasso_intro_shown=true
 root.get_node("GameState").selected_level=3
 level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
 await physics_frame
 for b in level._active_bulls:b.set_physics_process(false)
 level.player.global_position=Vector2(-210,140)
 var layer:=CanvasLayer.new();layer.layer=25;root.add_child(layer)
 title=Label.new();title.position=Vector2(30,75);title.add_theme_font_size_override("font_size",21);layer.add_child(title)
 AudioServer.set_bus_mute(0,true)
func _process(_d:float)->bool:
 if level==null or title==null:return false
 frame+=1
 title.text="Fusta conseguida · joystick nativo · doble toque y trazo"
 if frame==20:touch(true,Vector2(150,450))
 if frame==22:touch(false,Vector2(150,450))
 if frame==24:touch(true,Vector2(150,450))
 if frame==27:drag(Vector2(180,420),Vector2(30,-30))
 if frame==30:drag(Vector2(220,450),Vector2(40,30))
 if frame==33:drag(Vector2(255,420),Vector2(35,-30))
 if frame==36:touch(false,Vector2(255,420))
 if frame>36 and frame<100:
  title.text="Al soltar: termina el regate y sigue corriendo sin parón"
  finishing_samples.append({"frame":frame,"path":level.player._dodge_path.size(),"speed":level.player.velocity.length(),"position":str(level.player.global_position)})
 if frame==65:call_deferred("shot","/downloads/gorodeo/whip-continuity.png")
 if frame==95:touch(true,Vector2(160,440))
 if frame==98:drag(Vector2(160,510),Vector2(0,70))
 if frame>=95:title.text="El joystick retoma el control · al soltar vuelve a parar normalmente"
 if frame==118:touch(false,Vector2(160,510))
 if frame==145:call_deferred("shot","/downloads/gorodeo/whip-joystick.png")
 if frame>=180:
  print("WHIP_NATIVE_SAMPLES ",JSON.stringify(finishing_samples))
  root.get_node("SaveData").highest_level_completed=old_progress
  root.get_node("SaveData").equipment_owned=old_owned
  root.get_node("SaveData").equipment_equipped=old_equipped
  root.get_node("SaveData").dual_lasso_intro_shown=old_intro
  quit()
 return false
func shot(path:String)->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
