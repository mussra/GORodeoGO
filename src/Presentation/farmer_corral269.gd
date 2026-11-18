class_name FarmerCorral269
extends Node2D
## Cosmetic returned-bull herd. Reuses WorldFence and the Rodeo bull artwork.
## No BullController, capture bodies, quest rewards or extra simulated animals.
const MAX_VISIBLE:int=6
const SIZE:=Vector2(420,210)
var actors:Array[AnimatedSprite2D]=[]
var label:Label
var shown_total:int=-1
var age:float=0.
var center:Vector2
func _ready():
 name="FarmerCorral269"
 center=(ModularWorldLayout93.world(WorldNominal98.doors().ranch)+Vector2(-420,-90)) if WorldNominal98.enabled() else Vector2(80,20)
 var box:=Rect2(center-SIZE*.5,SIZE)
 # Shared rails own collisions and depth, the same as the ranch's other fences.
 for pair in ([] if not WorldNominal98.enabled() else [[box.position,Vector2(box.end.x,box.position.y)],[Vector2(box.end.x,box.position.y),box.end],[box.end,Vector2(center.x+45,box.end.y)],[Vector2(center.x-45,box.end.y),Vector2(box.position.x,box.end.y)],[Vector2(box.position.x,box.end.y),box.position]]):
  WorldFence.segment(get_parent(),pair[0],pair[1])
 label=Label.new();label.position=center+Vector2(-200,-165);label.add_theme_font_size_override("font_size",18);label.add_theme_color_override("font_color",Color("fff2c7"));get_parent().add_child(label);label.z_index=4
 refresh()
func refresh():
 var total:int=SaveData.world_bull_returns269.size()
 if total==shown_total:return
 shown_total=total
 label.text="Corral del granjero · Toros: %d"%total
 if total>MAX_VISIBLE:label.text+=" · %d a la vista"%MAX_VISIBLE
 for a in actors:a.queue_free()
 actors.clear()
 for i in mini(total,MAX_VISIBLE):
  var sprite:=AnimatedSprite2D.new();var frames:=SpriteFrames.new();frames.add_animation("rest");frames.set_animation_speed("rest",4.)
  for frame in 9:frames.add_frame("rest",load("res://art/experimental/pixellab/bull/side/frame_%02d.png"%frame))
  sprite.sprite_frames=frames;sprite.scale=Vector2.ONE*.72;sprite.offset.y=-22.;sprite.flip_h=i%2==1;sprite.play("rest");get_parent().add_child(sprite);actors.append(sprite)
 _place()
func _process(delta:float):
 age+=delta
 if SaveData.world_bull_returns269.size()!=shown_total:refresh()
 _place()
func _place():
 for i in actors.size():
  var home:=center+Vector2(-135+(i%3)*135,-32+int(i/3)*83)
  actors[i].position=home+Vector2(sin(age*.35+i)*7.,cos(age*.28+i)*3.)
func _exit_tree():
 for a in actors:
  if is_instance_valid(a):a.queue_free()
 if is_instance_valid(label):label.queue_free()
