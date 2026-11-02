extends GutTest

func test_generated_cues_are_valid_nonempty_pcm() -> void:
	var audio := RanchAudio.new()
	add_child_autofree(audio)
	for cue: String in ["throw", "capture", "calm", "return", "door", "stun", "win", "lose"]:
		assert_true(audio._sounds.has(cue), cue)
		var sound: AudioStreamWAV = audio._sounds[cue]
		assert_eq(sound.mix_rate, 22050)
		assert_gt(sound.data.size(), 100)
		assert_gt(sound.get_length(), 0.05)

func test_muted_audio_does_not_start_a_voice() -> void:
	var audio := RanchAudio.new()
	add_child_autofree(audio)
	audio.enabled = false
	audio.play("capture")
	for voice: AudioStreamPlayer in audio._voices:
		assert_false(voice.playing)
