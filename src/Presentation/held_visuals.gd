class_name HeldVisuals
extends RefCounted

## Held-animal rope visuals shared by the corral (bull._draw) and the open
## world (wild horses/pigs): same tow line, same trust ring, same trust bar,
## same colors — one look for the same mechanic (Ant's unification rule).

const ROPE_COLOR: Color = Color("86613e")
const CONTROLLED_COLOR: Color = Color("74c9a0")
const HOLD_COLOR: Color = Color("eec879")
const BAR_BG: Color = Color("554335")
const BAR_FILL: Color = Color("84d5a5")

## Tow line to the player, the hold ring under the animal and the trust bar
## (progress 0..1), or the check mark once the animal is controlled/tamed.
static func draw_hold(item: CanvasItem, player_global: Vector2, progress: float, controlled: bool, anchor_y: float = 0.0) -> void:
	var color: Color = CONTROLLED_COLOR if controlled else HOLD_COLOR
	item.draw_line(Vector2(0, 12 + anchor_y), item.to_local(player_global) + Vector2(0, 12), ROPE_COLOR, 3.0, true)
	item.draw_arc(Vector2(0, 25 + anchor_y), 29, 0, TAU, 40, color, 2.5, true)
	if not controlled:
		draw_progress(item, progress, anchor_y)
	else:
		item.draw_polyline(PackedVector2Array([Vector2(-7, -47), Vector2(-1, -41), Vector2(10, -54)]), color, 3, true)

## Just the trust bar, in the same style and position the corral draws it over
## a held bull. Open-world animals show it while trust builds unroped (the
## walk-up taming feedback the world already had, now with the corral look).
static func draw_progress(item: CanvasItem, progress: float, anchor_y: float = 0.0) -> void:
	item.draw_line(Vector2(-25, -48 + anchor_y), Vector2(25, -48 + anchor_y), BAR_BG, 6, true)
	item.draw_line(Vector2(-25, -48 + anchor_y), Vector2(-25 + 50 * clampf(progress, 0.0, 1.0), -48 + anchor_y), BAR_FILL, 6, true)
