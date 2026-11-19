class_name TownContent318
extends RefCounted
## Bounds of the actual outdoor buildings, named figures, labels and access space.
static func sprite_box(texture:Texture2D,feet:Vector2,height:float)->Rect2:
 var width:float=texture.get_width()*height/texture.get_height()
 return Rect2(feet-Vector2(width*.5,height),Vector2(width,height))
static func boxes(seed_:int,id:String,door:Vector2)->Array:
 var out:Array=[]
 if id=="home":
  var doors_:Dictionary=WorldTerrain103.plan(seed_).doors
  for house in ["house_west","house_east"]:
   out.append(sprite_box(WorldTestZone.HOUSE_TEX,ModularWorldLayout93.world(doors_[house])+Vector2(18.2,0),116.))
  var ranch:Vector2=ModularWorldLayout93.world(doors_.ranch)
  out.append(sprite_box(load('res://src/Presentation/world_ranch.gd').BARN_TEX,ranch+Vector2(8,0),120.))
  out.append(sprite_box(load("res://art/breeding256/saddlery-exterior.png"),Vector2(1500,650),350.))
  out.append(Rect2(Vector2(1380,666),Vector2(300,30)))
  var florist:Vector2=ModularWorldLayout93.world(doors_.florist)
  out.append(sprite_box(WorldFloristShop.SHOP,florist+Vector2(-30,2),200.))
  out.append(Rect2(florist+Vector2(-300,0),Vector2(600,100))) # Flower displays.
  var figures:Array=[ranch+Vector2(100,80),florist,Vector2(900,650),Vector2(1500,650),ranch+Vector2(-180,170),ranch+Vector2(160,170)]
  for point in figures:out.append(Rect2(point+Vector2(-100,-105),Vector2(200,150)))
  var origin:Vector2=ranch+Vector2(90,100) if SaveData.world_generator_version>=6 else florist
  var anchors:Dictionary=SaveData.world_garden212.get('anchors',{}) if SaveData.world_seed==seed_ else {}
  var plot:Vector2=anchors.get('plot',origin+Vector2(-520,420))
  var sample:Vector2=anchors.get('sample',origin+Vector2(-650,-480))
  out.append(Rect2(plot+Vector2(-190,-110),Vector2(400,270)))
  out.append(Rect2(sample+Vector2(-120,-60),Vector2(250,110)))
  out.append(Rect2(origin+Vector2(-110,-100),Vector2(220,150)))
  for point in Garden212.lane214(plot):out.append(Rect2(point-Vector2.ONE*40.,Vector2.ONE*80.))
  out.append(Rect2(Vector2(1540,410),Vector2(120,120))) # Existing central access junction.
 else:
  if SaveData.world_generator_version>=6:
   for x in [-380.,380.]:out.append(sprite_box(WorldTestZone.HOUSE_TEX,door+Vector2(x,-130),116.))
   var node:Dictionary=TownNetwork234.nodes(seed_)[id]
   for role in node.roles:
    var point:Vector2=TownNetwork234.point(seed_,id,role)
    out.append(Rect2(point+Vector2(-75,-105),Vector2(150,135)))
    var label_width:float=ThemeDB.fallback_font.get_string_size(TownNetwork234.npc_name(id,role),HORIZONTAL_ALIGNMENT_LEFT,-1,17).x
    out.append(Rect2(point+Vector2(-80,10),Vector2(label_width,28)))
  else:
   for x in [-210.,210.]:out.append(sprite_box(WorldTestZone.HOUSE_TEX,door+Vector2(x,-48),116.))
   out.append(Rect2(door+Vector2(-530,-245),Vector2(700,420))) # Cousin figure and signs.
   out.append(Rect2(door+Vector2(10,-75),Vector2(210,150)))
   if id=="east138":
    out.append(sprite_box(WorldFloristShop.SHOP,door+Vector2(-20,2),200.))
    for x in [-550.,550.]:out.append(sprite_box(WorldTestZone.HOUSE_TEX,door+Vector2(x,-260),116.))
    out.append(Rect2(door+Vector2(-300,-30),Vector2(600,100)))
  out.append(Rect2(door+Vector2(-80,80),Vector2(160,160))) # Rider turning space and south road start.
 return out
static func bounds(seed_:int,id:String,door:Vector2)->Rect2:
 var footprints:Array=boxes(seed_,id,door);var result:Rect2=footprints[0]
 for box in footprints:result=result.merge(box)
 var neighbourhood:Rect2=result.grow(400.)
 for edit in (SaveData.world_edits if SaveData.world_seed==seed_ else []):
  if edit.get("type","")=="add_decor" and edit.get("pos") is Vector2 and neighbourhood.has_point(edit.pos):
   result=result.merge(Rect2(edit.pos+Vector2(-120,-260),Vector2(240,300)))
 return result
