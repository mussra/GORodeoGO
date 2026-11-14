extends Node

## One persistent voice. Same-context requests never restart a loop. On context changes
## fade out before replacing the stream, so two music tracks can never overlap.
const TRACKS: Dictionary = {
	"menu": "res://audio/music/menu.wav",
	"gameplay": "res://audio/music/gameplay.wav",
	"race": "res://audio/music/race198.wav",
	"duel": "res://audio/music/duel198.wav",
}
const MUSIC_DB: float = -13.0
var voice: AudioStreamPlayer
var context: String = ""
var _requested: String = ""
var _transition: Tween
var _muted: bool = false
var _paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	voice = AudioStreamPlayer.new()
	voice.name = "MusicVoice"
	voice.volume_db = MUSIC_DB
	add_child(voice)

func play_context(next: String) -> void:
	if not TRACKS.has(next):
		return
	if _requested == next:
		return
	_requested = next
	if is_instance_valid(_transition):
		_transition.kill()
	_transition = create_tween()
	if voice.playing:
		_transition.tween_property(voice, "volume_db", -60.0, .18)
	_transition.tween_callback(_replace_track.bind(next))
	_transition.tween_property(voice, "volume_db", -80.0 if _muted else MUSIC_DB, .25)

func stop_context() -> void:
	# Cancel pending fades too, so an old menu/race cannot start during preparation.
	if is_instance_valid(_transition):
		_transition.kill()
	_requested = ""
	context = ""
	voice.stop()
	voice.stream = null

func _replace_track(next: String) -> void:
	var stream: AudioStreamWAV = load(TRACKS[next]).duplicate()
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = {"menu":1843200,"gameplay":1245405,"race":1181538,"duel":1396364}[next]
	voice.stop()
	voice.stream = stream
	voice.volume_db = -80.0 if _muted else -60.0
	context = next
	voice.play()
	voice.stream_paused = _paused

func set_enabled(enabled: bool) -> void:
	_muted = not enabled
	if is_instance_valid(_transition):
		_transition.kill()
	# Complete any pending track switch, but do not restart an already active context.
	if context != _requested and not _requested.is_empty():
		_replace_track(_requested)
	voice.volume_db = -80.0 if _muted else MUSIC_DB

func set_paused(value: bool) -> void:
	_paused = value
	voice.stream_paused = value

func _exit_tree() -> void:
	if is_instance_valid(_transition):
		_transition.kill()
	if is_instance_valid(voice):
		voice.stop()
		voice.stream = null
