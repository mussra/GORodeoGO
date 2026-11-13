class_name CountryMap148
extends WorldDiscoveryMap159
## Country data/terrain adapter only. Gestures, minimap, zoom, find, notes,
## clipping, player marker and site selection are WorldDiscoveryMap159.
var tree_visible155:bool=false
func cell_size159()->float:return CountryExploration148.CELL
func content_signature159()->int:return hash([world.seed,world.visited_cells,world.ledger.maps.water146.visited])
func available159()->Array[Dictionary]:
 var sites:=CountryExploration148.available(world.ledger,world.data)
 for site in sites:
  if site.id=="tree":site.pos=world.data.roots
 return sites
func notes159()->Dictionary:return world.ledger.maps.water146.notes
func flowers159()->Dictionary:return {}
func show_sites159()->void:
 world.close_modal(false);world.show_sites(true)
func choose159(id:String)->void:
 world.close_modal(false);world.choose_site.call_deferred(id,true)
func _cells()->Dictionary:
 var cells:Array=world.visited_cells.keys();var mins:=Vector2i.ZERO;var maxs:=Vector2i.ZERO
 if not cells.is_empty():
  mins=cells[0];maxs=cells[0]
  for c in cells:mins=mins.min(c);maxs=maxs.max(c)
 return {"cells":cells,"mins":mins,"maxs":maxs}
func _draw_terrain()->void:
 var area:Rect2=_map_geometry.area;_terrain.draw_set_transform(-area.position)
 if area.size.x<=0. or area.size.y<=0.:return
 var mins:Vector2i=_map_geometry.data.mins;var cell:float=_map_geometry.cell;var origin:Vector2=_map_geometry.origin
 for c in _map_geometry.data.cells:
  var box:=Rect2(Vector2(c)*cell_size159(),Vector2.ONE*cell_size159()).intersection(CountryRoute146.BOUNDS)
  var mapped:=Rect2(_to_map(box.position,mins,cell,origin),box.size/cell_size159()*cell)
  if not Rect2(Vector2.ZERO,size).grow(300.).intersects(mapped):continue
  _terrain.draw_rect(mapped,Color("227e9a"))
  var clip:=PackedVector2Array([box.position,Vector2(box.end.x,box.position.y),box.end,Vector2(box.position.x,box.end.y)])
  for land in Geometry2D.intersect_polygons(world.data.island,clip):
   var mapped_land:=PackedVector2Array()
   for vertex in land:mapped_land.append(_to_map(vertex,mins,cell,origin))
   if mapped_land.size()>=3:_terrain.draw_colored_polygon(mapped_land,Color("4d7947"))
  for entry in [[world.data.approach,Color("cb9d63"),3.],[world.data.bank,Color("cb9d63"),3.],[world.data.river,Color("6bb9c5"),6.]]:
   for segment in Geometry2D.intersect_polyline_with_polygon(entry[0],clip):
    for i in segment.size()-1:_terrain.draw_line(_to_map(segment[i],mins,cell,origin),_to_map(segment[i+1],mins,cell,origin),entry[1],entry[2],true)
 tree_visible155=world.ledger.maps.water146.visited.get("tree",false)
 if tree_visible155:
  var art:Rect2=world.data.tree_art
  _terrain.draw_texture_rect(CountryPreview146.TREE,Rect2(_to_map(art.position,mins,cell,origin),art.size/cell_size159()*cell),false)
 for site in available159():
  if expanded:_terrain.draw_string(get_theme_default_font(),_to_map(site.pos,mins,cell,origin)+Vector2(14,-10),site.name,HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("fff2c5"))

func minimap_top159()->float:return 114.
