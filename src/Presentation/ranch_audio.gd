class_name RanchAudio
extends Node

## Original short synthesized cues, no network/files/licenses needed at runtime.
const SAMPLE_RATE: int = 22050
var enabled: bool = true
var _voices: Array[AudioStreamPlayer] = []
var _next_voice: int = 0
var _sounds: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	for i in range(4):
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -15.0
		add_child(voice)
		_voices.append(voice)
	_sounds["dodge"] = _make_dirt_cue(false)
	_sounds["skid"] = _make_dirt_cue(true)
	_sounds["throw"] = _make_cue([540.0, 360.0], 0.05)
	_sounds["capture"] = _make_cue([440.0, 660.0], 0.075)
	_sounds["calm"] = _make_cue([523.25, 659.25, 783.99], 0.08)
	_sounds["return"] = _make_cue([659.25, 783.99, 1046.5], 0.08)
	_sounds["door"] = _make_cue([330.0, 440.0], 0.1)
	_sounds["stun"] = _make_cue([220.0, 164.8], 0.07)
	_sounds["win"] = _make_cue([523.25, 659.25, 783.99, 1046.5], 0.14)
	_sounds["lose"] = _make_cue([392.0, 330.0, 261.6], 0.12)

func play(cue: String) -> void:
	if not enabled or not _sounds.has(cue) or _voices.is_empty():
		return
	var voice: AudioStreamPlayer = _voices[_next_voice]
	_next_voice = (_next_voice + 1) % _voices.size()
	voice.stream = _sounds[cue]
	voice.play()

func _make_cue(notes: Array, note_seconds: float) -> AudioStreamWAV:
	var samples_per_note: int = int(SAMPLE_RATE * note_seconds)
	var data := PackedByteArray()
	data.resize(samples_per_note * notes.size() * 2)
	for note_index in range(notes.size()):
		var frequency: float = notes[note_index]
		for sample in range(samples_per_note):
			var time: float = float(sample) / SAMPLE_RATE
			var progress: float = float(sample) / samples_per_note
			var envelope: float = minf(progress * 20.0, 1.0) * pow(1.0 - progress, 1.5)
			var wave: float = sin(TAU * frequency * time) + sin(TAU * frequency * 2.0 * time) * 0.15
			var amplitude: int = int(clampf(wave * envelope * 0.5, -1, 1) * 32767)
			data.encode_s16((note_index * samples_per_note + sample) * 2, amplitude)
	var sound := AudioStreamWAV.new()
	sound.format = AudioStreamWAV.FORMAT_16_BITS
	sound.mix_rate = SAMPLE_RATE
	sound.stereo = false
	sound.data = data
	return sound

## Original deterministic dirt/hoof textures. Local noise and low hoof impacts,
## no downloaded recording; tucked under the banjo by the existing SFX bus level.
func _make_dirt_cue(skid: bool) -> AudioStreamWAV:
	var duration: float = .20 if skid else .24
	var count: int = int(SAMPLE_RATE * duration)
	var data := PackedByteArray()
	data.resize(count * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 14671 if skid else 7921
	var filtered: float = 0.0
	for sample in range(count):
		var t: float = float(sample) / SAMPLE_RATE
		var p: float = float(sample) / count
		filtered = lerpf(filtered, rng.randf_range(-1.0, 1.0), .28)
		var envelope: float = minf(p * 28.0, 1.0) * pow(1.0 - p, 1.8)
		var hoof_phase: float = fmod(t, .065)
		var hoof: float = sin(TAU * 105.0 * hoof_phase) * exp(-hoof_phase * 90.0)
		var value: float = filtered * (.75 if skid else .40) + hoof * (.06 if skid else .35)
		data.encode_s16(sample * 2, int(clampf(value * envelope, -.8, .8) * 32767))
	var sound := AudioStreamWAV.new()
	sound.format = AudioStreamWAV.FORMAT_16_BITS
	sound.mix_rate = SAMPLE_RATE
	sound.data = data
	return sound
