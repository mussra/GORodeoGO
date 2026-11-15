extends Node
func _ready():run.call_deferred()
func run_option(pattern_rate:float,coat_rate:float)->Dictionary:
 var towns:=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]));var state:=HerdTown217.fresh(752026,towns,[],{},[])
 var count:int=0;var before_bonus:float=0.;var after_bonus:float=0.;var before_two:int=0;var after_two:int=0;var patterns:int=0;var coats:int=0;var before_time:float=0.;var after_time:float=0.
 var town:String="home";var look:=TownIdentity215.look(towns,town);var center:Vector2=towns.doors[town]
 var equipped:Dictionary={"coat":look.coat,"pattern":look.pattern,"mane":0}
 for index in 2500:
  var rng:=RandomNumberGenerator.new();rng.seed=index+117
  var base:Dictionary={"pos":center+Vector2.from_angle(rng.randf()*TAU)*rng.randf_range(0.,1000.),"traits":{"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,11),"mane":rng.randi_range(0,5),"eyes":rng.randi_range(0,21),"finish":"normal"},"temperament":rng.randf(),"stats":{"speed":280.}}
  var old:=WorldHerd.members(base,752026,index,900,false);var next:=colored_option(old,state,index,900,pattern_rate,coat_rate)
  for i in old.size():
   var a:=WorldTaming.affinity_matches(equipped,old[i].traits);var b:=WorldTaming.affinity_matches(equipped,next[i].traits)
   before_bonus+=WorldTaming.affinity_bonus(a);after_bonus+=WorldTaming.affinity_bonus(b)
   var rate:float=WorldTaming.HOLD_FILL*(1.-float(old[i].temperament)*.5)
   before_time+=1./(rate*WorldTaming.affinity_bonus(a));after_time+=1./(rate*WorldTaming.affinity_bonus(b))
   if a>=2:before_two+=1
   if b>=2:after_two+=1
   if next[i].traits.pattern==look.pattern:patterns+=1
   if next[i].traits.coat==look.coat:coats+=1
   count+=1
 var stats:Dictionary={"sample_horses":count,"sample_herds":2500,"radius":1000,"town":TownIdentity215.title(towns,town),"equipped":equipped,"baseline_mean_lasso_multiplier":before_bonus/count,"local_mean_lasso_multiplier":after_bonus/count,"baseline_two_plus_pct":100.*before_two/count,"local_two_plus_pct":100.*after_two/count,"actual_local_pattern_pct":100.*patterns/count,"actual_local_coat_pct":100.*coats/count,"no_bonus_cap_change":true,"pattern_rate":pattern_rate,"coat_rate":coat_rate,"baseline_mean_hold_seconds":before_time/count,"local_mean_hold_seconds":after_time/count}
 return stats
func run():
 var all_:Array=[]
 for rates in [[.70,.60],[.50,.40],[.35,.30]]:
  var row:=run_option(rates[0],rates[1]);all_.append(row);print("BALANCE221 ",JSON.stringify(row))
 var f:=FileAccess.open("/tmp/deep-research/rancho-balance221/affinity.json",FileAccess.WRITE);f.store_string(JSON.stringify(all_,"  "));f.close();get_tree().quit()
static func colored_option(members_:Array,state:Dictionary,cx:int,cy:int,pattern_rate:float,coat_rate:float)->Array:
 var out:Array=members_.duplicate(true)
 if out.is_empty() or not HerdTown217.eligible(state,cx,cy):return out
 var point:Vector2=out[0].pos;var family:=HerdTown217.influence(state.towns,point)
 if family.total<=0.:return out
 var rng:=RandomNumberGenerator.new();rng.seed=hash("herd-town217-v1-%d-%d-%d"%[state.seed,cx,cy])
 var first:Dictionary={}
 for i in out.size():
  var pick:float=rng.randf()*family.total;var town:String=family.rows[-1].id
  for row in family.rows:
   pick-=row.weight
   if pick<=0.:town=row.id;break
  var look:=TownIdentity215.look(state.towns,town);var traits:Dictionary=out[i].traits
  if rng.randf()<pattern_rate*family.strength:traits.pattern=int(look.pattern)
  var roll:float=rng.randf()
  if roll<coat_rate*family.strength:traits.coat=int(look.coat)
  elif roll<(coat_rate+.25)*family.strength:
   var nearby:=HerdTown217.near_colors(int(look.coat));traits.coat=nearby[rng.randi_range(0,nearby.size()-1)]
  if rng.randf()<.60*family.strength:traits.spots=int(look.get("spot_index",1))
  else:traits.spots=WorldHerd.contrasting_spots(int(traits.coat),rng.randi())
  if int(traits.spots)==int(traits.coat):traits.spots=WorldHerd.contrasting_spots(int(traits.coat),rng.randi())
  if i==0:first=traits.duplicate(true)
 # At least one visible difference, even when the random draws chose one family.
 if out.size()>=3 and out.all(func(h):return int(h.traits.coat)==int(first.coat) and int(h.traits.pattern)==int(first.pattern) and int(h.traits.spots)==int(first.spots)):
  var palette:=HerdTown217.near_colors(int(first.coat));out[-1].traits.coat=palette[0]
 return out
