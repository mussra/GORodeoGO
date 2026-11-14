class_name JoustRider196
extends DuelRider193
## Pass movement still executes the shared world/lasso/dodge body.
var forward:float=1.
func process_lasso_input(delta:float)->void:
 if not ai:super.process_lasso_input(delta)
func movement_wish()->Vector2:
 var steer:float=sin(race.elapsed*2.1)*.35 if ai else Input.get_axis("move_up","move_down")
 return Vector2(forward,steer*.65).normalized()
func _physics_process(delta:float)->void:
 if not race.running:return
 var before:float=position.x
 attack_cooldown=maxf(0.,attack_cooldown-delta);max_speed=base_pace
 step_shared_movement(delta)
 # No reversal or riding outside the pass. A backwards dodge stays lateral.
 position.x=clampf(maxf(position.x,before) if forward>0. else minf(position.x,before),-480.,480.)
 position.y=clampf(position.y,-140.,140.)
 velocity.x=maxf(0.,velocity.x*forward)*forward
 if ai:_evade();_think(delta)
 queue_redraw()

func _evade()->void:
 var opponent:Node2D=race.riders[1] if self==race.riders[0] else race.riders[0]
 var flight=opponent.lasso._flight_line
 # Human-visible reaction delay, rather than a perfect dodge on every release.
 if not is_instance_valid(flight) or flight.progress<.65:return
 super._evade()
