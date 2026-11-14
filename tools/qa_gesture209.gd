extends Node
var race:Node
func touch(p:Vector2,down:bool):
 var e:=InputEventScreenTouch.new();e.index=1;e.position=p;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2):
 var e:=InputEventScreenDrag.new();e.index=1;e.position=p;Input.parse_input_event(e);Input.flush_buffered_events()
func shot(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/gesto209-"+name_+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://gesture209qa.cfg";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();RaceCourse190.selected=0;RaceCourse190.start_selected=true
 race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race)
 for i in 5:await get_tree().physics_frame
 race.countdown=0.;race.running=true;race._physics_process(0.);race.set_physics_process(false)
 for rider in race.riders:
  if rider!=race.player:rider.set_physics_process(false)
 var start:=Vector2(980,530);var map_point:Vector2=race.map_view.get_global_rect().get_center()
 touch(start,true);drag(start+Vector2(60,0));await get_tree().create_timer(.12).timeout
 drag(map_point);await get_tree().create_timer(.12).timeout
 await shot("apuntando")
 touch(map_point,false);await get_tree().create_timer(.06).timeout
 print("GESTURE209 active=",race.player.lasso._touch_aim_active," charging=",race.player.lasso.is_charging()," flight=",race.player.lasso.is_in_flight()," map=",race.map_view.expanded)
 await shot("suelto")
 race.free();get_tree().quit()
