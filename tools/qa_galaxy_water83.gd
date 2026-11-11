extends Node2D
var age:float=0
var rider
var caption:Label
var phase:int=-1
func register_occluder(_a,_b):pass
func _ready():
 get_tree().root.size=Vector2i(1280,720);y_sort_enabled=true;SaveData.horse_collection.seed_trial();SaveData.hat_color="blue"
 var h=SaveData.horse_collection.find(SaveData.horse_collection.selected);h.traits.finish="galaxy"
 h["completed_levels"]=[]
 for n in range(1,21):h.completed_levels.append(n)
 var ground=ColorRect.new();ground.position=Vector2(-1000,-1000);ground.size=Vector2(3000,3000);ground.color=Color("32653a");ground.z_index=-20;add_child(ground)
 var ranch=load("res://src/Presentation/world_ranch.gd").new();add_child(ranch)
 rider=load("res://src/Presentation/world_player.gd").new();add_child(rider);rider.position=Vector2(428,224);rider.set_physics_process(false)
 var camera=Camera2D.new();camera.position=Vector2(480,200);camera.zoom=Vector2(2.8,2.8);add_child(camera)
 var ui=CanvasLayer.new();add_child(ui);var bg=ColorRect.new();bg.size=Vector2(1280,100);bg.color=Color("163139");ui.add_child(bg)
 caption=Label.new();caption.position=Vector2(22,16);caption.add_theme_font_size_override("font_size",24);ui.add_child(caption)
 var note=Label.new();note.position=Vector2(22,58);note.text="Automático al parar · movimiento cancela · sin bonificación de energía · sin APK";note.add_theme_font_size_override("font_size",20);ui.add_child(note)
func _physics_process(delta):
 age+=delta
 if age<1.5:
  caption.text="Galaxy maestro · montura real del corral"
  if age>1 and phase==-1:phase=-2;get_viewport().get_texture().get_image().save_png("/downloads/galaxy-world-rider83.png")
  rider.velocity=Vector2.RIGHT*90;rider.move_and_slide();rider._update_animation(delta)
 elif age<6:
  caption.text="Al soltar movimiento: se para y bebe (máscaras de Ant + sombrero azul)"
  rider.velocity=Vector2.ZERO;rider.drink.step(delta,Vector2.ZERO)
  if age>4 and phase==-2:phase=0;get_viewport().get_texture().get_image().save_png("/downloads/galaxy-world-drink83.png")
 else:
  caption.text="Moverse interrumpe y devuelve el control inmediatamente"
  rider.drink.step(delta,Vector2.LEFT);rider.velocity=Vector2.LEFT*36;rider.move_and_slide();rider._update_animation(delta)
 if age>8:get_tree().quit()
