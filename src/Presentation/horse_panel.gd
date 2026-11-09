class_name HorsePanel
extends Control
var canvas:Control
var content:Control
var message:String=""
var page:String="hub"
var detail_origin:String="collection"
var parent_a:String="original"
var parent_b:String="original"
var choices:Dictionary={"coat":0,"pattern":0,"mane":0,"eyes":0,"legs":0,"spots":0,"finish":0}
var focus_id:String="original"
var focus_preview:Dictionary={}
var atlas_family:Dictionary={}
var atlas_family_page:int=0
var atlas_page:int=0
var atlas_owned_first:bool=true
var atlas_filters:Dictionary={}
var scroll_to_newest:bool=false
func _ready()->void:
 MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=80
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 resized.connect(layout);layout();refresh()
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func label(text:String,pos:Vector2,font:int=22)->Label:
 var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);content.add_child(l);return l
func button(text:String,pos:Vector2,cb:Callable,w:float=230)->Button:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(w,48);b.pressed.connect(cb);content.add_child(b);return b
func show_page(value:String)->void:
 if value=="detail" and page!="detail":detail_origin=page
 page=value;message="";refresh()
func refresh()->void:
 _refresh.call_deferred()
func _refresh()->void:
 if not is_inside_tree():return
 if content!=null:canvas.remove_child(content);content.queue_free()
 content=Control.new();canvas.add_child(content);MenuNavigation.reveal(content)
 var titles={"hub":"CABALLERIZA","collection":"COLECCIÓN","breed":"CRUZAR","atlas":"ATLAS · FAMILIAS","atlas_variants":"ATLAS · VARIANTES","market":"MERCADO","detail":"FICHA"}
 MenuNavigation.header(content,str(titles.get(page,"CABALLERIZA")),go_back)
 if page=="hub":
  MenuNavigation.cards(content,[{"id":"collection","title":"Colección","hint":"Tus caballos"},{"id":"breed","title":"Cruzar","hint":"Elige padres y rasgos"},{"id":"atlas","title":"Atlas","hint":"Explora colores y patrones"},{"id":"market","title":"Mercado","hint":"Compra y venta"},{"id":"training","title":"Entrenamiento","hint":"Aprende habilidades"},{"id":"genealogy","title":"Mapa genealógico","hint":"Linajes y parentescos"}],open_section)
  if SaveData.debug_mode or SaveData.trial_session_active:
   button("Caballos aleatorios de prueba",Vector2(430,600),add_random_pair,420)
  return
 match page:
  "collection":collection_view()
  "breed":breed_view()
  "family":family_view()
  "atlas","atlas_variants","market":atlas_view()
  "detail":detail_view()
 label(message,Vector2(30,660),20)
func open_section(value:String)->void:
 if value=="training":add_child(TrainingPanel.new());return
 if value=="genealogy":add_child(GenealogyPanel.new());return
 show_page(value)
func go_back()->void:
 if page=="hub":hide()
 elif page=="detail":show_page(detail_origin)
 elif page=="atlas_variants":atlas_page=atlas_family_page;show_page("atlas")
 else:show_page("hub")
func open_menu()->void:
 page="hub";show();refresh()
func add_random_pair()->void:
 var before:Dictionary=SaveData.horse_collection.export_state()
 var added:Array[Dictionary]=SaveData.horse_collection.add_random_trial_pair()
 if not SaveData.save_progress():SaveData.horse_collection.restore(before);message=tr("UI_086");refresh();return
 parent_b=added[0].id;page="collection";scroll_to_newest=true;refresh()
func sprite(h:Dictionary,pos:Vector2,size_px:float=130)->void:
 var tex:=TextureRect.new();tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 if h.get("stage","adult")=="foal":tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits)
 else:HorsePortrait.apply(tex,h.traits,SaveData.hat_color)
 tex.position=pos;tex.size=Vector2.ONE*size_px;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;content.add_child(tex)
