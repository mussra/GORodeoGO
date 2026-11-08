extends Node

var panel: HorsePanel
var step := 0

func _ready() -> void:
	get_window().size = Vector2i(1280, 720)
	SaveData.save_path = "user://qa-atlas-filter.dat"
	SaveData.horse_collection.seed_trial()
	panel = HorsePanel.new()
	get_tree().root.add_child.call_deferred(panel)
	await get_tree().create_timer(0.3).timeout
	panel.show_page("atlas")

func shot(name: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png("/tmp/atlas_%s.png" % name)
	print("saved ", name)

func _process(_dt: float) -> void:
	step += 1
	match step:
		14:
			await shot("filter_off")
			panel._on_atlas_filter(6, "coat", HorseFilters.properties()[0].values)
		26:
			await shot("filter_rojos")
			panel._on_atlas_filter(10, "pattern", HorseFilters.properties()[1].values)
		38:
			await shot("filter_rojos_rayados")
			# Peor caso en español: los textos más largos de cada filtro.
			TranslationServer.set_locale("es")
			var props: Array = HorseFilters.properties()
			panel._on_atlas_filter(8, "coat", props[0].values)      # Turquesa
			panel._on_atlas_filter(4, "pattern", props[1].values)   # Trasera blanca
			panel._on_atlas_filter(6, "mane", props[2].values)      # Arcoíris
			panel._on_atlas_filter(2, "rarity", props[3].values)    # Poco frecuente
			panel._on_atlas_filter(2, "owned", props[4].values)     # Sin conseguir
		50:
			await shot("filter_es_peor_caso")
			get_window().size = Vector2i(2340, 1080)
		62:
			await shot("filter_es_peor_caso_movil")
			DirAccess.remove_absolute("user://qa-atlas-filter.dat")
			get_tree().quit()
