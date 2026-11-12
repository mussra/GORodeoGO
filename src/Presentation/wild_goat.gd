extends "res://src/Presentation/wild_pig.gd"
## Reversible PixelLab run views; Art B remains the classic fallback.
## Shares lasso target, release, rope and nonblocking Node2D with pigs.
const IS_GOAT:bool=true
static var frames_cache:Dictionary={}
var _fence_jump:float=0
var goat_art:AnimatedSprite2D
var pixellab_views:Array=[]
func setup(p_pen:Dictionary)->void:
 pen=p_pen;home=pen.get("pos",Vector2.ZERO);state=WorldGoats.new_state()
func _ready()->void:
 position=home
 road_provider94=WorldWildRoads94.provider(self)
 WorldWildRoads94.bind_spawn(self,road_provider94)
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
 _settle_offroad95(delta)
 _fence_jump=maxf(0,_fence_jump-delta)
 z_index=30 if _fence_jump>0 else 0
 goat_art.position.y=-sin(PI*(1-_fence_jump/.48))*28 if _fence_jump>0 else 0
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
 if not charge and float(get_meta("escape_left110",0.))<=0.:target=WorldEscapeMotion.bounded_step(position,home,point,target-position,550.0)
 if _fence_jump<=0 and WorldFence.crosses(self,target+movement.normalized()*20):_fence_jump=.48
 if not charge:_escape_left95=.2
 if charge and road_provider94.is_valid():target=get_parent().to_local(WorldWildRoads94.safe_step(global_position,get_parent().to_global(target),road_provider94))
 target=get_parent().to_local(WorldWildRoads94.terrain_step(self,global_position,get_parent().to_global(target))) if road_provider94.is_valid() else target
 movement=(target-position).normalized();position=target

func _draw()->void:
 super._draw()
 if not roped and bool(state.get("alert110",false)) and float(state.get("spook",0.))<=0.:draw_string(ThemeDB.fallback_font,Vector2(-5,-85),"?",HORIZONTAL_ALIGNMENT_LEFT,-1,20,Color("ffe6a0"))
