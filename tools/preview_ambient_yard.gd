extends Node2D
## Preview only. No collision, quest, lasso target, save or world RNG use.
var animals:Array=[]
var age:float=0.0
static var shared_frames:Dictionary={}
func _ready():
 var world=get_parent()
 for kind in ["pig","goat"]:
  if not shared_frames.has(kind):
   var frames=SpriteFrames.new();PixelLabTrial.apply_animal(frames,kind);shared_frames[kind]=frames
 for i in 8:
  var kind="pig" if i<4 else "goat"
  var base=Vector2(435+(i%2)*65,625+(i/2%2)*28) if i<4 else Vector2(-510+(i%2)*65,625+(i/2%2)*45)
  var sprite=AnimatedSprite2D.new();sprite.sprite_frames=shared_frames[kind];sprite.centered=false;sprite.offset=Vector2(-80,-144);sprite.scale=Vector2.ONE*.32;sprite.position=base;world.add_child(sprite);sprite.play("run");sprite.speed_scale=.25
  animals.append({"node":sprite,"home":base,"phase":i*1.7})
 # Flower shop uses existing right-hand house, not invented new building art.
 for i in 24:
  var sprite=Sprite2D.new();sprite.texture=load("res://art/world/cartoon/flower_%d.png"%(i%6+1));var side=-1 if i<12 else 1
  sprite.scale=Vector2.ONE*(24.0/sprite.texture.get_height());sprite.position=Vector2(292+side*(42+(i%3)*15),460+(i%4)*19);world.add_child(sprite)
 var sign=Label.new();sign.text="Floristería";sign.position=Vector2(260,415);sign.add_theme_font_size_override("font_size",13);world.add_child(sign)
func _process(delta:float):
 age+=delta
 for a in animals:
  var phase=age*.32+a.phase
  a.node.position=a.home+Vector2(sin(phase)*9,cos(phase*.7)*5)
  a.node.flip_h=cos(phase)<0
  a.node.speed_scale=.2 if sin(phase*2)>.2 else 0
func _exit_tree():
 for a in animals:
  if is_instance_valid(a.node):a.node.queue_free()
