extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/musician225-"+id+"-960.png")
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var world:=Node2D.new();world.y_sort_enabled=true;add_child(world)
 var bg:=Polygon2D.new();bg.polygon=PackedVector2Array([Vector2(-1000,-1000),Vector2(1000,-1000),Vector2(1000,1000),Vector2(-1000,1000)]);bg.color=Color("61904b");bg.z_index=-10;world.add_child(bg)
 var camera:=Camera2D.new();world.add_child(camera)
 var player=load("res://src/Presentation/world_player.gd").new();world.add_child(player);player.set_physics_process(false)
 var musician:=GanjoMusician205.new();world.add_child(musician)
 player.position=Vector2(15,20);await shot("rider-front")
 player.position=Vector2(15,-20);await shot("musician-front")
 world.free();get_tree().quit()
