class_name EquipmentAttributes306
extends RefCounted
## Each scale spans the real baseline and the best available item of its kind.
static func specs(id:String)->Array:
 var item:Dictionary=EquipmentCatalog.ITEMS.get(id,{})
 var rows:Array=[]
 if item.has('scare_level265'):
  var s:=AnimalScare265.for_quality305(int(item.scare_level265))
  rows=[AttributeRanges306.spec('Alcance del ruido',s.radius,'noise_reach'),AttributeRanges306.spec('Duración del efecto',s.seconds,'noise_duration'),AttributeRanges306.spec('Rapidez de recarga',5.-s.cooldown,'noise_recharge')]
 elif item.has('reach'):rows=[AttributeRanges306.spec('Alcance del regate',item.reach,'feint_reach')]
 elif item.has('small_lasso_range'):rows=[AttributeRanges306.spec('Alcance del lazo',item.small_lasso_range,'lasso_reach'),AttributeRanges306.spec('Facilidad de captura',80.,'lasso_tolerance')]
 elif item.has('running_drain_mult'):rows=[AttributeRanges306.spec('Ahorro de esfuerzo',1.-item.running_drain_mult,'effort_saving')]
 elif item.has('dodge_recharge_mult'):rows=[AttributeRanges306.spec('Rapidez de recarga',1.-item.dodge_recharge_mult,'dodge_recharge')]
 elif item.has('stun_mult'):rows=[AttributeRanges306.spec('Recuperación del golpe',1.-item.stun_mult,'stun_recovery')]
 elif item.has('spur_boost'):rows=[AttributeRanges306.spec('Impulso',item.spur_boost,'spur_boost'),AttributeRanges306.spec('Duración del impulso',item.spur_seconds,'spur_duration'),AttributeRanges306.spec('Rapidez de recarga',8.-item.spur_cooldown,'spur_recharge'),AttributeRanges306.spec('Ahorro de resistencia',.15-item.spur_stamina_cost,'stamina_saving')]
 return rows
static func current_id(id:String)->String:
 var item:Dictionary=EquipmentCatalog.ITEMS[id]
 return str(SaveData.equipment_equipped.get(item.slot,''))
static func value_for(id:String,title:String)->float:
 for row in specs(id):
  if row[0]==title:return clampf(inverse_lerp(row[2],row[3],row[1]),0.,1.)
 return 0.
static func create(host:Node,id:String,width:float,compare:bool=true)->VBoxContainer:
 var column:=VBoxContainer.new();column.name='Attributes306';column.custom_minimum_size.x=width;column.size_flags_horizontal=Control.SIZE_EXPAND_FILL;column.add_theme_constant_override('separation',3);host.add_child(column)
 var current:String=current_id(id)
 for spec in specs(id):
  var line:=HorseStatBars.row(column,spec[0],spec[1],spec[2],spec[3],true)
  line.get_child(0).custom_minimum_size.x=190
  var bar:AttributeBar306=line.get_child(1)
  bar.baseline306=value_for(current,spec[0]) if compare else -1.
 return column
