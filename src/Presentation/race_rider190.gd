class_name RaceRider190
extends "res://src/Presentation/world_player.gd"
## Race-specific rules only. Movement/player art, lasso and dodge are shared.
var race:Node2D
var ai:bool=false
var racer_index:int=0
var racer_name:String="Tú"
var tint:Color=Color("7de1cc")
var next_gate:int=1
var previous_position:Vector2
var finish_time:float=-1.
var slow_left:float=0.
var protected_left:float=0.
var attack_cooldown:float=0.
var attack_think:float=.8
var base_pace:float=260.
var lane:float=0.
var tether_from:Node2D
var passed:int=0
var route_s:float=-30.
var crossing_slow:float=0.
var crossing_protected:float=0.
var sprint_plan204:float=6.
var sprint_count204:int=0
var _ai_previous:Vector2=Vector2.INF
var _ai_blocked:float=0.
var _ai_bypass:float=0.
func _ready()->void:
 super._ready()
 # Top-down riders slide along diagonal fences, never treat them as slopes.
 motion_mode=CharacterBody2D.MOTION_MODE_FLOATING
 collision_layer=0;collision_mask=HorseJump.FENCE_LAYER
 max_speed=base_pace;acceleration=900.
 dodge_available=true;dodge_recharge_seconds=2.5
 dodge.can_start=func()->bool:return race.running and finish_time<0. and _jump_time<=0.
 lasso.throw_guard=func()->bool:return _aim_allowed198() and finish_time<0. and _jump_time<=0. and attack_cooldown<=0. and not lasso.is_in_flight()
 lasso.launch_guard=func()->bool:return race.running
 lasso.aim_hold_guard=func()->bool:return _aim_allowed198() and finish_time<0. and _jump_time<=0.
 lasso.can_capture=func()->bool:return race.running
 lasso.prey_provider=func()->Array:return race.targets_for(self)
 lasso.lasso_released.connect(func():attack_cooldown=3.)
 lasso.prey_captured.connect(func(target):target.tether_from=self)
 lasso.capture_area_visual_radius=58.
 sprint_plan204=5.5+float(racer_index)*1.3
 if ai:set_process_input(false)
func _input(event:InputEvent)->void:
 if not ai and _aim_allowed198() and finish_time<0.:super._input(event)
func _physics_process(delta:float)->void:
 if not race.running or finish_time>=0.:
  if not ai and _aim_allowed198():lasso.process_throw_input(delta)
  return
 slow_left=maxf(0.,slow_left-delta);protected_left=maxf(0.,protected_left-delta);attack_cooldown=maxf(0.,attack_cooldown-delta)
 crossing_slow=maxf(0.,crossing_slow-delta);crossing_protected=maxf(0.,crossing_protected-delta)
 max_speed=base_pace*minf(.75 if slow_left>0. else 1.,.72 if crossing_slow>0. else 1.)
 if not ai:super._physics_process(delta)
 else:
  _ai_bypass=maxf(0.,_ai_bypass-delta)
  if _jump_time<=0. and _ai_previous!=Vector2.INF and position.distance_to(_ai_previous)<1. and velocity.length()>40.:_ai_blocked+=delta
  else:_ai_blocked=0.
  _ai_previous=position
  if _ai_blocked>.4:_ai_bypass=2.5;_ai_blocked=0.
  _jump_cooldown=maxf(0.,_jump_cooldown-delta)
  if _jump_time>0.:HorseJumpMotion.process(self,delta);return
  if can_jump and _ai_bypass<=0. and velocity.length()>60. and HorseJumpMotion.try_ahead(self):return
  dodge.cooldown=maxf(0.,dodge.cooldown-delta)
  dodge.fade_trail(delta)
  if not dodge.step_path(max_speed,delta) and not dodge.step_coast(max_speed,delta) and not dodge.step_dash(max_speed,delta):
   var progress:Dictionary=race.course.route_project(position,route_s)
   var ahead:float=progress.s+130.
   # Use the inside racing line, not the original decorative starting lane.
   # Every rider uses the same speed; fences still require a real jump/bypass.
   var racing_lane:float=-100.+float(racer_index%4)*14.
   var goal:Vector2=race.course.at(ahead)+race.course.tangent(ahead).orthogonal()*race.course.ai_lane(progress.s,racing_lane,can_jump and _ai_bypass<=0.)
   var wish:Vector2=(goal-position).normalized()
   velocity=velocity.move_toward(wish*max_speed,acceleration*delta);move_and_slide()
  gait=WorldGait.GALOPE;_update_animation(delta);_plan_sprint204(delta);_think(delta)
 queue_redraw()
func _evade()->void:pass # No reaction to the opponent's rope, even after launch.
func _plan_sprint204(delta:float)->void:
 sprint_plan204-=delta
 if sprint_plan204>0.:return
 sprint_count204+=1
 sprint_plan204=6.5+float((racer_index+sprint_count204)%3)*1.2
 _planned_sprint204()
func _planned_sprint204()->void:_boost197()
func _think(delta:float)->void:
 attack_think-=delta
 if attack_think>0.:return
 attack_think=.35+float(racer_index)*.11
 if attack_cooldown>0. or lasso.is_in_flight() or dodge.remaining>0.:return
 var candidates:Array=race.targets_for(self)
 if candidates.is_empty():return
 var target:Node2D=candidates[0]
 # Use the normal shared charge/release, inheritance and fixed flight time.
 var aim:Vector2=target.position+target.velocity*LassoController.FLIGHT_SECONDS-position-velocity*LassoController.FLIGHT_SECONDS
 lasso.aim_direction=aim.normalized()
 lasso._start_charging();lasso._charge_distance=minf(aim.length(),lasso.max_throw_distance)
 lasso._release_throw()
func try_capture(landing:Vector2)->bool:
 if not race.running or finish_time>=0. or protected_left>0. or position.distance_to(landing)>58.:return false
 slow_left=1.2;protected_left=3.2
 race.notice_hit(self)
 return true
func _draw()->void:
 if dodge==null:return
 super._draw()
 draw_arc(Vector2(0,-4),27.,0,TAU,32,tint,3.,true)
 if slow_left>0.:
  LassoRopeStyle.draw_loop(self,Vector2(0,-26))
 elif protected_left>0.:
  draw_arc(Vector2(0,-32),37.,0,TAU,32,Color(tint,.5),2.,true)
 draw_string(ThemeDB.fallback_font,Vector2(-34,-125),racer_name,HORIZONTAL_ALIGNMENT_LEFT,-1,20,tint)

## Same traced regate and same cooldown as a player drawing forward. No catch-up.
func _boost197()->void:
 if dodge.cooldown>0. or dodge.remaining>0. or _jump_time>0.:return
 var projection:Dictionary=race.course.route_project(position,route_s)
 for fence in race.course.fences:
  if fposmod(fence-projection.s,race.course.length)<360.:return
 var forward:Vector2=race.course.tangent(projection.s)
 # Avoid boosting into an outer boundary while recovering from a side-step.
 if absf((position-projection.point).dot(forward.orthogonal()))>135.:return
 dodge.request_path(PackedVector2Array([Vector2.ZERO,forward*125.,forward*250.]))

func _aim_allowed198()->bool:
 return race.running or (race.has_method("prestart_aim198") and race.prestart_aim198())

func draw_dodge_recharge204()->void:
 pass # Recharge belongs inside the sprint button, never under the horse.
