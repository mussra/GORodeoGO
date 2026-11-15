extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/identity223-"+id+"-960.png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540);GameState.brand_intro_played=true
 SaveData.save_path="user://identity223-no-write.cfg";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);menu._show_games213();await get_tree().create_timer(.3).timeout;await shot("games");menu.free()
 for mode in ["duel193","joust196","race190","jump_memory207","level_0"]:
  var scene=load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(scene)
  await get_tree().create_timer(.2).timeout
  if mode in ["duel193","joust196"]:
   scene.countdown=0.;scene.running=true;scene.set_physics_process(false)
   for rider in scene.riders:rider.set_physics_process(false)
   scene.player.position=Vector2(-100,-45 if mode=="joust196" else 0);scene.riders[1].position=Vector2(100,45 if mode=="joust196" else 0)
   scene._refresh()
  if mode=="race190":
   scene.selector.hide();scene.countdown=0.;scene.running=true;scene._physics_process(0.);scene.set_physics_process(false)
   for rider in scene.riders:rider.set_physics_process(false)
  await shot(mode)
  scene.free();await get_tree().process_frame
 get_tree().quit()
