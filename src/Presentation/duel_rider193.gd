class_name DuelRider193
extends RaceRider190
var orbit_sign:float=1.
func _ready()->void:
 super._ready()
 can_jump=false;world_bounds=Rect2(-540,-260,1080,520)
 lasso.throw_guard=func()->bool:return race.running and attack_cooldown<=0. and not lasso.is_in_flight()
 dodge.can_start=func()->bool:return race.running
func _physics_process(delta:float)->void:
 if not race.running:return
 attack_cooldown=maxf(0.,attack_cooldown-delta)
 max_speed=base_pace
 if not ai:
  # Shared world movement, joystick, lazo and dodge, without racing gates.
  step_shared_movement(delta)
 else:
  dodge.cooldown=maxf(0.,dodge.cooldown-delta);dodge.fade_trail(delta)
  var target:Node2D=race.riders[1] if self==race.riders[0] else race.riders[0];var offset:Vector2=target.position-position
  var separation:float=offset.length();var direction:Vector2=offset.normalized()
  if not dodge.step_dash(max_speed,delta) and not dodge.step_coast(max_speed,delta):
   var radial:float=clampf((separation-175.)/80.,-1.,1.)
   var wish:Vector2=(direction*radial+direction.orthogonal()*orbit_sign*.55).normalized()
   velocity=velocity.move_toward(wish*max_speed,acceleration*delta);move_and_slide()
  gait=WorldGait.GALOPE;_update_animation(delta)
  if position.x>480. or position.x< -480. or absf(position.y)>210.:orbit_sign*=-1.
  _plan_sprint204(delta);_think(delta)
 position=position.clamp(world_bounds.position,world_bounds.end)
 queue_redraw()
func _evade()->void:pass # Opponent's flight/landing never informs the sprint plan.
func _planned_sprint204()->void:
 if dodge.cooldown>0. or dodge.remaining>0.:return
 var direction:=Vector2(-.55,orbit_sign).normalized()
 dodge.request_dash(direction)
func try_capture(landing:Vector2)->bool:
 if not race.running or position.distance_to(landing)>58.:return false
 race.capture_landed(self)
 return true
