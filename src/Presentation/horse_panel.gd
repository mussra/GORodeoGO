class_name HorsePanel
extends Control
var canvas:Control
var content:Control
var message:String=""
var page:String="collection"
var parent_a:String="original"
var parent_b:String="original"
var choices:Dictionary={"coat":0,"pattern":0,"mane":0,"eyes":0}
var focus_id:String="original"
var focus_preview:Dictionary={}
var atlas_page:int=0
var atlas_owned_first:bool=true
var scroll_to_newest:bool=false
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
 _refresh.call_deferred()
func _refresh()->void:
 if not is_inside_tree():return
 if content!=null:canvas.remove_child(content);content.queue_free()
 content=Control.new();canvas.add_child(content)
 label("ENSAYO AISLADO · COPIA TEMPORAL" if SaveData.trial_session_active else "CABALLERIZA · PROTOTIPO DE CRÍA",Vector2(30,20),30)
 button("VOLVER",Vector2(1050,20),hide,200)
 button("COLECCIÓN",Vector2(30,75),func():show_page("collection"))
 button("CRUZAR",Vector2(275,75),func():show_page("breed"))
 button("ATLAS · PRUEBA",Vector2(520,75),func():show_page("atlas"))
 button("AÑADIR 2 DE PRUEBA",Vector2(795,75),func():
  if not SaveData.trial_session_active and not SaveData.begin_trial_session():
   message="No se pudo abrir el ensayo aislado";refresh();return
  var added:Array[Dictionary]=SaveData.horse_collection.add_random_trial_pair();parent_b=added[0].id;page="collection";scroll_to_newest=true;message="Añadidos 2 aleatorios · Total: %d caballos · solo en ensayo"%SaveData.horse_collection.horses.size();refresh(),360)
 label("PRUEBA: padres intactos, sin coste. Valores de ensayo. Reglas de herencia provisionales.",Vector2(30,138),20)
 match page:
  "collection":collection_view()
  "breed":breed_view()
  "family":family_view()
  "atlas":atlas_view()
  "detail":detail_view()
 label(message,Vector2(30,625),22)
 label("Rareza: categorías previstas, aún sin asignar. Silla y complementos NO se heredan.",Vector2(30,675),18)
func sprite(h:Dictionary,pos:Vector2,size_px:float=130)->void:
 var tex:=TextureRect.new();tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 if h.get("stage","adult")=="foal":tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits)
 else:HorsePortrait.apply(tex,h.traits,SaveData.hat_color)
 tex.position=pos;tex.size=Vector2.ONE*size_px;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;content.add_child(tex)
func collection_view()->void:
 label("%d CABALLOS EN LA COLECCIÓN"%SaveData.horse_collection.horses.size(),Vector2(30,162),18)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(30,185);scroll.size=Vector2(1210,420);content.add_child(scroll)
 var rows:=VBoxContainer.new();rows.custom_minimum_size.x=1170;scroll.add_child(rows)
 for h in SaveData.horse_collection.horses:
  var row:=HBoxContainer.new();row.custom_minimum_size.y=100;rows.add_child(row)
  var tex:=TextureRect.new();tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits) if not SaveData.horse_collection.is_adult(h.id) else HorsePortrait.ART;tex.material=HorsePortrait.material_for(h.traits,SaveData.hat_color) if SaveData.horse_collection.is_adult(h.id) else null;tex.custom_minimum_size=Vector2(96,96);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(tex)
  var l:=Label.new();l.text="%s%s\n%s · %s · crin %s"%[h.name," · POTRILLO" if h.get("stage","adult")=="foal" else "",HorseCollection.COATS[h.traits.coat],HorseCollection.PATTERNS[h.traits.pattern],HorseCollection.MANES[h.traits.mane]];l.custom_minimum_size.x=670;row.add_child(l)
  var eq:=Button.new();eq.text="EQUIPADO" if SaveData.horse_collection.selected==h.id else "EQUIPAR";eq.disabled=SaveData.horse_collection.selected==h.id or not SaveData.horse_collection.is_adult(h.id);row.add_child(eq);eq.pressed.connect(func():
   message=("Equipado solo en ensayo" if SaveData.trial_session_active else "Caballo equipado") if SaveData.select_horse(h.id) else "No se pudo guardar";refresh())
  var fam:=Button.new();fam.text="FICHA";row.add_child(fam);fam.pressed.connect(func():focus_id=h.id;show_page("detail"))
 if scroll_to_newest:
  scroll_to_newest=false
  scroll.set_deferred("scroll_vertical",2147483647)
func thumbnail(h:Dictionary)->Texture2D:
 var foal:bool=h.get("stage","adult")=="foal"
 var source:Texture2D=load("res://art/foal/base.png" if foal else "res://art/player/walk_diag_down/frame_00.png")
 return HorseAppearance.texture(source,"foal" if foal else "walk_diag_down",0,h.traits)
