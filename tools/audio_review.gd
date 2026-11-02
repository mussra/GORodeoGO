extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var audio := RanchAudio.new()
	root.add_child(audio)
	for cue: String in ["throw", "capture", "calm", "return", "door", "stun", "win", "lose"]:
		var sound: AudioStreamWAV = audio._sounds[cue]
		sound.save_to_wav("/downloads/gorodeo/" + cue + ".wav")
		print("AUDIO ", cue, " length=", sound.get_length(), " bytes=", sound.data.size())
	audio.free()
	quit()
