class_name BullDistraction
extends RefCounted

## A pursuing wild bull may stop at water/hay. Its chaser role is retained while
## distracted, so another bull does not immediately replace the escape window.
const STOP_SECONDS: float = 3.0
const COOLDOWN_SECONDS: float = 10.0
var remaining: float = 0.0
var cooldown: float = 0.0
var kind: String = ""

func update(delta: float) -> bool:
	remaining = maxf(remaining - delta, 0.0)
	cooldown = maxf(cooldown - delta, 0.0)
	return remaining > 0.0

func try_start(is_wild: bool, is_pursuing: bool, near_kind: String) -> bool:
	if not is_wild or not is_pursuing or near_kind.is_empty() or cooldown > 0.0:
		return false
	kind = near_kind
	remaining = STOP_SECONDS
	cooldown = STOP_SECONDS + COOLDOWN_SECONDS
	return true

func cancel() -> void:
	remaining = 0.0

func active() -> bool:
	return remaining > 0.0
