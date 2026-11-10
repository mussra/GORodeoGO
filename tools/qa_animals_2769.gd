extends Node
var elapsed:float=0
var pigs:Array=[]
var goats:Array=[]
var bulls:Array=[]
var title:Label
func _ready()->void:
 get_tree().root.size=Vector2i(1280,720);
 var bg=ColorRect.new();bg.color=Color("d8e0cb");bg.size=Vector2(1280,720);add_child(bg)
 title=Label.new();title.position=Vector2(25,10);title.add_theme_color_override("font_color",Color("251f21"));title.add_theme_font_size_override("font_size",24);add_child(title)
 var labels=["Derecha","Diagonal abajo","Abajo","Diagonal izq.","Izquierda","Diagonal arriba","Arriba","Diagonal der."]
 for i in 8:
  var label=Label.new();label.text=labels[i];label.position=Vector2(10+i*158,60);label.add_theme_color_override("font_color",Color("251f21"));add_child(label)
  var pig=WildPigArt.new();pig.position=Vector2(75+i*158,235);add_child(pig);pig.scale=Vector2.ONE*.72;pigs.append(pig)
  var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2(75+i*158,410)});add_child(goat);goat.set_process(false);goat.goat_art.scale=Vector2.ONE*.70;goats.append(goat)
  var host=Node2D.new();host.position=Vector2(75+i*158,510);add_child(host);var placeholder=Polygon2D.new();host.add_child(placeholder);var swap=SpriteSwap.new(host,placeholder,"res://art/bull/",["idle","flee_side","flee_down","flee_up","flee_diag_down","flee_diag_up"]);PixelLabTrial.apply_bull(swap._frames);swap._sprite.scale=Vector2.ONE*1.15;bulls.append(swap)
 var note=Label.new();note.position=Vector2(20,620);note.add_theme_color_override("font_color",Color("251f21"));note.text="Cerdo: lateral/frontal/trasera PixelLab. Diagonales: lateral. Idle/cansado: clásicos.\nCabra: lateral/frontal/trasera PixelLab. Diagonales: lateral.\nToro: 5 vistas reales; opuestas por espejo. Reposo/beber/captura: clásicos.";note.add_theme_font_size_override("font_size",20);add_child(note)
func _process(delta:float)->void:
 elapsed+=delta
 var dirs=[Vector2.RIGHT,Vector2(1,1),Vector2.DOWN,Vector2(-1,1),Vector2.LEFT,Vector2(-1,-1),Vector2.UP,Vector2(1,-1)]
 for i in pigs.size():
  pigs[i].update_state(true,false,dirs[i].x<0,dirs[i]);goats[i].movement=dirs[i];goats[i]._process(0)
  var facing=SpriteSwap.direction_suffix(dirs[i]);bulls[i].set_flip_h(facing[1]);bulls[i].play("flee_"+facing[0])
 title.text="2.7.69 · 8 direcciones · vistas reales y sustituciones indicadas"
 if elapsed>3.9:
  get_viewport().get_texture().get_image().save_png("/downloads/animals2769.png");get_tree().quit()
