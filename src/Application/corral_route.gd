class_name CorralRoute
extends RefCounted

## Ground tracks exit toward the central open lane before approaching another latch.
## Physical corral sizes stay fixed; the central lane stays outside all enclosures.
static func build(source: Dictionary, destination: Dictionary) -> PackedVector2Array:
	var start: Vector2 = source["door"]
	var finish: Vector2 = destination["door"]
	return PackedVector2Array([source["gate"], start, Vector2(0,start.y), Vector2(0,finish.y),finish])
