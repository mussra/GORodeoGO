class_name MountedStatus154
extends RefCounted
## Shared capability rules, cooldown clocks and art for every ridden world.
static func create(host:Node)->Dictionary:
 var gauges:Dictionary={}
 for i in 3:
  var id:String=["stamina","dodge","jump"][i];var gauge:=RadialGauge.new();gauge.skill=id;gauge.position=Vector2(1046+i*84,636);gauge.size=Vector2(76,76);gauge.mouse_filter=Control.MOUSE_FILTER_IGNORE;gauges[id]=gauge;host.add_child(gauge)
 return gauges
static func abilities(player:CharacterBody2D,gauges:Dictionary,horse:Dictionary):
 player.dodge_available=HorseTraining.knows(horse,"dodge");player.dodge_recharge_seconds=2.5*HorseTraining.recovery(horse,"dodge")*EquipmentEffects.dodge_recharge_multiplier()
 if player.dodge!=null:player.dodge.path_limit=maxf(260.0,SaveData.equipped_whip_reach())
 player.can_jump=HorseJump.capable(horse);player.jump_recovery_multiplier=HorseTraining.recovery(horse,"jump")
 gauges.jump.set_state(player.can_jump,1.-player._jump_cooldown/maxf(.01,1.2*player.jump_recovery_multiplier))
 gauges.dodge.set_state(player.dodge_available,1.-player.dodge_cooldown/maxf(.01,player.dodge_recharge_seconds))
 _ensure_spur_button(player,gauges)
 var host:Node=gauges.stamina.get_parent()
 if host.get_node_or_null("ScareButton265")==null:
  var button:=ScareButton265.new();button.player=player;host.add_child(button)
## Juanito's spurs button (Ant 16-nov): explicit button, shows cooldown and
## stamina cost before use. Lives next to the gauges; visible only when spurs
## are equipped. Bound once per host; the rider node survives mount changes.
static func _ensure_spur_button(player:CharacterBody2D,gauges:Dictionary)->void:
 if gauges.is_empty() or not player.has_method("try_activate_spurs"):return
 var first:Variant=gauges.values()[0]
 if first==null or not is_instance_valid(first):return
 var host:Node=first.get_parent()
 if host==null or host.get_node_or_null("SpurButton243")!=null:return
 var button:=SpurButton243.new();button.name="SpurButton243";button.player=player;host.add_child(button)
static func stamina(player:CharacterBody2D,gauges:Dictionary,state:Dictionary,delta:float,on_road:bool,nutrition_mult:float=1.0)->Dictionary:
 if "spurs_world_enabled243" in player:player.spurs_world_enabled243=true
 var next:=WorldStamina.tick(state,player.gait,player.velocity.length()>12.,delta,on_road,nutrition_mult,EquipmentEffects.running_drain_multiplier())
 if "stamina_state243" in player:player.stamina_state243=next
 if "stamina_forced243" in player:player.stamina_forced243=float(next.get("forced_left",0.0))>0.0
 if "stamina_ratio243" in player:player.stamina_ratio243=WorldStamina.ratio(next)
 player.gait_cap=WorldStamina.cap_gait(next,WorldGait.GALOPE);gauges.stamina.set_state(true,WorldStamina.ratio(next));return next
