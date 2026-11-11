extends Node
func _ready():
 var runner=Node.new();runner.set_script(load("res://tools/entry_capture_runner.gd"));get_tree().root.add_child.call_deferred(runner)
