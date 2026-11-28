extends SceneTree
## Genera un guardado con el codigo de una version antigua (se ejecuta en CI con el tag checkout).
## Usa el autoload real SaveData, igual que el juego.
var done:=false
func _process(_delta:float)->bool:
	if done:return true
	done=true
	var sut=root.get_node_or_null("SaveData")
	if sut==null:
		print("saved=NO_AUTOLOAD");quit(1);return true
	sut.save_path=OS.get_environment("OUT")
	sut.highest_level_completed=17
	sut.equipment_points=240
	sut.world_seed=4242
	print("saved=",sut.save_progress())
	quit()
	return true
