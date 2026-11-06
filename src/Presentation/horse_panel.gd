class_name HorsePanel
extends Control
var canvas:Control
var content:Control
var message:String=""
var page:String="collection"
var parent_a:String="original"
var parent_b:String="original"
var choices:Dictionary={"coat":0,"pattern":0,"mane":0}
var focus_id:String="original"
var atlas_page:int=0
var preview_playing:bool=true
var preview_texture:TextureRect
var preview_frames:Array[Texture2D]=[]
var preview_clock:float=0.0
func _process(delta:float)->void:
 if not visible or page!="detail" or not preview_playing or not is_instance_valid(preview_texture) or preview_frames.is_empty():return
 preview_clock+=delta
 preview_texture.texture=preview_frames[int(preview_clock*16.0)%preview_frames.size()]
func _ready()->void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=80
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 resized.connect(layout);layout();refresh()
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func label(text:String,pos:Vector2,font:int=22)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);content.add_child(l);return l
func button(text:String,pos:Vector2,cb:Callable,w:float=230)->Button:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(w,48);b.pressed.connect(cb);content.add_child(b);return b
func show_page(value:String)->void:
 page=value;message="";refresh()
func refresh()->void:
 if content!=null:canvas.remove_child(content);content.queue_free()
 preview_texture=null;preview_frames.clear();preview_clock=0
 content=Control.new();canvas.add_child(content)
 label("CABALLERIZA · PROTOTIPO DE CRÍA",Vector2(30,20),30)
 button("VOLVER",Vector2(1050,20),hide,200)
 button("COLECCIÓN",Vector2(30,75),func():show_page("collection"))
 button("CRUZAR",Vector2(275,75),func():show_page("breed"))
 button("ATLAS · PRUEBA",Vector2(520,75),func():show_page("atlas"))
 button("AÑADIR 2 DE PRUEBA",Vector2(795,75),func():
  SaveData.horse_collection.add_trial_parents();parent_b="trial_a";refresh(),360)
 label("PRUEBA: padres intactos, sin coste. Valores de ensayo. Reglas de herencia provisionales.",Vector2(30,138),20)
 match page:
  "collection":collection_view()
  "breed":breed_view()
  "family":family_view()
  "atlas":atlas_view()
  "detail":detail_view()
 label(message,Vector2(30,625),22)
 label("Rareza: categorías previstas, aún sin asignar. Silla y complementos NO se heredan.",Vector2(30,675),18)
func sprite(h:Dictionary,pos:Vector2,size_px:float=130)->TextureRect:
 if h.get("stage","adult")=="foal":size_px*=0.62
 var t:Texture2D=load("res://art/foal/base.png") if h.get("stage","adult")=="foal" else load("res://art/player/walk_side/frame_00.png")
 var tex:=TextureRect.new();tex.texture=HorseAppearance.texture(t,"foal" if h.get("stage","adult")=="foal" else "walk_side",0,h.traits);tex.position=pos;tex.size=Vector2.ONE*size_px;tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;content.add_child(tex);return tex
