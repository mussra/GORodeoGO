extends GutTest
## 3.0.43: un jugador nunca pierde progreso al actualizar. Guardados REALES escritos por el codigo de v3.0.3 y v3.0.36
## (generados en CI con el tag de cada version) deben cargarse con el codigo actual.
const FIXTURES:Array[String]=["res://tests/fixtures/saves/save_v3.0.3.dat","res://tests/fixtures/saves/save_v3.0.36.dat"]
func _load_fixture(src:String)->Node:
	var dst:String="user://old_save_test343.dat"
	var bytes:=FileAccess.get_file_as_bytes(src)
	assert_gt(bytes.size(),100,src+" existe")
	var f:=FileAccess.open(dst,FileAccess.WRITE);f.store_buffer(bytes);f.close()
	var sut:Node=load("res://src/Application/save_data.gd").new();add_child_autofree(sut)
	sut.save_path=dst;sut.load_progress();return sut
func test_old_saves_keep_progress_points_and_world()->void:
	for src in FIXTURES:
		var sut:=_load_fixture(src)
		assert_eq(sut.highest_level_completed,17,src)
		assert_eq(sut.equipment_points,240,src)
		assert_eq(sut.world_seed,4242,src)
func test_old_save_survives_a_resave_with_current_code()->void:
	for src in FIXTURES:
		var sut:=_load_fixture(src)
		assert_true(sut.save_progress(),src+" se puede guardar de nuevo")
		sut.highest_level_completed=0;sut.equipment_points=0;sut.world_seed=0;sut.load_progress()
		assert_eq([sut.highest_level_completed,sut.equipment_points,sut.world_seed],[17,240,4242],src)
func after_all()->void:
	DirAccess.remove_absolute("user://old_save_test343.dat")
