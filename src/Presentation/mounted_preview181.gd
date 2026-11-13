extends AnimatedSprite2D
## Same mounted side poses, hat and equipment as the world player. No alternative base art.
var horse181:Dictionary={}
var walk_dir:String="side"
func configure_preview141(horse:Dictionary)->void:horse181=horse
func set_motion107(_motion:Vector2)->void:pass
func _update_anim()->void:
 if sprite_frames!=null:play("walk")
func _ready()->void:
 var frames:=SpriteFrames.new();frames.add_animation("walk");frames.set_animation_speed("walk",9.)
 for i in 9:frames.add_frame("walk",PixelLabTrial.pose_texture("rider","side",i,horse181.traits,horse181))
 sprite_frames=frames;centered=false;offset=Vector2(-48,-80);play("walk")
 HorseFinish168.install(self,horse181,"rider")
