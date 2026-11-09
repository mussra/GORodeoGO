extends Node2D
var sprites:Array=[]
var directions:Array=["right","left","down","up"]
var label:Label
var elapsed:float=0.0
var last_dir:int=-1
func text(value:String,pos:Vector2,size:int)->Label:
 var n:=Label.new();n.text=value;n.position=pos;n.add_theme_font_size_override("font_size",size);add_child(n);return n
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720)
 var bg:=ColorRect.new();bg.color=Color("2e5d33");bg.size=Vector2(1280,720);add_child(bg)
 text("Cabra: comparación de las dos hojas de Ant",Vector2(50,25),30)
 text("A · Hoja anterior · 12 fotogramas",Vector2(80,100),25)
 text("B · Hoja nueva · 10 fotogramas",Vector2(700,100),25)
 text("Ciclo igualado a 1 segundo en ambas · mismo tamaño y apoyo de patas",Vector2(50,650),22)
 text("Detalle ampliado",Vector2(50,160),20)
 text("Escala actual del mundo (0,40×)",Vector2(50,520),20)
 label=text("",Vector2(520,175),24)
 for version in 2:
  var f:=SpriteFrames.new()
  for view in directions:
   f.add_animation(view);f.set_animation_speed(view,12 if version==0 else 10)
   for i in (12 if version==0 else 10):
    f.add_frame(view,load("res://art/world/goats/%s%s/frame_%02d.png"%["" if version==0 else "compare10/",view,i]))
  for size in [1.9,.4]:
   var n:=AnimatedSprite2D.new();n.sprite_frames=f;n.centered=false;n.offset=Vector2(-80,-144);n.scale=Vector2.ONE*size
   n.position=Vector2(340+version*600,500 if size>1 else 610);n.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;add_child(n);sprites.append(n)
func _process(delta:float)->void:
 elapsed+=delta
 var d:int=mini(3,int(elapsed/3.0))
 if d!=last_dir:
  last_dir=d;label.text=["Derecha","Izquierda","Frente","Espalda"][d]
  for n in sprites:n.play(directions[d])
 if elapsed>=12:
  get_viewport().get_texture().get_image().save_png("/downloads/goatcompare2759-still.png")
  get_tree().quit()
