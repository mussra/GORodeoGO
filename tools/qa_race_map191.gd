extends Node
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/race191-"+id+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_path="user://race-map191-no-save.dat"
 for index in 3:
  RaceCourse190.selected=index
  var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);race.selector.hide();race.countdown=3.
  race.player.position=race.course.at(race.course.fences[0]-110.)
  race.camera.reset_smoothing()
  await shot("fence-course%d"%index)
  race.map_view.toggle();await shot("map-course%d"%index);race.map_view.toggle()
  race.free();await get_tree().process_frame
 RaceCourse190.selected=0;get_tree().quit()
