extends Node
var race:Node
var auto:bool=false
var jumped:bool=false
var snapped:bool=false
func shot(id:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/race190-"+id+".png")
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");SaveData.save_path="user://racefence190.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 for capability in [false,true]:
  SaveData.horse_collection.find(SaveData.horse_collection.selected).can_jump=capability
  for index in 3:
   RaceCourse190.selected=index;race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);race.selector.hide();race.countdown=0.;race.running=true
   jumped=false;snapped=false;auto=true;Engine.time_scale=6.
   var seconds:float=0.
   while race.player.finish_time<0. and seconds<100.:
    await get_tree().physics_frame;seconds+=get_physics_process_delta_time()
   Engine.time_scale=1.;auto=false
   print("FENCE_QA course=",index," jumper=",capability," gates=",race.player.next_gate," time=",race.player.finish_time," jumped=",jumped)
   if index==2:await shot("course3-"+("jumper" if capability else "bypass"))
   race.free();await get_tree().process_frame
 RaceCourse190.selected=0;get_tree().quit()
func _physics_process(_delta):
 if not auto or not is_instance_valid(race) or not race.running:return
 var p=race.player;var projection=race.course.project(p.position);var lane:float=race.course.ai_lane(projection.s,-80.,p.can_jump)
 var goal:Vector2=race.course.at(projection.s+100.)+race.course.tangent(projection.s).orthogonal()*lane
 var wish:Vector2=(goal-p.position).normalized()
 for pair in [["move_right",maxf(wish.x,0.)],["move_left",maxf(-wish.x,0.)],["move_down",maxf(wish.y,0.)],["move_up",maxf(-wish.y,0.)]]:
  if pair[1]>.001:Input.action_press(pair[0],pair[1])
  else:Input.action_release(pair[0])
 if p._jump_time>0.:
  jumped=true
  if not snapped and p._jump_time<.45:
   snapped=true;call_deferred("shot","jump-course%d"%race.course.variant)