func parent_picker(id:String,pos:Vector2,is_a:bool)->void:
 var pick:=OptionButton.new();pick.position=pos;pick.size=Vector2(370,64);pick.add_theme_constant_override("icon_max_width",56);pick.get_popup().add_theme_constant_override("icon_max_width",56);content.add_child(pick)
 for h in SaveData.horse_collection.horses:
  pick.add_icon_item(thumbnail(h),h.name);pick.set_item_metadata(pick.item_count-1,h.id)
  pick.set_item_disabled(pick.item_count-1,not SaveData.horse_collection.is_adult(h.id))
  if h.id==id:pick.select(pick.item_count-1)
 pick.item_selected.connect(func(i:int):
  if is_a:parent_a=str(pick.get_item_metadata(i))
  else:parent_b=str(pick.get_item_metadata(i))
  refresh())
func breed_view()->void:
 label("PROGENITOR A",Vector2(40,185));label("PROGENITOR B",Vector2(840,185))
 parent_picker(parent_a,Vector2(40,220),true);parent_picker(parent_b,Vector2(840,220),false)
 sprite(SaveData.horse_collection.find(parent_a),Vector2(110,310),105)
 sprite(SaveData.horse_collection.find(parent_b),Vector2(1045,310),105)
 label("ELIGE RASGOS PARA ESTA PRUEBA",Vector2(390,185),21)
 var labels={"coat":"Pelaje","pattern":"Manchas","mane":"Crin y cola","eyes":"Ojos"};var n:int=0
 for k in ["coat","pattern","mane","eyes"]:
  label(labels[k],Vector2(420,230+n*50),20)
  button("A" if choices[k]==0 else "B",Vector2(670,218+n*50),func():choices[k]=1-int(choices[k]);refresh(),65);n+=1
 var t:Dictionary=SaveData.horse_collection.preview(parent_a,parent_b,choices)
 if not t.is_empty():
  sprite({"traits":t,"stage":"foal"},Vector2(505,375),200)
  button("CREAR CRÍA DE PRUEBA",Vector2(440,570),func():
   var h:Dictionary=SaveData.breed_horses(parent_a,parent_b,choices)
   message="No se pudo crear/guardar" if h.is_empty() else "%s creada. Ambos padres conservados."%h.name
   if not h.is_empty():focus_id=h.id
   refresh(),390)
 else:label("Elige dos caballos distintos",Vector2(440,500),24)
func family_view()->void:
 var h:Dictionary=SaveData.horse_collection.find(focus_id)
 if h.is_empty():return
 label("RANCHO FAMILIAR · "+h.name,Vector2(40,185),26);sprite(h,Vector2(475,250),320)
 label(h.name+(" · POTRILLO" if not SaveData.horse_collection.is_adult(h.id) else " · ADULTO"),Vector2(475,580),24)
 if h.parents.is_empty():label("Caballo fundador de prueba. Sin ascendencia registrada.",Vector2(340,300),22)
 else:
  for i in range(2):
   var p:Dictionary=SaveData.horse_collection.find(h.parents[i]);var x:float=300+i*450
   sprite(p,Vector2(90 if i==0 else 1060,300),100)
   button(p.name+" · VER RAMA",Vector2(35 if i==0 else 965,420),func():focus_id=p.id;refresh(),280)
  label("A + B → CRÍA · sin distinguir sexos",Vector2(420,615),18)

