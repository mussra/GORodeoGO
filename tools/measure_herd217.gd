extends Node
func _ready():run.call_deferred()
func run():
 var towns:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));var state:=HerdTown217.fresh(752026,towns,[],{},[])
 var count:int=0;var before_bonus:float=0.;var after_bonus:float=0.;var before_two:int=0;var after_two:int=0;var patterns:int=0;var coats:int=0
 var town:String="home";var look:=TownIdentity215.look(towns,town);var center:Vector2=towns.doors[town]
 var equipped:Dictionary={"coat":look.coat,"pattern":look.pattern,"mane":0}
 for index in 2500:
  var rng:=RandomNumberGenerator.new();rng.seed=index+117
  var base:Dictionary={"pos":center+Vector2.from_angle(rng.randf()*TAU)*rng.randf_range(0.,1000.),"traits":{"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,11),"mane":rng.randi_range(0,5),"eyes":rng.randi_range(0,21),"finish":"normal"},"temperament":rng.randf(),"stats":{"speed":280.}}
  var old:=WorldHerd.members(base,752026,index,900,false);var next:=HerdTown217.colored(old,state,index,900)
  for i in old.size():
   var a:=WorldTaming.affinity_matches(equipped,old[i].traits);var b:=WorldTaming.affinity_matches(equipped,next[i].traits)
   before_bonus+=WorldTaming.affinity_bonus(a);after_bonus+=WorldTaming.affinity_bonus(b)
   if a>=2:before_two+=1
   if b>=2:after_two+=1
   if next[i].traits.pattern==look.pattern:patterns+=1
   if next[i].traits.coat==look.coat:coats+=1
   count+=1
 var stats:Dictionary={"sample_horses":count,"sample_herds":2500,"radius":1000,"town":TownIdentity215.title(towns,town),"equipped":equipped,"baseline_mean_lasso_multiplier":before_bonus/count,"local_mean_lasso_multiplier":after_bonus/count,"baseline_two_plus_pct":100.*before_two/count,"local_two_plus_pct":100.*after_two/count,"actual_local_pattern_pct":100.*patterns/count,"actual_local_coat_pct":100.*coats/count,"no_bonus_cap_change":true}
 print("HERD217_BALANCE "+JSON.stringify(stats))
 var f:=FileAccess.open("/downloads/herd217-balance.json",FileAccess.WRITE);f.store_string(JSON.stringify(stats,"  "));f.close();get_tree().quit()