func collection_view()->void:
 label(TranslationServer.translate_plural("UI_081","UI_081_PLURAL",SaveData.horse_collection.horses.size())%SaveData.horse_collection.horses.size(),Vector2(30,100),18)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(30,140);scroll.size=Vector2(1210,500);content.add_child(scroll)
 var rows:=VBoxContainer.new();rows.custom_minimum_size.x=1170;scroll.add_child(rows)
 for h in SaveData.horse_collection.horses:
  var row:=HBoxContainer.new();row.custom_minimum_size.y=170;rows.add_child(row)
  var tex:=TextureRect.new();tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits) if not SaveData.horse_collection.is_adult(h.id) else HorsePortrait.ART;tex.material=HorsePortrait.material_for(h.traits,SaveData.hat_color) if SaveData.horse_collection.is_adult(h.id) else null;tex.custom_minimum_size=Vector2(160,160);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(tex)
  var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=tr("UI_082")%[h.name,tr("UI_083") if h.get("stage","adult")=="foal" else "",tr(HorseCollection.COATS[h.traits.coat]),tr(HorseCollection.PATTERNS[h.traits.pattern]),tr(HorseCollection.MANES[h.traits.mane])];l.custom_minimum_size.x=510;row.add_child(l)
  var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);row.add_child(badge)
  var dodge_badge:=JumpBadge.new();dodge_badge.skill="dodge";dodge_badge.capable=HorseTraining.knows(h,"dodge");row.add_child(dodge_badge)
  if HorseEmblem.valid(h.traits.get("emblem")):
   var emblem:=TextureRect.new();emblem.texture=HorseEmblem.mask(h.traits.emblem);emblem.modulate=Color(HorseEmblem.COLORS[h.traits.emblem.color]);emblem.custom_minimum_size=Vector2(45,45);emblem.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;emblem.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(emblem)
  var eq:=Button.new();eq.size_flags_vertical=Control.SIZE_SHRINK_CENTER;eq.custom_minimum_size=Vector2(124,56);eq.text=tr("UI_060") if SaveData.horse_collection.selected==h.id else tr("UI_059");eq.disabled=SaveData.horse_collection.selected==h.id or not SaveData.horse_collection.is_adult(h.id);row.add_child(eq);eq.pressed.connect(func():
   message=(tr("UI_084") if SaveData.trial_session_active else tr("UI_085")) if SaveData.select_horse(h.id) else tr("UI_086");refresh())
  var fam:=Button.new();fam.size_flags_vertical=Control.SIZE_SHRINK_CENTER;fam.custom_minimum_size=Vector2(100,56);fam.text=tr("FICHA");row.add_child(fam);fam.pressed.connect(func():focus_id=h.id;show_page("detail"))
 if scroll_to_newest:
  scroll_to_newest=false
  scroll.set_deferred("scroll_vertical",2147483647)
func thumbnail(h:Dictionary)->Texture2D:
 var foal:bool=h.get("stage","adult")=="foal"
 var source:Texture2D=load("res://art/foal/base.png" if foal else "res://art/player/walk_diag_down/frame_00.png")
 return HorseAppearance.texture(source,"foal" if foal else "walk_diag_down",0,h.traits)
func parent_picker(id:String,pos:Vector2,is_a:bool)->void:
 var pick:=OptionButton.new();pick.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;pick.position=pos;pick.size=Vector2(370,64);pick.add_theme_constant_override("icon_max_width",56);pick.get_popup().add_theme_constant_override("icon_max_width",56);content.add_child(pick)
 for h in SaveData.horse_collection.horses:
  pick.add_icon_item(thumbnail(h),h.name);pick.set_item_metadata(pick.item_count-1,h.id)
  pick.set_item_disabled(pick.item_count-1,not SaveData.horse_collection.is_adult(h.id))
  if h.id==id:pick.select(pick.item_count-1)
 pick.item_selected.connect(func(i:int):
  if is_a:parent_a=str(pick.get_item_metadata(i))
  else:parent_b=str(pick.get_item_metadata(i))
  refresh())