func detail_view()->void:
 var h:Dictionary=SaveData.horse_collection.find(focus_id)
 var is_owned:bool=not h.is_empty()
 if not is_owned:h=focus_preview
 if h.is_empty():return
 if not is_owned:
  label(h.name+" · ASPECTO NO ADQUIRIDO",Vector2(40,185),28);sprite(h,Vector2(60,245),300)
  label("Pelaje: "+HorseCollection.COATS[h.traits.coat]+"\nManchas: "+HorseCollection.PATTERNS[h.traits.pattern]+"\nCrin: "+HorseCollection.MANES[h.traits.mane],Vector2(450,250),26)
  label("Vista de catálogo. No seleccionable hasta obtenerlo.",Vector2(450,430),22)
  button("VOLVER AL ATLAS",Vector2(450,510),func():show_page("atlas"),340)
  return
 var title:=label(h.name,Vector2(40,175),27);title.size.x=365;title.clip_text=true
 sprite(h,Vector2(70,250),235)
 var name_edit:=LineEdit.new();name_edit.text=h.name;name_edit.placeholder_text="Nombre del caballo";name_edit.max_length=60;name_edit.position=Vector2(40,485);name_edit.size=Vector2(200,48);content.add_child(name_edit)
 button("GUARDAR",Vector2(245,485),func():
  message="Nombre guardado" if SaveData.rename_horse(h.id,name_edit.text) else "Escribe un nombre (máximo 60 caracteres) / revisa guardado";refresh(),160)
 if SaveData.horse_collection.is_adult(h.id):
  var equip:=button("EQUIPADO" if SaveData.horse_collection.selected==h.id else "SELECCIONAR CABALLO",Vector2(40,545),func():
   message="Caballo seleccionado" if SaveData.select_horse(h.id) else "No se pudo guardar";refresh(),360)
  equip.disabled=SaveData.horse_collection.selected==h.id
 label("Pelaje: "+HorseCollection.COATS[h.traits.coat]+"\nManchas: "+HorseCollection.PATTERNS[h.traits.pattern]+"\nCrin/cola: "+HorseCollection.MANES[h.traits.mane],Vector2(420,220),24)
 var st:Dictionary=HorseStats.read(h)
 label("Ojos: %s\nVALORES PROVISIONALES\nVelocidad base: %.0f px/s\nManejabilidad: %.0f px/s²\nPotencia: conserva %.0f%% con 2 toros\nRegate: %.0f%% del alcance de la fusta"%[HorseCollection.EYES[HorseCollection.eye_index(h.traits)],st.speed,st.handling,st.power*100,st.dodge*100],Vector2(420,340),22)
 if not SaveData.horse_collection.is_adult(h.id):
  label("POTRILLO: no puede trabajar ni criar. Plazo por definir.",Vector2(560,505),18)
  button("ENSAYO: CRECER Y ADIESTRAR",Vector2(40,545),func():
   message="Adulto de ensayo, sin esperar ni pagar" if SaveData.mature_horse_trial(h.id) else "No se pudo guardar";refresh(),360)
 label("Fusta: no aplicable mientras es potrillo" if not SaveData.horse_collection.is_adult(h.id) else "Capacidad de lazo intacta. Alcance equipado de fusta: %d px"%SaveData.equipped_whip_reach(),Vector2(560,535),18)
 button("VER PARENTESCO · PRUEBA",Vector2(420,570),func():show_page("family"),420)
func atlas_entries()->Array[Dictionary]:
 var result:Array[Dictionary]=[];var owned:Dictionary={}
 for h in SaveData.horse_collection.horses:
  result.append({"horse":h,"owned":true})
  owned["%d_%d_%d"%[h.traits.coat,h.traits.pattern,h.traits.mane]]=true
 if not atlas_owned_first:
  result.clear()
 for n in range(600):
  var t:Dictionary={"coat":int(n/30),"pattern":int(n/6)%5,"mane":n%6}
  if not atlas_owned_first or not owned.has("%d_%d_%d"%[t.coat,t.pattern,t.mane]):result.append({"horse":{"traits":t,"name":HorseCollection.COATS[t.coat],"stage":"adult"},"owned":false})
 if not atlas_owned_first:
  for entry in result:
   var t:Dictionary=entry.horse.traits
   for h in SaveData.horse_collection.horses:
    if h.traits.coat==t.coat and h.traits.pattern==t.pattern and h.traits.mane==t.mane:
     entry.horse=h;entry.owned=true;break
 return result
func atlas_view()->void:
 label("ATLAS DE CABALLOS",Vector2(35,170),25)
 button("ORDEN: LOS MÍOS PRIMERO" if atlas_owned_first else "ORDEN: ATLAS NORMAL",Vector2(765,165),func():atlas_owned_first=not atlas_owned_first;atlas_page=0;refresh(),470)
 label("Colección propia y después aspectos candidatos. Sin rutas de obtención ni rarezas aprobadas.",Vector2(35,208),18)
 var entries:Array[Dictionary]=atlas_entries();var pages:int=ceili(entries.size()/8.0);atlas_page=clampi(atlas_page,0,pages-1)
 for j in range(8):
  var n:int=atlas_page*8+j
  if n>=entries.size():break
  var entry:Dictionary=entries[n];var h:Dictionary=entry.horse;var t:Dictionary=h.traits
  var x:float=35+(j%4)*305;var y:float=250+int(j/4)*160
  sprite(h,Vector2(x,y),90)
  var title:=label(("✓ " if entry.owned else "? ")+h.name,Vector2(x+92,y),18);title.size=Vector2(205,30);title.clip_text=true
  label(HorseCollection.PATTERNS[t.pattern]+"\nCrin "+HorseCollection.MANES[t.mane],Vector2(x+92,y+32),16)
  var open:=Button.new();open.flat=true;open.position=Vector2(x,y);open.size=Vector2(295,130);open.tooltip_text="Abrir ficha";content.add_child(open);open.pressed.connect(func():focus_id=str(h.get("id",""));focus_preview=h;show_page("detail"))
  if not entry.owned:label("No disponible",Vector2(x+92,y+87),16)
 button("ANTERIOR",Vector2(35,575),func():atlas_page=maxi(0,atlas_page-1);refresh())
 label("Página %d / %d"%[atlas_page+1,pages],Vector2(345,585),23)
 button("SIGUIENTE",Vector2(650,575),func():atlas_page=mini(pages-1,atlas_page+1);refresh())
