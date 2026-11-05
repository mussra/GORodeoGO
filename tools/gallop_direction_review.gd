extends SceneTree
var frame:=0
var sprites:Array=[]
var dirs=[Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]
func _initialize()->void:call_deferred("setup")
func setup()->void:
 var stage:=Node2D.new();root.add_child(stage)
 var bg:=ColorRect.new();bg.color=Color("315558");bg.size=Vector2(1280,720);stage.add_child(bg)
 var title:=Label.new();title.text="Rancho Prueba 0.21.28 · Galope en ocho direcciones";title.position=Vector2(40,20);title.add_theme_font_size_override("font_size",28);stage.add_child(title)
 for i in range(8):
  var host:=Node2D.new();stage.add_child(host);host.position=Vector2(160+(i%4)*320,220+(i/4)*320)
  var placeholder:=Polygon2D.new();host.add_child(placeholder)
  var swap:=SpriteSwap.new(host,placeholder,"res://art/player/",["walk_side","walk_down","walk_up","walk_diag_down","walk_diag_up"],8)
  var direction=SpriteSwap.direction_suffix(dirs[i]);swap.play("walk_"+direction[0]);swap.set_flip_h(direction[1]);swap._sprite.scale=Vector2(2.6,2.6);sprites.append(swap)
  var label:=Label.new();label.text=["E","SE","S","SO","O","NO","N","NE"][i];label.position=host.position+Vector2(-15,125);stage.add_child(label)
 AudioServer.set_bus_mute(0,true)
func _process(_d:float)->bool:
 frame+=1
 if frame==120:call_deferred("shot")
 if frame>=360:quit()
 return false
func shot()->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/gorodeo/gallop-eight-runtime.png")