func breed_view()->void:
 if SaveData.horse_collection.find(parent_a).is_empty():parent_a=SaveData.horse_collection.selected
 if SaveData.horse_collection.find(parent_b).is_empty():parent_b=SaveData.horse_collection.selected
 label(tr("BIRTH_CREDITS")%SaveData.horse_collection.birth_credits if not SaveData.debug_mode and not SaveData.trial_session_active else tr("BIRTH_FREE"),Vector2(30,95),18)
 label(tr("UI_087"),Vector2(30,130),21);label(tr("UI_088"),Vector2(900,130),21)
 parent_picker(parent_a,Vector2(30,165),true);parent_picker(parent_b,Vector2(880,165),false)
 sprite(SaveData.horse_collection.find(parent_a),Vector2(20,250),330)
 sprite(SaveData.horse_collection.find(parent_b),Vector2(920,250),330)
 var labels={"coat":tr("UI_129"),"pattern":tr("UI_130"),"mane":tr("UI_090"),"eyes":tr("UI_131"),"legs":"Patas bajas","spots":"Color manchas"};var n:int=0
 for k in ["coat","pattern","mane","eyes","legs","spots"]:
  label(labels[k],Vector2(370,240+n*49),21)
  button("A" if choices[k]==0 else "B",Vector2(610,230+n*49),func():choices[k]=1-int(choices[k]);refresh(),65);n+=1
 var finish_source:String=parent_b if choices.get("finish",0)==1 else parent_a
 var finish_value:String=SaveData.horse_collection.find(finish_source).traits.get("finish","normal")
 label(tr("UI_091"),Vector2(370,545),20)
 button(("B" if choices.get("finish",0)==1 else "A")+" · "+("Galaxy" if finish_value=="galaxy" else "Normal"),Vector2(540,535),func():choices["finish"]=1-int(choices.get("finish",0));refresh(),170)
 var t:Dictionary=SaveData.horse_collection.preview(parent_a,parent_b,choices)
 if not t.is_empty():
  label("Vista de la cría",Vector2(725,255),19)
  sprite({"traits":t,"stage":"foal"},Vector2(710,295),205)
  button(tr("UI_092"),Vector2(420,605),func():
   var h:Dictionary=SaveData.breed_horses(parent_a,parent_b,choices)
   message=(tr("BIRTH_NEED_WIN") if not SaveData.debug_mode and not SaveData.trial_session_active and SaveData.horse_collection.birth_credits<=0 else tr("UI_093")) if h.is_empty() else tr("UI_094")%h.name
   if not h.is_empty():focus_id=h.id
   refresh(),440)
 else:label(tr("UI_095"),Vector2(380,580),22)
func family_view()->void:
 var graph:=GenealogyPanel.new();add_child(graph);graph.select(focus_id);page="collection"

