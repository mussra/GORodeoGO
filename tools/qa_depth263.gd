extends Node2D
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);y_sort_enabled=true;GameState.sound_enabled=false;SaveData.horse_collection.seed_trial()
 var building:=SaddleryExterior256.new();add_child(building)
 var player=load("res://src/Presentation/world_player.gd").new();player.name="Rider";add_child(player);player.set_physics_process(false)
 var camera:=Camera2D.new();camera.position=building.DOOR+Vector2(0,-80);add_child(camera)
 for pair in [["front",Vector2(0,50)],["behind",Vector2(0,-90)],["threshold",Vector2(0,-15)]]:
  player.position=building.DOOR+pair[1];await get_tree().create_timer(.1).timeout;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/depth263-"+pair[0]+".png")
 player.free();get_tree().quit()
