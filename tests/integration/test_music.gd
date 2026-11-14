extends GutTest
func after_each() -> void:
	RanchMusic.set_paused(false)
	RanchMusic.set_enabled(true)
	get_tree().paused = false

func test_single_voice_loops_and_same_context_does_not_restart() -> void:
	RanchMusic.play_context("menu")
	await wait_seconds(.55)
	assert_eq(RanchMusic.get_child_count(), 1)
	assert_true(RanchMusic.voice.playing)
	var stream: AudioStreamWAV = RanchMusic.voice.stream
	assert_eq(stream.loop_mode, AudioStreamWAV.LOOP_FORWARD)
	assert_eq(stream.loop_end, 1843200)
	RanchMusic.voice.seek(38.15)
	await wait_seconds(.5)
	assert_true(RanchMusic.voice.playing, "continues beyond menu loop boundary")
	var before: float = RanchMusic.voice.get_playback_position()
	RanchMusic.play_context("menu")
	await wait_seconds(.1)
	assert_gt(RanchMusic.voice.get_playback_position(), before, "same context does not rewind")
	RanchMusic.play_context("gameplay")
	await wait_seconds(.55)
	assert_eq(RanchMusic.context, "gameplay")
	assert_eq(RanchMusic.voice.stream.loop_end, 1245405)
	RanchMusic.voice.seek(25.7)
	await wait_seconds(.5)
	assert_true(RanchMusic.voice.playing, "continues beyond gameplay loop boundary")
	assert_eq(RanchMusic.get_child_count(), 1, "context transitions do not add voices")

func test_pause_and_mute_keep_position() -> void:
	RanchMusic.play_context("gameplay")
	await wait_seconds(.55)
	RanchMusic.set_paused(true)
	var before: float = RanchMusic.voice.get_playback_position()
	await get_tree().create_timer(.2, true).timeout
	assert_almost_eq(RanchMusic.voice.get_playback_position(), before, .02)
	RanchMusic.set_enabled(false)
	assert_eq(RanchMusic.voice.volume_db, -80.0)
	assert_true(RanchMusic.voice.stream_paused)
	RanchMusic.set_enabled(true)
	assert_eq(RanchMusic.voice.volume_db, RanchMusic.MUSIC_DB)
	RanchMusic.set_paused(false)
	await wait_seconds(.1)
	assert_gt(RanchMusic.voice.get_playback_position(), before)

func test_new_race_and_duel_tracks_use_one_voice_and_correct_loop_frames()->void:
	for next in ["race","duel"]:
		RanchMusic.play_context(next);await wait_seconds(.55)
		assert_eq(RanchMusic.context,next);assert_eq(RanchMusic.get_child_count(),1)
		assert_eq(RanchMusic.voice.stream.loop_end,1181538 if next=="race" else 1396364)
		assert_eq(RanchMusic.voice.stream.mix_rate,48000)
		assert_true(RanchMusic.voice.playing)