func detail_view()->void:
 var h:Dictionary=SaveData.horse_collection.find(focus_id)
 var is_owned:bool=not h.is_empty()
 if not is_owned:h=focus_preview
 if h.is_empty():return
 if not is_owned and detail_origin=="atlas_variants":
  label("Variante sin conseguir",Vector2(40,130),28);sprite(h,Vector2(80,210),350)
  var t:Dictionary=h.traits
  label(tr(HorseCollection.COATS[t.coat])+" · "+tr(HorseCollection.PATTERNS[t.pattern])+" · "+tr(HorseCollection.MANES[t.mane]),Vector2(510,170),24)
  label("Manchas: "+(tr(HorseCollection.COATS[HorseCollection.spots_index(t)]) if HorseCollection.spots_index(t)>=0 else "original"),Vector2(510,240),22)
  label("Ojos: "+tr(HorseCollection.EYES[HorseCollection.eye_index(t)]),Vector2(510,290),22)
  label("Patas: "+(tr(HorseCollection.COATS[HorseCollection.legs_index(t)]) if HorseCollection.legs_index(t)>=0 else "original"),Vector2(510,340),22)
  label("Vista de posibilidad · no cambia tu colección",Vector2(510,420),21)
  return
 if not is_owned:
  label(tr(HorseCollection.COATS[h.traits.coat])+tr("UI_101"),Vector2(40,185),28);sprite(h,Vector2(60,245),300)
  label(tr("UI_102")+tr(HorseCollection.COATS[h.traits.coat])+tr("UI_103")+tr(HorseCollection.PATTERNS[h.traits.pattern])+tr("UI_104")+tr(HorseCollection.MANES[h.traits.mane]),Vector2(510,150),26)
  label(tr("MARKET_VALUE")%[tr(HorseCollection.RARITIES[HorseMarket.tier(h)]),HorseMarket.buy_price(h)],Vector2(510,280),22)
  var purchase:=button(tr("MARKET_BUY")%(0 if SaveData.debug_mode or SaveData.trial_session_active else HorseMarket.buy_price(h)),Vector2(510,340),func():confirm_trade(h,false),400);purchase.disabled=not SaveData.debug_mode and not SaveData.trial_session_active and (SaveData.equipment_points<HorseMarket.buy_price(h) or not HorseMarket.available(SaveData.horse_collection,h,SaveData.highest_level_completed))
  button(tr("UI_106"),Vector2(510,410),func():show_page("atlas"),340)
  return
 var title:=label(h.name,Vector2(30,100),27);title.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;title.size.x=365;title.clip_text=true
 if PackLeader.is_leader(h,SaveData.horse_collection):
  var badge:=label(tr("LEADER_TITLE"),Vector2(30,135),18);badge.add_theme_color_override("font_color",Color("ffd23d"))
 sprite(h,Vector2(20,150),420)
 var name_edit:=LineEdit.new();name_edit.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;name_edit.text=h.name;name_edit.placeholder_text=tr("UI_107");name_edit.max_length=60;name_edit.position=Vector2(30,580);name_edit.size=Vector2(200,48);content.add_child(name_edit)
 button(tr("UI_108"),Vector2(245,580),func():
  message=tr("UI_109") if SaveData.rename_horse(h.id,name_edit.text) else tr("UI_110");refresh(),160)
 if SaveData.horse_collection.is_adult(h.id):
  var equip:=button(tr("UI_060") if SaveData.horse_collection.selected==h.id else tr("UI_111"),Vector2(30,635),func():
   message=tr("UI_112") if SaveData.select_horse(h.id) else tr("UI_086");refresh(),360)
  equip.disabled=SaveData.horse_collection.selected==h.id
 label(tr(HorseCollection.COATS[h.traits.coat])+" · "+tr(HorseCollection.PATTERNS[h.traits.pattern])+" · "+tr(HorseCollection.MANES[h.traits.mane]),Vector2(480,100),22)
 var pattern_picker:=OptionButton.new();pattern_picker.position=Vector2(480,180);pattern_picker.size=Vector2(250,44)
 for pattern_name in HorseCollection.PATTERNS:pattern_picker.add_item(tr(pattern_name))
 pattern_picker.select(int(h.traits.pattern));content.add_child(pattern_picker)
 pattern_picker.item_selected.connect(func(i:int):SaveData.set_horse_pattern_color(h.id,"pattern",i);refresh())
 var spot_picker:=OptionButton.new();spot_picker.position=Vector2(745,180);spot_picker.size=Vector2(235,44);spot_picker.add_item("Manchas: original")
 var coat_picker:=OptionButton.new();coat_picker.position=Vector2(1000,180);coat_picker.size=Vector2(240,44)
 for color_name in HorseCollection.COATS:
  spot_picker.add_item("Manchas: "+tr(color_name));coat_picker.add_item("Pelaje: "+tr(color_name))
 spot_picker.select(HorseCollection.spots_index(h.traits)+1);coat_picker.select(int(h.traits.coat));content.add_child(spot_picker);content.add_child(coat_picker)
 spot_picker.item_selected.connect(func(i:int):SaveData.set_horse_pattern_color(h.id,"spots",i-1);refresh())
 coat_picker.item_selected.connect(func(i:int):SaveData.set_horse_pattern_color(h.id,"coat",i);refresh())
 var leg_picker:=OptionButton.new();leg_picker.position=Vector2(960,250);leg_picker.size=Vector2(280,48);leg_picker.add_item("Patas: original")
 for color_name in HorseCollection.COATS:leg_picker.add_item("Patas: "+tr(color_name))
 leg_picker.select(HorseCollection.legs_index(h.traits)+1);content.add_child(leg_picker)
 leg_picker.item_selected.connect(func(i:int):message="Color de patas guardado" if SaveData.set_horse_legs(h.id,i-1) else "No se pudo guardar";refresh())
 button("Mustang",Vector2(1010,315),func():message="Pardo con patas oscuras" if SaveData.set_horse_legs(h.id,0,true) else "No se pudo guardar";refresh(),200)
 button(tr("EMBLEM_TITLE"),Vector2(480,405),func():
  var editor:=EmblemPanel.new();editor.horse_id=h.id;editor.saved.connect(refresh);add_child(editor),360).disabled=not SaveData.horse_collection.is_adult(h.id)
 var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);badge.position=Vector2(1175,95);badge.size=Vector2(64,56);content.add_child(badge)
 var dodge_badge:=JumpBadge.new();dodge_badge.skill="dodge";dodge_badge.capable=HorseTraining.knows(h,"dodge");dodge_badge.position=Vector2(1095,95);dodge_badge.size=Vector2(64,56);content.add_child(dodge_badge)
 var st:Dictionary=HorseStats.read(h)
 label(tr("UI_114")%[tr(HorseCollection.EYES[HorseCollection.eye_index(h.traits)]),st.speed,st.handling,st.power*100,st.dodge*100],Vector2(480,235),16)
 if not SaveData.horse_collection.is_adult(h.id):
  label(tr("UI_115"),Vector2(850,412),16)
  button(tr("UI_116"),Vector2(30,635),func():
   message=tr("UI_117") if SaveData.mature_horse_trial(h.id) else tr("UI_086");refresh(),360)
 label(tr("UI_118") if not SaveData.horse_collection.is_adult(h.id) else tr("UI_119")%SaveData.equipped_whip_reach(),Vector2(480,462),16)
 button(tr("UI_120"),Vector2(480,490),func():show_page("family"),420)
 var sell:=button(tr("MARKET_SELL")%HorseMarket.sell_price(h),Vector2(920,540),func():confirm_trade(h,true),360);sell.disabled=not HorseMarket.can_sell(SaveData.horse_collection,h.id)
 sell.tooltip_text=tr("MARKET_PROTECT")
