class_name BullTuning
extends Resource

@export var calm_rate_per_second: float = 12.0
@export var disturbance_rate_per_second: float = 20.0
@export var max_rope_distance: float = INF  # rope-break disabled for now, per explicit request —
# set a finite value here to re-enable (see BullController.update_hold, unchanged, still
# checks this — it's the tunable that's different, not the mechanism).
@export var tow_speed: float = 240.0
@export var leash_distance: float = 50.0
@export var stun_duration_seconds: float = 2.0
