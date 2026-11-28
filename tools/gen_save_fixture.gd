extends SceneTree
## Genera un guardado con el codigo de una version antigua (se ejecuta en CI con el tag checkout).
func _init():
	var sut=load("res://src/Application/save_data.gd").new()
	sut.save_path=OS.get_environment("OUT")
	sut.highest_level_completed=17
	sut.equipment_points=240
	sut.world_seed=4242
	print("saved=",sut.save_progress())
	quit()