func atlas_entries()->Array[Dictionary]:
 if page=="atlas_variants":return HorseAtlas.variants(atlas_family,atlas_filters,SaveData.horse_collection.horses)
 if page=="market" and not SaveData.debug_mode and not SaveData.trial_session_active:
  var limited:Array[Dictionary]=[]
  for h in HorseMarket.offers(SaveData.highest_level_completed):
   if not SaveData.horse_collection.bought_offers.has(h.offer_id):limited.append({"horse":h,"owned":false})
  return limited
 var result:Array[Dictionary]=[];var owned:Dictionary={}
 for h in SaveData.horse_collection.horses:
  result.append({"horse":h,"owned":true})
  owned["%d_%d_%d"%[h.traits.coat,h.traits.pattern,h.traits.mane]]=true
 if not atlas_owned_first or page=="market":
  result.clear()
 for n in range(HorseCollection.COATS.size()*HorseCollection.PATTERNS.size()*HorseCollection.MANES.size()):
  var t:Dictionary={"coat":int(n/(HorseCollection.PATTERNS.size()*6)),"pattern":int(n/6)%HorseCollection.PATTERNS.size(),"mane":n%6}
  if page!="market":t=HorseAtlas.traits(t,atlas_filters)
  if page=="market" or not atlas_owned_first or not owned.has("%d_%d_%d"%[t.coat,t.pattern,t.mane]):result.append({"horse":{"traits":t,"name":HorseCollection.COATS[t.coat],"stage":"adult"},"owned":false})
 if page!="market" and ["spots","eyes","legs"].any(func(k):return atlas_filters.has(k)):
  result.clear()
  for n in range(20*HorseCollection.PATTERNS.size()*6):
   var t:Dictionary=HorseAtlas.traits({"coat":int(n/(HorseCollection.PATTERNS.size()*6)),"pattern":int(n/6)%HorseCollection.PATTERNS.size(),"mane":n%6},atlas_filters)
   if not HorseAtlas.contrast_ok(t):continue
   var found:Dictionary=HorseAtlas.owned(t,SaveData.horse_collection.horses)
   result.append({"horse":found if not found.is_empty() else {"traits":t,"name":HorseCollection.COATS[t.coat],"stage":"adult"},"owned":not found.is_empty()})
  if atlas_owned_first:result.sort_custom(func(a,b):return a.owned and not b.owned)
  return result
 if not atlas_owned_first and page!="market":
  for entry in result:
   var t:Dictionary=entry.horse.traits
   for h in SaveData.horse_collection.horses:
    if h.traits.coat==t.coat and h.traits.pattern==t.pattern and h.traits.mane==t.mane:
     entry.horse=h;entry.owned=true;break
 return result
