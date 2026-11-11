extends "res://src/Presentation/frontier_world.gd"
var builder_samples:Dictionary={}
func _advance_builder(b:Dictionary)->void:
 var phase=int(b.phase);var t=Time.get_ticks_usec()
 super._advance_builder(b)
 if not builder_samples.has(phase):builder_samples[phase]=[]
 builder_samples[phase].append((Time.get_ticks_usec()-t)/1000.0)