func collection_view()->void:
 var scroll:=ScrollContainer.new();scroll.position=Vector2(30,185);scroll.size=Vector2(1210,420);content.add_child(scroll)
 var rows:=VBoxContainer.new();rows.custom_minimum_size.x=1170;scroll.add_child(rows)
 for h in SaveData.horse_collection.horses:
  var row:=HBoxContainer.new();row.custom_minimum_size.y=100;rows.add_child(row)
  var tex:=TextureRect.new();tex.texture=HorseAppearance.texture(load("res://art/foal/base.png") if not SaveData.horse_collection.is_adult(h.id) else load("res://art/player/walk_side/frame_00.png"),"foal" if not SaveData.horse_collection.is_adult(h.id) else "walk_side",0,h.traits);tex.custom_minimum_size=Vector2(96,96);row.add_child(tex)
  var l:=Label.new();l.text="%s%s\n%s · %s · crin %s"%[h.name," · POTRILLO" if h.get("stage","adult")=="foal" else "",HorseCollection.COATS[h.traits.coat],HorseCollection.PATTERNS[h.traits.pattern],HorseCollection.MANES[h.traits.mane]];l.custom_minimum_size.x=670;row.add_child(l)
  var eq:=Button.new();eq.text="EQUIPADO" if SaveData.horse_collection.selected==h.id else "EQUIPAR";eq.disabled=SaveData.horse_collection.selected==h.id or not SaveData.horse_collection.is_adult(h.id);row.add_child(eq);eq.pressed.connect(func():
   message="Caballo equipado" if SaveData.select_horse(h.id) else "No se pudo guardar";refresh())
  var fam:=Button.new();fam.text="FICHA";row.add_child(fam);fam.pressed.connect(func():focus_id=h.id;show_page("detail"))
func parent_picker(id:String,pos:Vector2,is_a:bool)->void:
 var pick:=OptionButton.new();pick.position=pos;pick.size=Vector2(370,48);content.add_child(pick)
 for h in SaveData.horse_collection.horses:
  pick.add_item(h.name);pick.set_item_metadata(pick.item_count-1,h.id)
  pick.set_item_disabled(pick.item_count-1,not SaveData.horse_collection.is_adult(h.id))
  if h.id==id:pick.select(pick.item_count-1)
 pick.item_selected.connect(func(i:int):
  if is_a:parent_a=str(pick.get_item_metadata(i))
  else:parent_b=str(pick.get_item_metadata(i))
  refresh())
func breed_view()->void:
 label("PROGENITOR A",Vector2(40,185));label("PROGENITOR B",Vector2(840,185))
 parent_picker(parent_a,Vector2(40,220),true);parent_picker(parent_b,Vector2(840,220),false)
 sprite(SaveData.horse_collection.find(parent_a),Vector2(150,290),150)
 sprite(SaveData.horse_collection.find(parent_b),Vector2(950,290),150)
 label("ELIGE RASGOS PARA ESTA PRUEBA",Vector2(390,185),21)
 var labels={"coat":"Pelaje","pattern":"Manchas","mane":"Crin y cola"};var n:int=0
 for k in ["coat","pattern","mane"]:
  label(labels[k],Vector2(420,240+n*62),20)
  button("A" if choices[k]==0 else "B",Vector2(670,228+n*62),func():choices[k]=1-int(choices[k]);refresh(),65);n+=1
 var t:Dictionary=SaveData.horse_collection.preview(parent_a,parent_b,choices)
 if not t.is_empty():
  sprite({"traits":t,"stage":"foal"},Vector2(550,420),150)
  button("CREAR CRÍA DE PRUEBA",Vector2(440,570),func():
   var h:Dictionary=SaveData.breed_horses(parent_a,parent_b,choices)
   message="No se pudo crear/guardar" if h.is_empty() else "%s creada. Ambos padres conservados."%h.name
   if not h.is_empty():focus_id=h.id
   refresh(),390)
 else:label("Elige dos caballos distintos",Vector2(440,500),24)
func family_view()->void:
 var h:Dictionary=SaveData.horse_collection.find(focus_id)
 if h.is_empty():return
 label("RANCHO FAMILIAR · "+h.name,Vector2(40,185),26);sprite(h,Vector2(535,400),150)
 label(h.name+(" · POTRILLO" if not SaveData.horse_collection.is_adult(h.id) else " · ADULTO"),Vector2(475,550),24)
 if h.parents.is_empty():label("Caballo fundador de prueba. Sin ascendencia registrada.",Vector2(340,300),22)
 else:
  for i in range(2):
   var p:Dictionary=SaveData.horse_collection.find(h.parents[i]);var x:float=300+i*450
   sprite(p,Vector2(x,245),130)
   button(p.name+" · VER RAMA",Vector2(x-60,375),func():focus_id=p.id;refresh(),280)
  label("A + B → CRÍA · sin distinguir sexos",Vector2(420,595),18)

