extends Node
var world
var title:Label
var horse
var elapsed:float=0
func _ready()->void:call_deferred("run")
func _physics_process(delta:float)->void:
 if not is_instance_valid(horse):return
 elapsed+=delta
 var right:bool=elapsed<2.3 or elapsed>4.6
 var direction:=Vector2.RIGHT if right else Vector2.LEFT
 world.player.velocity=direction*180
 world.player.position+=direction*delta*110
 world.player._sprite_swap.set_flip_h(not right)
 world.player._sprite_swap.play("walk_side")
 horse._art.flip_h=not right;horse._art.set_walk_direction(direction)
 horse.position+=direction*delta*110
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
 horse=world.WildHorseScript.new();horse.setup({"pos":Vector2(-210,500),"traits":{"coat":12,"pattern":2,"mane":0,"spots":5,"finish":"matte"}});world.add_child(horse);horse.set_physics_process(false)
 var layer:=CanvasLayer.new();layer.layer=90;add_child(layer)
 title=Label.new();title.position=Vector2(180,55);title.add_theme_font_size_override("font_size",24);title.text="PixelLab experimental · lateral y pelaje fijo · 9 frames";layer.add_child(title)
 await get_tree().create_timer(1.3).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/pixellab2761.png")
 await get_tree().create_timer(4.8).timeout
 print("PIXELLAB_QA: rider9=",world.player._sprite_swap._frames.get_frame_count("walk_side")," horse9=",horse._art.sprite_frames.get_frame_count("walk"))
 get_tree().quit()
