extends SceneTree
## Scripted input/positions for repeatable visual QA, not a human playthrough.
var elapsed: float = 0.0
var level: Node
var phase: int = -1
func _initialize() -> void:
	call_deferred("setup")
func setup() -> void:
	root.get_node("GameState").selected_level = 5
	level = load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	level._win_requires_all_bulls = false
	level._time_remaining = 165
func _process(delta: float) -> bool:
	if not is_instance_valid(level):
		return false
	elapsed += delta
	var next_phase: int = int(elapsed / 1.5)
	if next_phase != phase:
		phase = next_phase
		match phase:
			0:
				Input.action_press("move_down")
				Input.action_press("move_right")
			1:
				Input.action_release("move_down")
				Input.action_release("move_right")
				level.player.global_position = Vector2.ZERO
				level.player._start_charging()
			2:
				level.player.cancel_input()
				var bull: Node = level._active_bulls[0]
				bull.global_position = Vector2(70, 0)
				level._on_lasso_thrown(level.player.global_position, bull.global_position)
			3:
				level._active_bulls[0].controller.use_tranquilizer()
				Input.action_press("move_left")
			4:
				Input.action_release("move_left")
				level.pause_game()
			5:
				level.resume_game()
				level._trigger_lose("Fin de la demostración de revisión")
			6:
				quit()
	return false
