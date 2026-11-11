extends Node
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 var demo=load("res://tools/demo_map_notes.gd").new();demo.automatic=true;add_child(demo)
