extends 'res://tools/perf_world242.gd'
var radius_override249:int=-1
func _spawn_radius249()->int:
 return radius_override249 if radius_override249>=0 else super._spawn_radius249()