## Barra de filtros del atlas (Ant 8-nov 19:13): un desplegable por propiedad
## del registro HorseFilters (propiedades como datos); "Todos" quita ese
## filtro y los activos se combinan en AND. Misma barra en atlas y mercado.
func _atlas_filter_bar()->void:
 FilterDrawer.button(content,Vector2(1010,95),atlas_filters.size(),open_atlas_filters)
func open_atlas_filters()->void:
 var drawer:=FilterDrawer.new();add_child(drawer)
 var properties:Array=HorseFilters.properties()
 if page!="market":properties+=HorseAtlas.properties()
 for p in properties:
  var options:Array=[]
  for value in p.values:options.append({"value":value.value,"label":tr(value.label)})
  drawer.add_choice(str(p.id),tr(p.label),options,atlas_filters.get(p.id,null))
 drawer.changed.connect(func(key:String,value:Variant):
  if value==null:atlas_filters.erase(key)
  else:atlas_filters[key]=value
  atlas_page=0;refresh())
 drawer.cleared.connect(func():atlas_filters.clear();atlas_page=0;refresh())
func _on_atlas_filter(idx:int,pid:String,values:Array)->void:
 if idx<=0:atlas_filters.erase(pid)
 else:atlas_filters[pid]=values[idx-1].value
 atlas_page=0;refresh()

