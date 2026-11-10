extends Node
var elapsed:float=0
var riders:Array=[]
var wilds:Array=[]
var bull
func label_at(text:String,pos:Vector2,size:int=23)->void:
 var label=Label.new();label.text=text;label.position=pos;label.add_theme_font_size_override("font_size",size);label.add_theme_color_override("font_color",Color("fff0d0"));add_child(label)
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720);var bg=ColorRect.new();bg.color=Color("17343a");bg.size=Vector2(1280,720);add_child(bg)
 label_at("Paso / galope: prueba de ritmo, no dos ciclos anatómicos nuevos",Vector2(25,20),27)
 label_at("PASO · lento y sin rebote añadido",Vector2(25,85));label_at("GALOPE · mismo ciclo, más rápido y con balanceo",Vector2(580,85))
 for i in 2:
  var host=Node2D.new();host.position=Vector2(220+i*610,265);add_child(host)
  var placeholder=Polygon2D.new();host.add_child(placeholder)
  var frames=SpriteFrames.new();PixelLabTrial.apply(frames,"rider","walk_side")
  var swap=SpriteSwap.from_frames(host,placeholder,frames);swap._sprite.scale=Vector2.ONE*1.8;riders.append(swap)
  var art=load("res://src/Presentation/wild_horse_art.gd").new();art.position=Vector2(220+i*610,455);art.scale=Vector2.ONE*1.8;add_child(art);wilds.append(art)
 var host=Node2D.new();host.position=Vector2(260,590);add_child(host);var placeholder=Polygon2D.new();host.add_child(placeholder)
 bull=SpriteSwap.new(host,placeholder,"res://art/bull/",["idle","flee_side","flee_down","flee_up","flee_diag_up","flee_diag_down"]);PixelLabTrial.apply_bull(bull._frames);bull._sprite.scale=Vector2.ONE*1.3
 label_at("Toro: carrera PixelLab 9 fotogramas a 9 fps",Vector2(400,590),23)
 label_at("2.7.69: el toro corre al huir/embestir. Paso y galope auténticos requieren apoyos distintos.",Vector2(25,660),22)
func _process(delta:float)->void:
 elapsed+=delta
 for i in 2:
  var gait:int=WorldGait.PASO if i==0 else WorldGait.GALOPE
  var speed:float=117 if i==0 else 260
  RiderGaitVisual.apply(riders[i],Vector2(speed,0),260,gait,delta)
  wilds[i].speed_scale=.55 if i==0 else 1.55
 bull.play("flee_side");bull.set_motion_speed(180,180)
 if elapsed>4:
  get_viewport().get_texture().get_image().save_png("/downloads/gaits2770.png");get_tree().quit()
