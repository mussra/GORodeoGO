extends Node
func _ready():run.call_deferred()
func label_at(host:Control,text_:String,at:Vector2,font_size:int=20)->Label:
 var label:=Label.new();label.text=text_;label.position=at;label.add_theme_font_size_override("font_size",font_size);host.add_child(label);return label
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,1000)
 SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_cousins140=VillageCousins140.fresh(752026,[],FloristJourney138.fresh([]))
 var state:=HerdTown217.fresh(752026,SaveData.world_cousins140,[],{},[])
 var town:String="home";var center:Vector2=state.towns.doors[town];var chosen:Array=[]
 for cy in range(-3,4):
  for cx in range(-3,4):
   var base:Dictionary=WorldMap.generate(752026,cx,cy).get("herd",{})
   if base.is_empty() or base.pos.distance_to(center)>2600.:continue
   chosen.append({"x":cx,"y":cy,"distance":base.pos.distance_to(center),"base":base})
 chosen.sort_custom(func(a,b):return a.distance<b.distance)
 var host:=Control.new();host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(host)
 var background:=ColorRect.new();background.color=Color("18302c");background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);host.add_child(background)
 label_at(host,"Tres manadas de la zona · "+TownIdentity215.title(state.towns,town),Vector2(40,24),25)
 label_at(host,"Comparativa QA con genes reales generados. No son caballos añadidos a tu partida.",Vector2(40,68),17)
 var icon:=TownIcon215.new();icon.look=TownIdentity215.look(state.towns,town);icon.position=Vector2(1080,14);icon.size=Vector2(140,100);host.add_child(icon)
 for n in mini(3,chosen.size()):
  var row:Dictionary=chosen[n];var members_:Array=HerdTown217.colored(WorldHerd.members(row.base,752026,row.x,row.y,false),state,row.x,row.y)
  var y:float=135+n*270
  label_at(host,"Manada %d · origen %d,%d · a %.0f unidades del pueblo"%[n+1,row.x,row.y,row.distance],Vector2(40,y),23)
  for i in members_.size():
   var h:Dictionary=members_[i];var texture:=PixelLabTrial.pose_texture("horse","side",0,h.traits)
   var rect:=TextureRect.new();rect.texture=texture;rect.position=Vector2(45+i*245,y+37);rect.size=Vector2(205,140);rect.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;rect.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;host.add_child(rect)
   label_at(host,HorseCollection.COATS[h.traits.coat]+" · "+HorseCollection.PATTERNS[h.traits.pattern],Vector2(40+i*245,y+185),19)
   label_at(host,"Manchas: "+HorseCollection.COATS[h.traits.spots],Vector2(40+i*245,y+215),17)
 label_at(host,"Más afinidad junto al pueblo; variación por individuo. Lejos de los pueblos se conserva la población original.",Vector2(40,970),20)
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/herd217-three-local-herds.png")
 get_tree().quit()
