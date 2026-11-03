extends Node

## Minimal cross-scene state. Registered as an Autoload (see project.godot [autoload])
## so it survives get_tree().change_scene_to_file() calls between menu <-> level.

var selected_level: int = 1

var sound_enabled: bool = true

# Menu variant persists only for this process, never changes saved progress.
var menu_scene: String = "res://src/Presentation/main_menu.tscn"
