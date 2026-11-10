extends "res://src/Presentation/wild_pig.gd"
## Reversible PixelLab run views; Art B remains the classic fallback.
## Shares lasso target, release, rope and nonblocking Node2D with pigs.
const IS_GOAT:bool=true
static var frames_cache:Dictionary={}
var goat_art:AnimatedSprite2D
var pixellab_views:Array=[]
func setup(p_pen:Dictionary)->void:
 pen=p_pen;home=pen.get("pos",Vector2.ZERO);state=WorldGoats.new_state()
func _ready()->void:
 position=home
 pixellab_views=PixelLabTrial.animal_views("goat")
 var key:String="nominal"
 if not frames_cache.has(key):
  var frames:=SpriteFrames.new();PixelLabTrial.apply_animal(frames,"goat");frames_cache[key]=frames
 goat_art=AnimatedSprite2D.new();goat_art.sprite_frames=frames_cache[key]
 goat_art.centered=false;goat_art.offset=Vector2(-80,-144);goat_art.scale=Vector2.ONE*.40
 # Both classic and PixelLab use a 160px canvas and the same foot pivot.
 goat_art.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 add_child(goat_art);goat_art.play("run")
func _process(delta:float)->void:
 touch_grace=maxf(0,touch_grace-delta)
 if roped:held=maxf(0,held-delta)
 var wanted:String=AnimalDirection.available_view(movement,pixellab_views)
 var view:String="run" if wanted=="side" else "run_"+wanted
 goat_art.flip_h=movement.x<0 and wanted not in ["up","down"]
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
