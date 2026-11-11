extends Node2D
var age:float=0
var wall:float=0
var rider:Node2D
var pig:Node2D
var goat:Node2D
var caption:Label
var launched:bool=false
var phase:int=-1
func label(text:String,pos:Vector2,size:int=24)->Label:
 var l=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",size);add_child(l);return l
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection.seed_trial()
 label("PRUEBA CONTROLADA · lazo + energía · sin APK",Vector2(25,20),27)
 caption=label("",Vector2(25,65))
 rider=load("res://src/Presentation/world_player.gd").new();add_child(rider);rider.set_physics_process(false);rider.set_process(false)
 rider.lasso.throw_guard=func():return true
 rider.lasso.prey_provider=func():return [pig]
 rider.lasso.prey_captured.connect(func(_p):pig.roped=true)
 pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2(320,280)});add_child(pig)
 goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2(900,530)});add_child(goat)
 label("Energía: huida libre → enlazado → escape y recuperación",Vector2(25,400),25)
 label("Cerdo",Vector2(570,590));label("Cabra",Vector2(860,590))
func _process(delta:float):
 wall+=delta/maxf(Engine.time_scale,.01)
 var next=0 if wall<3 else 1
 if next!=phase:
  phase=next;age=0;launched=false;Engine.time_scale=1.0 if phase==0 else .24
  rider.global_position=Vector2(130,280);rider.velocity=Vector2(260,0);pig.position=Vector2(230,280);pig.roped=false
  caption.text="Normal: velocidad caballo + lanzamiento" if phase==0 else "Tiempo bala 0,24: la misma suma, sin dividir otra vez por el tiempo"
 age+=delta
 rider.position.x+=260*delta;pig.position.x+=225*delta
 rider._update_animation(delta);pig.state.flee=true;pig.movement=Vector2.RIGHT
 if not launched:
  launched=true;rider.lasso._charge_distance=72;rider.lasso.aim_direction=Vector2.RIGHT;rider.lasso._release_throw()
 # Lower row uses shared energy rules with controlled elapsed time.
 var energy_time=wall
 var state=WorldPigs.new_chase_state();var gs=WorldGoats.new_state()
 for i in int(energy_time*10):
  var rope=i>=30 and i<65
  state=WorldPigs.chase_tick(state,100,260,rope,.1);gs=WorldGoats.tick(gs,100,rope,.1)
 goat.state=gs
 queue_redraw()
 if wall>9:
  Engine.time_scale=1;get_viewport().get_texture().get_image().save_png("/downloads/gameplay-fixes83.png");get_tree().quit()
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("163139"))
 if not is_instance_valid(goat):return
 var state=WorldPigs.new_chase_state()
 for i in int(wall*10):state=WorldPigs.chase_tick(state,100,260,i>=30 and i<65,.1)
 var p=Vector2(620,530)
 var tex=load("res://art/experimental/pixellab/pig/side/frame_%02d.png"%int(fmod(wall*5,9)))
 draw_texture_rect(tex,Rect2(p-Vector2(48,43.2),Vector2(96,86.4)),false)
 draw_line(p+Vector2(-30,-85),p+Vector2(30,-85),Color("10252d"),12)
 draw_line(p+Vector2(-30,-85),p+Vector2(-30+60*AnimalFatigue.energy(state),-85),Color("8ed5a5"),8)
 var name="Huida libre: energía llena" if wall<3 else ("Enlazados: gastan energía" if wall<6.5 else "Liberados: recuperan desde el primer tick")
 draw_string(ThemeDB.fallback_font,Vector2(35,650),name,HORIZONTAL_ALIGNMENT_LEFT,-1,25,Color.WHITE)