func detail_view()->void:
 var h:Dictionary=SaveData.horse_collection.find(focus_id)
 if h.is_empty():return
 label(h.name.to_upper(),Vector2(40,195),30)
 var portrait:TextureRect=sprite(h,Vector2(70,260),270)
 if SaveData.horse_collection.is_adult(h.id):
  preview_texture=portrait
  var anim:String="walk_side"
  var paths:Array=SpriteSwap.new(null,null,"",[])._list_sorted_image_paths(HatAppearance.art_root(SaveData.hat_color).path_join(anim))
  for i in paths.size():preview_frames.append(HorseAppearance.texture(load(paths[i]),anim,i,h.traits))
  if not preview_frames.is_empty():portrait.texture=preview_frames[0]
  button("PAUSAR GALOPE" if preview_playing else "VER GALOPE",Vector2(40,550),func():preview_playing=not preview_playing;refresh(),330)
 label("Pelaje: "+HorseCollection.COATS[h.traits.coat]+"\nManchas: "+HorseCollection.PATTERNS[h.traits.pattern]+"\nCrin/cola: "+HorseCollection.MANES[h.traits.mane],Vector2(420,220),24)
 var st:Dictionary=HorseStats.read(h)
 label("VALORES PROVISIONALES\nVelocidad base: %.0f px/s\nManejabilidad: %.0f px/s²\nPotencia: conserva %.0f%% con 2 toros\nRegate: %.0f%% del alcance de la fusta"%[st.speed,st.handling,st.power*100,st.dodge*100],Vector2(420,340),22)
 if not SaveData.horse_collection.is_adult(h.id):
  label("POTRILLO: no puede trabajar ni criar. Plazo por definir.",Vector2(420,505),18)
  button("ENSAYO: CRECER Y ADIESTRAR",Vector2(40,550),func():
   message="Adulto de ensayo, sin esperar ni pagar" if SaveData.mature_horse_trial(h.id) else "No se pudo guardar";refresh(),360)
 label("Fusta: no aplicable mientras es potrillo" if not SaveData.horse_collection.is_adult(h.id) else "Capacidad de lazo intacta. Alcance equipado de fusta: %d px"%SaveData.equipped_whip_reach(),Vector2(420,535),20)
 button("VER PARENTESCO · PRUEBA",Vector2(420,570),func():show_page("family"),420)
func atlas_view()->void:
 label("ATLAS DE ASPECTOS · CATÁLOGO CANDIDATO",Vector2(35,185),25)
 label("600 combinaciones de diseño. No son rutas de obtención ni rarezas aprobadas.",Vector2(35,225),20)
 var owned:Dictionary={}
 for h in SaveData.horse_collection.horses:
  var t:Dictionary=h.traits;owned["%d_%d_%d"%[t.coat,t.pattern,t.mane]]=true
 for j in range(12):
  var n:int=atlas_page*12+j
  var coat:int=int(n/30);var pattern:int=int(n/6)%5;var mane:int=n%6
  var x:float=35+(j%4)*300;var y:float=275+int(j/4)*100
  var key:String="%d_%d_%d"%[coat,pattern,mane]
  label(("✓ " if owned.has(key) else "? ")+HorseCollection.COATS[coat],Vector2(x,y),21)
  label(HorseCollection.PATTERNS[pattern]+" / "+HorseCollection.MANES[mane],Vector2(x,y+30),17)
 button("ANTERIOR",Vector2(35,570),func():atlas_page=maxi(0,atlas_page-1);refresh())
 label("Página %d / 50"%(atlas_page+1),Vector2(345,580),23)
 button("SIGUIENTE",Vector2(650,570),func():atlas_page=mini(49,atlas_page+1);refresh())
