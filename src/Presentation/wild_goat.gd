extends "res://src/Presentation/wild_pig.gd"
## Shares lasso target, release, rope and nonblocking Node2D with pigs.
const IS_GOAT:bool=true
static var frames_cache:SpriteFrames
var goat_art:AnimatedSprite2D
func setup(p_pen:Dictionary)->void:
 pen=p_pen;home=pen.get("pos",Vector2.ZERO);state=WorldGoats.new_state()
func _ready()->void:
 position=home
 if frames_cache==null:
  frames_cache=SpriteFrames.new()
  for view in ["right","left","down","up"]:
   frames_cache.add_animation(view);frames_cache.set_animation_speed(view,12.0)
   for i in 12:frames_cache.add_frame(view,load("res://art/world/goats/%s/frame_%02d.png"%[view,i]))
 goat_art=AnimatedSprite2D.new();goat_art.sprite_frames=frames_cache
 goat_art.centered=false;goat_art.offset=Vector2(-80,-144);goat_art.scale=Vector2.ONE*.40
 goat_art.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 add_child(goat_art);goat_art.play("right")
func _process(delta:float)->void:
 touch_grace=maxf(0,touch_grace-delta)
 if roped:held=maxf(0,held-delta)
 var view:String=("down" if movement.y>0 else "up") if absf(movement.y)>absf(movement.x)*1.2 else ("left" if movement.x<0 else "right")
 if goat_art.animation!=view:goat_art.play(view)
 goat_art.speed_scale=1.0 if movement.length_squared()>0.01 else 0.0
 queue_redraw()
func move_from_or_towards(point:Vector2,delta:float,charge:bool)->void:
 movement=(point-position) if charge else (position-point)
 if movement.length()<1:movement=Vector2.RIGHT
 var speed:float=WorldGoats.CHARGE_SPEED if charge else WorldGoats.FLEE_SPEED
 var target:Vector2=position+movement.normalized()*speed*delta
 if charge or home.distance_to(target)<550:position=target
 else:movement=Vector2.ZERO
