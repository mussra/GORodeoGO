class_name PlayerUpgrades
extends RefCounted

## Application layer: the persistent unlock schedule (D009), single source of truth.
## Narratively: gear a hired bull-wrangler earns by completing levels. Level0 applies the
## result once at level start; the numbers live only here.

const TRANQUILIZER_UNLOCK_LEVEL: int = 1
const SPEED_UNLOCK_LEVEL: int = 2
const STUN_RESISTANCE_UNLOCK_LEVEL: int = 4
const DUAL_CAPTURE_UNLOCK_LEVEL: int = 5
const LASSO_SPEED_UNLOCK_LEVEL: int = 6
const THROW_DISTANCE_UNLOCK_LEVEL: int = 8

const SPEED_MULTIPLIER: float = 1.15
const STUN_DURATION_MULTIPLIER: float = 0.7
const LASSO_TRAVEL_TIME_MULTIPLIER: float = 0.75
const THROW_DISTANCE_MULTIPLIER: float = 1.20

var speed_multiplier: float = 1.0
var stun_duration_multiplier: float = 1.0
var lasso_travel_time_multiplier: float = 1.0
var throw_distance_multiplier: float = 1.0
var max_simultaneous_captures: int = 1
var tranquilizer_available: bool = false

static func for_progress(highest_level_completed: int) -> PlayerUpgrades:
	var upgrades := PlayerUpgrades.new()
	if highest_level_completed >= TRANQUILIZER_UNLOCK_LEVEL:
		upgrades.tranquilizer_available = true
	if highest_level_completed >= SPEED_UNLOCK_LEVEL:
		upgrades.speed_multiplier = SPEED_MULTIPLIER
	if highest_level_completed >= STUN_RESISTANCE_UNLOCK_LEVEL:
		upgrades.stun_duration_multiplier = STUN_DURATION_MULTIPLIER
	if highest_level_completed >= DUAL_CAPTURE_UNLOCK_LEVEL:
		upgrades.max_simultaneous_captures = 2
	if highest_level_completed >= LASSO_SPEED_UNLOCK_LEVEL:
		upgrades.lasso_travel_time_multiplier = LASSO_TRAVEL_TIME_MULTIPLIER
	if highest_level_completed >= THROW_DISTANCE_UNLOCK_LEVEL:
		upgrades.throw_distance_multiplier = THROW_DISTANCE_MULTIPLIER
	return upgrades
