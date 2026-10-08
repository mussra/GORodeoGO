class_name CaptureResolver
extends RefCounted

## Deterministic capture check (GAMEPLAY_SPEC.md #Capture): the lasso "lands" at a point
## chosen by charge duration (see player.gd). Hit iff the landing point falls within the
## target's hit radius — no physics simulation, no angle cone. Overshoot/undershoot miss.

static func resolve_hit(attempt: CaptureAttempt) -> bool:
	var distance: float = attempt.landing_point.distance_to(attempt.target_position)
	return distance <= attempt.target_hit_radius
