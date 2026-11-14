class_name GanjoMusician205
extends Node2D
## Quiet ambient slot. No art fallback, collision, dialogue, rewards or audio voice.
## Ant supplies PixelLab art: cowboy, hat, Ganjo, wheat stalk in mouth.
const ART_PATH:String="res://art/npc/ganjo_musician205.tres"
var art_ready:bool=false
func _ready()->void:
 name="GanjoMusician205"
 var sprite:=AnimatedSprite2D.new();sprite.name="Artist";add_child(sprite)
 sprite.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
 var frames:SpriteFrames=null
 if ResourceLoader.exists(ART_PATH):frames=load(ART_PATH) as SpriteFrames
 configure_frames205(frames)
func configure_frames205(frames:SpriteFrames)->void:
 var sprite:AnimatedSprite2D=get_node("Artist")
 art_ready=frames!=null and frames.has_animation("play") and frames.get_frame_count("play")>0
 visible=art_ready
 if not art_ready:return
 sprite.sprite_frames=frames
 var texture:Texture2D=frames.get_frame_texture("play",0)
 if texture==null:art_ready=false;visible=false;return
 sprite.scale=Vector2.ONE*86./maxf(texture.get_height(),1.)
 sprite.position.y=-43.
 sprite.play("play")
static func beside_race205(course:RaceCourse190)->Vector2:
 # Outside the course and fence, near the starting line. Never an obstacle.
 return course.at(0.)+course.tangent(0.)*85.+course.tangent(0.).orthogonal()*265.
