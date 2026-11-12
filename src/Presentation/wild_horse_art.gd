extends AnimatedSprite2D
## Nominal five-view PixelLab horse. Nine frames per movement view.
## Coat, mane and patterns use the reviewed v5 masks and shared genotype cache.
static var frame_cache: Dictionary = {}

static var preview_frames141:Dictionary={}
var preview_record141:Dictionary={}
var preview_side141:bool=false
func configure_preview141(horse:Dictionary)->void:
	preview_side141=true;preview_record141=horse;traits=horse.traits
func _preview_frames141()->SpriteFrames:
	var key:String=PixelLabTrial.cache_key(traits)+str(HorseGalaxyLook.state(preview_record141))
	if preview_frames141.has(key):return preview_frames141[key]
	var frames:=SpriteFrames.new();frames.add_animation("walk");frames.set_animation_speed("walk",9.)
	for i in 9:frames.add_frame("walk",PixelLabTrial.pose_texture("horse","side",i,traits,preview_record141))
	frames.add_animation("idle");frames.add_frame("idle",frames.get_frame_texture("walk",0))
	if preview_frames141.size()>=36:preview_frames141.clear()
	preview_frames141[key]=frames;return frames
var traits: Dictionary = {}
var grazing: bool = false : set = set_grazing
var walk_dir: String = "side"
var resting107:bool=false
func set_motion107(motion:Vector2)->void:
	var rest:bool=motion.length()<12.
	if rest==resting107:return
	resting107=rest;_update_anim()

func set_grazing(value: bool) -> void:
	if grazing == value: return
	grazing = value
	_update_anim()

var _pending_view129:String=""
var _pending_seconds129:float=0.
func update_heading129(motion:Vector2,delta:float)->void:
	if motion.length()<WildHeading129.MIN_MOTION:
		_pending_view129="";_pending_seconds129=0.;return
	var d:String=WildHeading129.view(motion,walk_dir)
	var flip_:bool=WildHeading129.flip(motion,flip_h)
	var candidate:String=d+str(flip_)
	if d==walk_dir and flip_==flip_h:
		_pending_view129="";_pending_seconds129=0.;return
	if candidate!=_pending_view129:
		_pending_view129=candidate;_pending_seconds129=0.
	_pending_seconds129+=maxf(delta,0.)
	if _pending_seconds129+0.000001<WildHeading129.VIEW_HOLD:return
	walk_dir=d;flip_h=flip_;_pending_view129="";_pending_seconds129=0.;_update_anim()
func set_walk_direction(dir:Vector2)->void:
	# Static preview compatibility. Gameplay calls update_heading129 once after movement.
	walk_dir=WildHeading129.view(dir,walk_dir);_update_anim()

static func _build_frames(traits: Dictionary) -> SpriteFrames:
	var frames := SpriteFrames.new()
	PixelLabTrial.apply(frames,"horse","walk",traits)
	return frames

func _ready() -> void:
	var key := PixelLabTrial.cache_key(traits)
	if preview_side141:
		sprite_frames=_preview_frames141()
	elif not frame_cache.has(key):
		frame_cache[key] = _build_frames(traits)
	if not preview_side141:sprite_frames = frame_cache[key]
	centered = false
	offset = Vector2(-48, -80)  # hooves at node origin, like the code-drawn version
	_update_anim()

func _update_anim() -> void:
	if sprite_frames==null:return
	var next:String="idle" if grazing or resting107 else ("walk" if walk_dir=="side" else "walk_"+walk_dir)
	if animation==next:return
	var was_moving:bool=str(animation).begins_with("walk") and next.begins_with("walk")
	var phase:float=(float(frame)+frame_progress)/maxi(1,sprite_frames.get_frame_count(animation)) if was_moving else 0.
	play(next)
	if was_moving:
		var at:float=phase*sprite_frames.get_frame_count(next)
		set_frame_and_progress(int(at),at-floorf(at))
