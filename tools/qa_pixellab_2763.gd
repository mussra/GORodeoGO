extends Node
var world
var title:Label
var horse
var elapsed:float=0
func _ready()->void:call_deferred("run")
func _physics_process(delta:float)->void:
 if not is_instance_valid(horse):return
 elapsed+=delta
 var directions:Array=[Vector2.RIGHT,Vector2.DOWN,Vector2.UP,Vector2(1,1),Vector2(1,-1),Vector2.LEFT]
 var names:Array=["side","down","up","diag_down","diag_up","side"]
 var index:int=mini(5,int(elapsed/1.1))
 var direction:Vector2=directions[index].normalized()
 world.player._sprite_swap.set_flip_h(index==5)
 world.player._sprite_swap.play("walk_"+names[index])
 world.player._sprite_swap.set_motion_speed(200,200)
 horse._art.flip_h=index==5;horse._art.set_walk_direction(direction)
 title.text="PixelLab · 5 vistas · "+names[index]+" · sin máscaras"
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)

 SaveData.save_path="user://qa-pixellab61.dat";SaveData.world_seed=7781;SaveData.world_edits=[];SaveData.world_position=Vector2(-360,400)
 SaveData.world_tamed=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 world._toasts.clear();world._toasts.column.visible=false
 for h in world._herd_horses.values():
  if is_instance_valid(h):h.queue_free()
 world._herd_horses.clear()
 horse=world.WildHorseScript.new();horse.setup({"pos":Vector2(-200,410),"traits":{"coat":12,"pattern":2,"mane":0,"spots":5,"finish":"matte"}});world.add_child(horse);horse.set_physics_process(false)
 var layer:=CanvasLayer.new();layer.layer=90;add_child(layer)
 title=Label.new();title.position=Vector2(180,55);title.add_theme_font_size_override("font_size",24);title.text="PixelLab experimental · lateral y pelaje fijo · 9 frames";layer.add_child(title)
 await get_tree().create_timer(1.8).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/pixellab2763.png")
 await get_tree().create_timer(4.8).timeout
 print("PIXELLAB_QA: rider9=",world.player._sprite_swap._frames.get_frame_count("walk_side")," horse9=",horse._art.sprite_frames.get_frame_count("walk"))
 get_tree().quit()
