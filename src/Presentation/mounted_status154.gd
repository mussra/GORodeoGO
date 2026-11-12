class_name MountedStatus154
extends RefCounted
## Shared capability rules, cooldown clocks and art for every ridden world.
static func create(host:Node)->Dictionary:
 var gauges:Dictionary={}
 for i in 3:
  var id:String=["stamina","dodge","jump"][i];var gauge:=RadialGauge.new();gauge.skill=id;gauge.position=Vector2(1046+i*84,636);gauge.size=Vector2(76,76);gauge.mouse_filter=Control.MOUSE_FILTER_IGNORE;gauges[id]=gauge;host.add_child(gauge)
 return gauges
static func abilities(player:CharacterBody2D,gauges:Dictionary,horse:Dictionary):
 player.dodge_available=HorseTraining.knows(horse,"dodge");player.dodge_recharge_seconds=2.5*HorseTraining.recovery(horse,"dodge")
 player.can_jump=HorseJump.capable(horse);player.jump_recovery_multiplier=HorseTraining.recovery(horse,"jump")
 gauges.jump.set_state(player.can_jump,1.-player._jump_cooldown/maxf(.01,1.2*player.jump_recovery_multiplier))
 gauges.dodge.set_state(player.dodge_available,1.-player.dodge_cooldown/maxf(.01,player.dodge_recharge_seconds))
static func stamina(player:CharacterBody2D,gauges:Dictionary,state:Dictionary,delta:float,on_road:bool)->Dictionary:
 var next:=WorldStamina.tick(state,player.gait,player.velocity.length()>12.,delta,on_road);player.gait_cap=WorldStamina.cap_gait(next,WorldGait.GALOPE);gauges.stamina.set_state(true,WorldStamina.ratio(next));return next
