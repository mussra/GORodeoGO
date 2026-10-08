extends Node

## Minimal cross-scene state. Registered as an Autoload (see project.godot [autoload])
## so it survives get_tree().change_scene_to_file() calls between menu <-> level.

var selected_level: int = 1
