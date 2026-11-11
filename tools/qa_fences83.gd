extends Node2D
var age:float=0
var actor
var goat
var phase:int=-1
var label:Label
var fired:bool=false
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection.seed_trial();y_sort_enabled=true
 var bg=ColorRect.new();bg.position=Vector2(-2000,-2000);bg.size=Vector2(4000,4000);bg.color=Color("32653a");bg.z_index=-20;add_child(bg)
 WorldFence.segment(self,Vector2(130,320),Vector2(600,320));WorldFence.segment(self,Vector2(650,230),Vector2(1030,420))
 actor=load("res://src/Presentation/world_player.gd").new();add_child(actor);actor.set_physics_process(false)
 goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2(850,480)});add_child(goat)
 var ui=CanvasLayer.new();add_child(ui);label=Label.new();label.position=Vector2(22,20);label.add_theme_font_size_override("font_size",24);ui.add_child(label)
 var note=Label.new();note.position=Vector2(22,61);note.text="Prueba controlada con colisión/salto reales · sin APK";note.add_theme_font_size_override("font_size",20);ui.add_child(note)
func _physics_process(delta):
 age+=delta
 var next=0 if age<3 else (1 if age<6 else 2)
 if next!=phase:
  phase=next;actor.position=Vector2(380,405);actor.velocity=Vector2.ZERO;actor._jump_cooldown=0;fired=false
  if phase==2:actor.position=Vector2(750,420)
 if phase==0:
  label.text="Sin habilidad: la valla continua lo detiene entre los postes"
  actor.can_jump=false;actor.velocity=Vector2.UP*100;actor.move_and_slide();actor._update_animation(delta)
 elif phase==1:
  label.text="Con habilidad: mismo salto del corral, aterrizaje comprobado"
  actor.can_jump=true
  if not fired:fired=true;actor.request_jump(Vector2.UP)
  if actor._jump_time>0:HorseJumpMotion.process(actor,delta)
 else:
  label.text="Cabra: salta la valla. Profundidad local en tramo inclinado."
  goat.move_from_or_towards(Vector2(850,900),delta,false)
  actor.velocity=Vector2.UP*25;actor.move_and_slide();actor._update_animation(delta)
 if age>4.25 and age<4.3:get_viewport().get_texture().get_image().save_png("/downloads/fence-jump83.png")
 if age>9:get_tree().quit()
