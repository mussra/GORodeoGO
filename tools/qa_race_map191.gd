extends Node
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/race191-"+id+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_path="user://race-map191-no-save.dat"
 for index in range(RaceCourse190.TITLES.size()):
  RaceCourse190.selected=index
  var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);await shot("selector%d"%index);race.selector.hide();race.countdown=3.
  race.player.route_s=race.course.length*.25-160.;race.player.next_gate=4
  race.player.position=race.course.at(race.player.route_s);race.player.previous_position=race.player.position
  race.camera.reset_smoothing()
  await shot("fence-course%d"%index)
  race.map_view.toggle();await shot("map-course%d"%index);race.map_view.toggle()
  if index==3:
   race.running=true
   race.player.position=Vector2(-10,0);race.player.route_s=race.course.length*.25
   race.riders[1].position=Vector2(15,0);race.riders[1].route_s=race.course.length*.75
   race.player.velocity=Vector2(260,0);race.riders[1].velocity=Vector2(30,0)
   race._crossing_contacts192();race.running=false;race.camera.reset_smoothing()
   await shot("crossing-contact")
  race.free();await get_tree().process_frame
 RaceCourse190.selected=0;get_tree().quit()
