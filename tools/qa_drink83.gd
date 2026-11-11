extends Node2D
var age:float=0
var rider:Node2D
var drinking:Sprite2D
var caption:Label
var snapped:bool=false
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection.seed_trial()
 var ground=ColorRect.new();ground.position=Vector2(-1000,-1000);ground.size=Vector2(3000,3000);ground.color=Color("32653a");ground.z_index=-20;add_child(ground)
 var ranch=load("res://src/Presentation/world_ranch.gd").new();add_child(ranch)
 rider=load("res://src/Presentation/world_player.gd").new();add_child(rider);rider.position=Vector2(350,190);rider.set_physics_process(false)
 var camera=Camera2D.new();camera.position=Vector2(430,200);camera.zoom=Vector2(2.1,2.1);add_child(camera)
 drinking=Sprite2D.new();drinking.texture=load("res://art/experimental/drink_preview83/pose_0.png");drinking.offset=Vector2(-8,-7.333);drinking.scale=Vector2.ONE*1.2;drinking.visible=false;rider.add_child(drinking)
 var ui=CanvasLayer.new();add_child(ui)
 var bar=ColorRect.new();bar.size=Vector2(1280,100);bar.color=Color("163139");ui.add_child(bar)
 caption=Label.new();caption.position=Vector2(22,18);caption.add_theme_font_size_override("font_size",25);ui.add_child(caption)
 var note=Label.new();note.position=Vector2(22,60);note.text="Preview con sus 2 poses · color original · sin máscaras ni frame intermedio · sin APK";note.add_theme_font_size_override("font_size",20);ui.add_child(note)
func register_occluder(_owner,_rect):pass
func _process(delta):
 age+=delta
 if age<2:
  caption.text="Se acerca al borde con el sprite actual"
  rider.position.x=350+age*44.5;rider.velocity=Vector2(27,0);rider._update_animation(delta)
 elif age<3:
  rider.velocity=Vector2.ZERO;rider._sprite_swap._sprite.visible=false;drinking.visible=true;rider.dodge_available=false;rider.queue_redraw()
  caption.text="Se para: pose nueva, pies fijos"
 elif age<7:
  drinking.texture=load("res://art/experimental/drink_preview83/pose_1.png")
  caption.text="Bebe: cabeza abajo, patas fijas junto al borde"
 elif age<8.5:
  drinking.texture=load("res://art/experimental/drink_preview83/pose_0.png")
  caption.text="Termina: levanta la cabeza"
 else:
  drinking.visible=false;rider._sprite_swap._sprite.visible=true;rider.velocity=Vector2(-20,0);rider.position.x-=delta*20;rider._update_animation(delta)
  caption.text="Vuelve al sprite normal. El cambio de diseño se ve al entrar y salir."
 if age>5 and not snapped:
  snapped=true;get_viewport().get_texture().get_image().save_png("/downloads/drink-pond83.png")
 if age>10:get_tree().quit()
