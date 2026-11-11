extends Node
func _ready():
 var runner=Node.new();runner.set_script(load("res://tools/home_capture_runner83.gd"));get_tree().root.add_child.call_deferred(runner)
