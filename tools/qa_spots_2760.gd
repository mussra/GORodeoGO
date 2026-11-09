extends Node2D
var old_sprite:AnimatedSprite2D
var new_sprite:AnimatedSprite2D
var small:Array=[]
var elapsed:float=0
var current_view:int=-1
var directions:Array=["side","diag_down","down","up","diag_up"]
var label:Label
func text(value:String,pos:Vector2,size:int)->Label:
 var n:=Label.new();n.text=value;n.position=pos;n.add_theme_font_size_override("font_size",size);add_child(n);return n
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720)
 var bg:=ColorRect.new();bg.color=Color("2e5d33");bg.size=Vector2(1280,720);add_child(bg)
 text("Manchas: patrón fijado al cuerpo, no al lienzo",Vector2(40,25),28)
 text("Antes · coordenadas del lienzo",Vector2(80,90),24)
 text("Después · cabeza, cuello y tronco",Vector2(700,90),24)
 text("Mismo caballo · mismo patrón · misma animación",Vector2(40,650),22)
 label=text("",Vector2(520,150),23)
 var old:=SpriteFrames.new();var fixed:=SpriteFrames.new()
 for view in directions:
  old.add_animation(view);fixed.add_animation(view)
  old.set_animation_speed(view,12);fixed.set_animation_speed(view,12)
  for i in 12:
   var img:Image=load("res://tools/fixtures/spot_baseline_2759/%s/frame_%02d.png"%[view,i]).get_image();old.add_frame(view,ImageTexture.create_from_image(img))
   var source:Texture2D=load("res://art/world/wild_base/walk_%s/frame_%02d.png"%[view,i])
   fixed.add_frame(view,HorseAppearance.texture(source,"wild_walk_"+view,i,{"coat":12,"pattern":2,"mane":0,"spots":5,"finish":"matte"}))
 for col in 2:
  for big in [true,false]:
   var sp:=AnimatedSprite2D.new();sp.sprite_frames=old if col==0 else fixed;sp.centered=false;sp.offset=Vector2(-48,-80)
   sp.position=Vector2(330+col*600,500 if big else 620);sp.scale=Vector2.ONE*(3.5 if big else 1.2);sp.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
   add_child(sp)
   if big:
    if col==0:old_sprite=sp
    else:new_sprite=sp
   else:small.append(sp)
func _process(delta:float)->void:
 elapsed+=delta
 var idx:int=mini(4,int(elapsed/2.0))
 if current_view!=idx:
  current_view=idx;label.text=["Lateral","Diagonal frontal","Frente","Espalda","Diagonal trasera"][idx]
  for sp in [old_sprite,new_sprite]+small:sp.play(directions[idx])
 if elapsed>=10:get_tree().quit()
