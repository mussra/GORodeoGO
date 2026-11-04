extends GutTest
func test_original_dirt_cues_respect_sound_switch() -> void:
	var audio := RanchAudio.new()
	add_child_autofree(audio)
	await wait_physics_frames(1)
	for cue in ["dodge","skid"]:
		assert_true(audio._sounds.has(cue))
		assert_gt(audio._sounds[cue].data.size(), 8000)
	audio.enabled = false
	var before: int = audio._next_voice
	audio.play("dodge")
	assert_eq(audio._next_voice, before, "mute suppresses dodge effects")
	audio.enabled = true
	audio.play("skid")
	assert_ne(audio._next_voice, before)
	for voice in audio._voices:
		voice.stop()
		voice.stream = null
