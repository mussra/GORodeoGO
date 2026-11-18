class_name AttributeRanges306
extends RefCounted
## Display bounds only. Never changes simulation, saves, prices or rewards.
const SECTORS=5
const HORSE_STATS=[["Velocidad","speed",240.,300.],["Manejo","handling",600.,1500.],["Fuerza","power",.5,.9],["Agilidad","dodge",.75,1.],["Serenidad","calm",.5,2.]]
const LOW=0.
const HIGH=100.
const RANGES={
 "noise_reach":[0.,310.],"noise_duration":[0.,1.4],"noise_recharge":[0.,1.],
 "feint_reach":[0.,420.],"lasso_reach":[1.,1.5],"lasso_tolerance":[58.,80.],
 "effort_saving":[0.,.1],"dodge_recharge":[0.,.1],"stun_recovery":[0.,.1],
 "spur_boost":[0.,.1],"spur_duration":[0.,1.3],"spur_recharge":[0.,1.],"stamina_saving":[0.,.15],
 "learning":[LOW,HIGH],"mastery":[LOW,HIGH],"affinity":[LOW,HIGH],"lineage":[LOW,HIGH],"summary":[LOW,HIGH],"crossing_calm":[0.,.13]
}
static func spec(title:String,value:float,key:String)->Array:
 var bounds:Array=RANGES[key]
 return [title,value,bounds[0],bounds[1]]