func atlas_view()->void:
 label(tr("MARKET_BALANCE")%SaveData.equipment_points if page=="market" else tr("UI_121"),Vector2(35,105),25)
 if page=="atlas":
  var order_btn:=button(tr("UI_122") if atlas_owned_first else tr("UI_123"),Vector2(1015,575),func():atlas_owned_first=not atlas_owned_first;atlas_page=0;refresh(),230)
  order_btn.add_theme_font_size_override("font_size",14)
 _atlas_filter_bar()
 label(tr("MARKET_DESIGN_NOTE") if page=="market" else ("Colores de manchas · cambia ojos y patas desde Filtros" if page=="atlas_variants" else "1.440 familias · toca una para explorar manchas, ojos y patas"),Vector2(35,160),17)
 if page=="market" and entries_empty():label(tr("MARKET_EMPTY"),Vector2(40,300),22)
 var all_entries:Array[Dictionary]=atlas_entries()
 var entries:Array[Dictionary]=HorseFilters.apply(all_entries,atlas_filters);var pages:int=maxi(1,ceili(entries.size()/6.0));atlas_page=clampi(atlas_page,0,pages-1)
 for j in range(6):
  var n:int=atlas_page*6+j
  if n>=entries.size():break
  var entry:Dictionary=entries[n];var h:Dictionary=entry.horse;var t:Dictionary=h.traits
  var x:float=30+(j%3)*415;var y:float=205+int(j/3)*185
  sprite(h,Vector2(x,y),175)
  var title:=label((h.name if page=="market" else ("✓ "+h.name if entry.owned else "? "+tr(HorseCollection.COATS[t.coat]))),Vector2(x+180,y),18);title.size=Vector2(225,30);title.clip_text=true
  label(tr(HorseCollection.PATTERNS[t.pattern])+" · "+tr(HorseCollection.MANES[t.mane]),Vector2(x+180,y+32),16)
  var open:=Button.new();open.flat=true;open.position=Vector2(x,y);open.size=Vector2(395,175);open.tooltip_text=tr("UI_126");content.add_child(open);open.pressed.connect(func():
   if page=="atlas":
    atlas_family_page=atlas_page;atlas_family=h.traits.duplicate(true);atlas_page=0;show_page("atlas_variants")
   else:focus_id=str(h.get("id",""));focus_preview=h;show_page("detail"))
  label(tr(HorseCollection.RARITIES[HorseMarket.tier(h)]),Vector2(x+180,y+58),16)
  if page=="market":label(tr("MARKET_PRICE")%HorseMarket.buy_price(h),Vector2(x+180,y+82),16)
  else:
   var spot:int=HorseCollection.spots_index(t)
   label("Manchas: "+(tr(HorseCollection.COATS[spot]) if spot>=0 else "original"),Vector2(x+180,y+82),16)
   label("Ojos: "+tr(HorseCollection.EYES[HorseCollection.eye_index(t)]),Vector2(x+180,y+105),15)
   label("Patas: "+(tr(HorseCollection.COATS[HorseCollection.legs_index(t)]) if HorseCollection.legs_index(t)>=0 else "original"),Vector2(x+180,y+127),15)
  if HorseJump.capable(h):
   var jump:=JumpBadge.new();jump.capable=true;jump.position=Vector2(x+110,y+116);jump.size=Vector2(64,56);content.add_child(jump)
 button(tr("UI_132"),Vector2(35,575),func():atlas_page=maxi(0,atlas_page-1);refresh())
 if not atlas_filters.is_empty():label(tr("FILTER_COUNT")%[entries.size(),all_entries.size()],Vector2(892,588),17)
 label(tr("UI_128")%[atlas_page+1,pages],Vector2(345,585),23)
 button(tr("UI_133"),Vector2(650,575),func():atlas_page=mini(pages-1,atlas_page+1);refresh())

func confirm_trade(h:Dictionary,selling:bool)->void:
 var dialog:=ConfirmationDialog.new();dialog.title=tr("MARKET_TITLE")
 var amount:int=HorseMarket.sell_price(h) if selling else (0 if SaveData.debug_mode or SaveData.trial_session_active else HorseMarket.buy_price(h))
 dialog.dialog_text=(tr("MARKET_CONFIRM_SELL") if selling else tr("MARKET_CONFIRM_BUY"))%[h.name,amount,SaveData.equipment_points]
 dialog.get_cancel_button().text=tr("MARKET_CANCEL");dialog.min_size=Vector2i(600,180);dialog.dialog_autowrap=true;add_child(dialog);RanchTheme.style_dialog(dialog,true)
 dialog.confirmed.connect(func():
  var ok:bool=SaveData.sell_market_horse(str(h.id)) if selling else SaveData.buy_market_horse(h)
  message=tr("MARKET_OK") if ok else tr("MARKET_FAILED");page="collection";refresh();dialog.queue_free())
 dialog.canceled.connect(dialog.queue_free);dialog.popup_centered()

func entries_empty()->bool:return atlas_entries().is_empty()
