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
var detail_entries:Array=[]
var atlas_family:Dictionary={}
var atlas_family_page:int=0
var atlas_page:int=0
var atlas_owned_first:bool=true
var atlas_filters:Dictionary={}
var scroll_to_newest:bool=false
var expanded_appearance_groups118:Dictionary={}
var collection_scroll118:int=0
var collection_mode182:String="list"
var pasture_tier141:int=-1
var pasture_page141:int=0
func _ready()->void:
 MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=80
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 resized.connect(layout);layout();refresh()
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func label(text:String,pos:Vector2,font:int=22)->Label:
 var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);content.add_child(l);TextFit181.fixed(l,Vector2(maxf(80.,1240-pos.x),42),font,18);return l
func button(text:String,pos:Vector2,cb:Callable,w:float=230)->Button:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(w,48);b.pressed.connect(cb);content.add_child(b);TextFit181.button(b,Vector2(w,48));return b
func show_page(value:String)->void:
 if value=="detail" and page!="detail":detail_origin=page
 page=value;message="";refresh()
func refresh()->void:
 _refresh.call_deferred()
func _refresh()->void:
 if not is_inside_tree():return
 if content!=null:canvas.remove_child(content);content.queue_free()
 content=Control.new();content.size=Vector2(1280,720);canvas.add_child(content);MenuNavigation.reveal(content)
 var titles={"hub":"CABALLERIZA","collection":"COLECCIÓN","breed":"CRUZAR","atlas":("ATLAS · RESULTADOS" if not atlas_filters.is_empty() else "ATLAS · FAMILIAS"),"atlas_variants":"ATLAS · VARIANTES","market":"MERCADO","detail":"FICHA"}
 MenuNavigation.header(content,str(titles.get(page,"CABALLERIZA")),go_back)
 if page=="hub":
  MenuNavigation.cards(content,[{"id":"collection","title":"Colección","hint":"Tus caballos"},{"id":"breed","title":"Cruzar","hint":"Elige padres y rasgos"},{"id":"atlas","title":"Atlas","hint":"Explora colores y patrones"},{"id":"market","title":"Mercado","hint":"Compra y venta"},{"id":"training","title":"Entrenamiento","hint":"Aprende habilidades"},{"id":"genealogy","title":"Mapa genealógico","hint":"Linajes y parentescos"}],open_section)
  if SaveData.debug_mode or SaveData.trial_session_active:
   button("Caballos aleatorios de prueba",Vector2(430,600),add_random_pair,420)
  return
 match page:
  "pasture141":pasture_view141()
  "collection":
   collection_selector182()
   if collection_mode182=="ranch":pasture_view141(true)
   else:collection_view()
  "breed":breed_view()
  "family":family_view()
  "atlas","atlas_variants","market":atlas_view()
  "detail":detail_view()
 label(message,Vector2(30,660),20)
func open_section(value:String)->void:
 if value=="training":add_child(TrainingPanel.new());return
 if value=="genealogy":add_child(GenealogyPanel.new());return
 show_page(value)
func pasture_view141(embedded:bool=false)->void:
 var ranch:=RanchPasturePanel141.new();ranch.embedded182=embedded;ranch.tier=pasture_tier141;ranch.page_index=pasture_page141;content.add_child(ranch)
 ranch.closed.connect(func():show_page("hub"))
 ranch.horse_opened.connect(func(id:String):
  pasture_tier141=ranch.tier;pasture_page141=ranch.page_index
  detail_entries=RanchPastures141.horses(SaveData.horse_collection,ranch.tier).map(func(h):return {"horse":h,"owned":true})
  focus_id=id;show_page("detail"))
 ranch.list_requested.connect(func():show_page("collection"))
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
 HorsePortrait.apply_horse(tex,h,SaveData.hat_color)
 tex.position=pos;tex.size=Vector2.ONE*size_px;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;content.add_child(tex)
func set_collection_mode182(mode:String)->void:
 for child in content.get_children():
  if child is RanchPasturePanel141:pasture_tier141=child.tier;pasture_page141=child.page_index
 collection_mode182=mode;refresh()
func collection_selector182()->void:
 var list_button:=button("Vista por propiedades",Vector2(30,92),func():set_collection_mode182("list"),330)
 list_button.name="CollectionList182";list_button.disabled=collection_mode182=="list"
 var ranch_button:=button("Vista de colección",Vector2(375,92),func():set_collection_mode182("ranch"),330)
 ranch_button.name="CollectionRanch182";ranch_button.disabled=collection_mode182=="ranch"
 TextFit181.fixed(label("Una colección · dos vistas",Vector2(30,62),18),Vector2(900,32),18,18)
func collection_view()->void:
 var restore_scroll:int=collection_scroll118
 var groups:Array[Dictionary]=HorseAppearanceGroups118.groups(SaveData.horse_collection.horses)
 TextFit181.fixed(label(CollectionCount184.summary(SaveData.horse_collection.horses.size(),groups.size())+" · despliega para elegir cada caballo",Vector2(30,152),21),Vector2(1190,32),21,18)
 var scroll:=ScrollContainer.new();scroll.name="CollectionScroll118";scroll.position=Vector2(30,195);scroll.size=Vector2(1210,445);content.add_child(scroll)
 scroll.scroll_vertical=collection_scroll118
 scroll.get_v_scroll_bar().value_changed.connect(func(value:float):collection_scroll118=int(value))
 var rows:=VBoxContainer.new();rows.name="AppearanceGroups118";rows.custom_minimum_size.x=1170;scroll.add_child(rows)
 for group in groups:
  var horses:Array=group.horses
  if horses.size()==1:_collection_horse_row118(rows,horses[0]);continue
  var h:Dictionary=horses[0];var row:=HBoxContainer.new();row.name="AppearanceGroup118";row.custom_minimum_size.y=150;rows.add_child(row)
  var tex:=TextureRect.new();HorsePortrait.apply_horse(tex,h,SaveData.hat_color);tex.custom_minimum_size=Vector2(150,150);row.add_child(tex)
  var info:=Label.new();info.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;info.custom_minimum_size.x=540;info.add_theme_font_size_override("font_size",23)
  var equipped:bool=horses.any(func(item):return item.id==SaveData.horse_collection.selected)
  info.text="%s · %s · crin %s\n×%d con esta apariencia%s"%[tr(HorseCollection.COATS[h.traits.coat]),tr(HorseCollection.PATTERNS[h.traits.pattern]),tr(HorseCollection.MANES[h.traits.mane]),horses.size()," · incluye equipado" if equipped else ""];TextFit181.flow(info,540);row.add_child(info)
  var pure_count:int=horses.filter(func(item):return GalaxyPure143.is_pure(item)).size()
  if pure_count>0:info.text+="\n◆ GALAXY PURO ×%d"%pure_count
  var toggle:=Button.new();toggle.name="ToggleAppearance118";toggle.size_flags_vertical=Control.SIZE_SHRINK_CENTER;toggle.custom_minimum_size=Vector2(330,58);row.add_child(toggle)
  var members:=VBoxContainer.new();members.name="AppearanceMembers118";members.custom_minimum_size.x=1170;rows.add_child(members)
  var expanded:bool=expanded_appearance_groups118.has(group.key);members.visible=expanded;toggle.text=("Ocultar" if expanded else "Ver caballos")+" (×%d)"%horses.size()
  if expanded:
   for member in horses:_collection_horse_row118(members,member)
  toggle.pressed.connect(func():
   if members.get_child_count()==0:
    for member in horses:_collection_horse_row118(members,member)
   members.visible=not members.visible
   if members.visible:expanded_appearance_groups118[group.key]=true
   else:expanded_appearance_groups118.erase(group.key)
   toggle.text=("Ocultar" if members.visible else "Ver caballos")+" (×%d)"%horses.size())
 if scroll_to_newest:
  scroll_to_newest=false;scroll.set_deferred("scroll_vertical",2147483647)
 else:scroll.set_deferred("scroll_vertical",restore_scroll)
func _collection_horse_row118(rows:VBoxContainer,h:Dictionary)->void:
 var row:=HBoxContainer.new();row.custom_minimum_size.y=170;rows.add_child(row)
 var tex:=TextureRect.new();HorsePortrait.apply_horse(tex,h,SaveData.hat_color);tex.custom_minimum_size=Vector2(160,160);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(tex)
 var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=tr("UI_082")%[h.name,tr("UI_083") if h.get("stage","adult")=="foal" else "",tr(HorseCollection.COATS[h.traits.coat]),tr(HorseCollection.PATTERNS[h.traits.pattern]),tr(HorseCollection.MANES[h.traits.mane])];l.custom_minimum_size.x=510;
 if GalaxyPure143.is_pure(h):l.text+="\n"+GalaxyPure143.BADGE
 var info:=VBoxContainer.new();info.custom_minimum_size.x=510;info.size_flags_vertical=Control.SIZE_SHRINK_CENTER;row.add_child(info);TextFit181.flow(l,510);info.add_child(l);HorseSummaryBar185.create(info,h,490)
 var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);row.add_child(badge)
 var dodge_badge:=JumpBadge.new();dodge_badge.skill="dodge";dodge_badge.capable=HorseTraining.knows(h,"dodge");row.add_child(dodge_badge)
 if HorseEmblem.valid(h.traits.get("emblem")):
  var emblem:=TextureRect.new();emblem.texture=HorseEmblem.mask(h.traits.emblem);emblem.modulate=Color(HorseEmblem.COLORS[h.traits.emblem.color]);emblem.custom_minimum_size=Vector2(45,45);emblem.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;emblem.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(emblem)
 var eq:=Button.new();eq.name="Equip118_"+str(h.id);eq.size_flags_vertical=Control.SIZE_SHRINK_CENTER;eq.custom_minimum_size=Vector2(124,56);eq.text=tr("UI_060") if SaveData.horse_collection.selected==h.id else tr("UI_059");eq.disabled=SaveData.horse_collection.selected==h.id or not SaveData.horse_collection.is_adult(h.id);row.add_child(eq);eq.pressed.connect(func():
  message=(tr("UI_084") if SaveData.trial_session_active else tr("UI_085")) if SaveData.select_horse(h.id) else tr("UI_086");refresh())
 var fam:=Button.new();fam.name="Ficha118_"+str(h.id);fam.size_flags_vertical=Control.SIZE_SHRINK_CENTER;fam.custom_minimum_size=Vector2(100,56);fam.text=tr("FICHA");row.add_child(fam);fam.pressed.connect(func():detail_entries=SaveData.horse_collection.horses.map(func(item):return {"horse":item,"owned":true});focus_id=h.id;show_page("detail"))
func thumbnail(h:Dictionary)->Texture2D:return HorsePicker.thumbnail(h)
func parent_picker(id:String,pos:Vector2,is_a:bool)->void:
 var horses:Array=SaveData.horse_collection.horses.filter(func(h):return SaveData.horse_collection.is_adult(h.id))
 HorsePicker.create(content,horses,id,pos,370,func(selected:String):
  if is_a:parent_a=selected
  else:parent_b=selected
  refresh())
func breed_view()->void:
 if SaveData.horse_collection.find(parent_a).is_empty():parent_a=SaveData.horse_collection.selected
 if SaveData.horse_collection.find(parent_b).is_empty():parent_b=SaveData.horse_collection.selected
 label(tr("BIRTH_CREDITS")%SaveData.horse_collection.birth_credits if not SaveData.debug_mode and not SaveData.trial_session_active else tr("BIRTH_FREE"),Vector2(30,95),18)
 label(tr("UI_087"),Vector2(30,130),21);label(tr("UI_088"),Vector2(900,130),21)
 parent_picker(parent_a,Vector2(30,165),true);parent_picker(parent_b,Vector2(880,165),false)
 sprite(SaveData.horse_collection.find(parent_a),Vector2(60,225),280)
 sprite(SaveData.horse_collection.find(parent_b),Vector2(940,225),280)
 var labels={"coat":tr("UI_129"),"pattern":tr("UI_130"),"mane":tr("UI_090"),"eyes":tr("UI_131"),"legs":"Patas bajas","spots":"Color manchas"};var n:int=0
 for k in ["coat","pattern","mane","eyes","legs","spots"]:
  var slot:=Vector2(45+(n%3)*410,515+int(n/3)*50)
  label(labels[k],slot+Vector2(0,10),21)
  button("A" if choices[k]==0 else "B",slot+Vector2(270,0),func():choices[k]=1-int(choices[k]);refresh(),65);n+=1
 var finish_source:String=parent_b if choices.get("finish",0)==1 else parent_a
 var finish_value:String=SaveData.horse_collection.find(finish_source).traits.get("finish","normal")
 label(tr("UI_091"),Vector2(45,620),20)
 button(("B" if choices.get("finish",0)==1 else "A")+" · "+("Galaxy" if finish_value=="galaxy" else "Normal"),Vector2(175,610),func():choices["finish"]=1-int(choices.get("finish",0));refresh(),170)
 var t:Dictionary=SaveData.horse_collection.preview(parent_a,parent_b,choices)
 if not t.is_empty():
  var preview_title:=label("Vista de la cría",Vector2(525,225),19)
  if not GalaxyPure143.birth(SaveData.horse_collection.find(parent_a),SaveData.horse_collection.find(parent_b)).is_empty():preview_title.text=GalaxyPure143.BADGE
  preview_title.size.x=230;preview_title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
  sprite({"traits":t,"stage":"foal"},Vector2(525,265),230)
  button(tr("UI_092"),Vector2(420,615),func():
   var h:Dictionary=SaveData.breed_horses(parent_a,parent_b,choices)
   message=(tr("BIRTH_NEED_WIN") if not SaveData.debug_mode and not SaveData.trial_session_active and SaveData.horse_collection.birth_credits<=0 else tr("UI_093")) if h.is_empty() else tr("UI_094")%h.name
   if not h.is_empty():focus_id=h.id
   refresh(),440)
 else:label(tr("UI_095"),Vector2(490,350),22)
func family_view()->void:
 # Rebuild the real list behind the overlay before it can close.
 page=detail_origin if detail_origin in ["collection","atlas","atlas_variants","market"] else "collection"
 refresh()
 var graph:=GenealogyPanel.new();graph.name="HorseGenealogyOverlay118";add_child(graph);graph.select(focus_id)

func detail_view()->void:
 var h:Dictionary=SaveData.horse_collection.find(focus_id)
 var owned:bool=not h.is_empty()
 if not owned:h=focus_preview
 if h.is_empty():return
 var entries:Array=detail_entries
 if entries.is_empty():entries=SaveData.horse_collection.horses.map(func(item):return {"horse":item,"owned":true})
 var selected:int=0
 for i in entries.size():
  var candidate:Dictionary=entries[i].horse
  if (owned and candidate.get("id","")==focus_id) or (not owned and candidate.traits==h.traits):selected=i;break
 ItemPager.create(content,Vector2(480,20),340,selected,entries.size(),func(i:int):
  var item:Dictionary=entries[i].horse;focus_id=str(item.get("id",""));focus_preview=item;refresh())
 var t:Dictionary=h.traits
 var title:String=str(h.get("name","")) if owned else HorseCollection.COATS[t.coat]+" · "+HorseCollection.PATTERNS[t.pattern]+" · "+HorseCollection.MANES[t.mane]
 TextFit181.fixed(label(title,Vector2(35,110),26),Vector2(390,60),26,20,2)
 label("Tu caballo · desliza los valores" if owned else "Variante sin conseguir",Vector2(35,175),19)
 sprite(h,Vector2(30,205),390)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(470,130);scroll.size=Vector2(770,540);content.add_child(scroll)
 var box:=VBoxContainer.new();box.custom_minimum_size=Vector2(735,0);box.add_theme_constant_override("separation",12);scroll.add_child(box)
 if owned:
  if GalaxyPure143.is_pure(h):
   var pure:=Label.new();pure.name="GalaxyPureBadge143";pure.text=GalaxyPure143.BADGE+"\nDos padres Galaxy al nacer · todavía no es un unicornio";pure.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;pure.add_theme_font_size_override("font_size",22);pure.modulate=RanchTheme.GOLD;TextFit181.flow(pure,735);box.add_child(pure)
  var completed:=Label.new();completed.text=HorseMastery.level_text(h);completed.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;completed.add_theme_font_size_override("font_size",20);TextFit181.flow(completed,735);box.add_child(completed)
  HorseSummaryBar185.create(box,h,700)
  HorseStatBars.row(box,"Maestría · %d%%"%roundi(HorseMastery.percent(h)),HorseMastery.percent(h))
  if h.traits.get("finish","")=="galaxy":
   var galaxy:=Label.new();galaxy.text="Galaxy maestro" if HorseMastery.galaxy_master(h) else "Galaxy maestro: supera 36-40 con este caballo (%d%%)"%roundi(HorseMastery.GALAXY_MASTER_THRESHOLD);galaxy.add_theme_font_size_override("font_size",20);TextFit181.flow(galaxy,735);box.add_child(galaxy)
 for text in HorseValues.visual(t)+(HorseValues.hidden_genes(t) if owned else [])+(["Rareza: "+HorseCollection.RARITIES[HorseMarket.tier(h)]] if owned else []):
  var line:=Label.new();line.text=text;line.add_theme_font_size_override("font_size",22);TextFit181.flow(line,735);box.add_child(line)
 HorseStatBars.create(box,h,owned)
 if not owned:
  var note:=Label.new();note.text="Vista de posibilidad · no cambia tu colección"
  if h.get("galaxy_key173",0)>0:note.text="Galaxy: requiere la llave del nivel %d y los puntos. Una adquisición por llave."%int(h.galaxy_key173)
  TextFit181.flow(note,735);box.add_child(note)
  if detail_origin not in ["atlas","atlas_variants"]:
   var buy:=Button.new();buy.text=tr("MARKET_BUY")%(0 if SaveData.debug_mode or SaveData.trial_session_active else HorseMarket.buy_price(h));box.add_child(buy);buy.pressed.connect(func():confirm_trade(h,false));buy.disabled=not SaveData.debug_mode and not SaveData.trial_session_active and (SaveData.equipment_points<HorseMarket.buy_price(h) or not HorseMarket.available(SaveData.horse_collection,h,SaveData.highest_level_completed))
  return
 var can_edit:bool=SaveData.horse_editing_allowed()
 if can_edit:
  var name_edit:=LineEdit.new();name_edit.text=h.name;name_edit.max_length=60;name_edit.position=Vector2(35,600);name_edit.size=Vector2(210,48);content.add_child(name_edit)
  button(tr("UI_108"),Vector2(255,600),func():SaveData.rename_horse(h.id,name_edit.text);refresh(),170)
  var fields:Array=[["coat","Pelaje",HorseCollection.COATS,int(t.coat)],["pattern","Tipo de manchas",HorseCollection.PATTERNS,int(t.pattern)],["spots","Color de manchas",["Original"]+HorseCollection.COATS,HorseCollection.spots_index(t)+1],["legs","Patas bajas",["Original"]+HorseCollection.COATS,HorseCollection.legs_index(t)+1]]
  for spec in fields:
   var pick:=OptionButton.new();pick.custom_minimum_size.y=48
   for value in spec[2]:pick.add_item(str(spec[1])+": "+str(value))
   pick.select(spec[3]);box.add_child(pick)
   pick.item_selected.connect(func(i:int):
    if spec[0]=="legs":SaveData.set_horse_legs(h.id,i-1)
    else:SaveData.set_horse_pattern_color(h.id,spec[0],i-1 if spec[0]=="spots" else i)
    refresh())
 if h.get("stage","adult")=="foal":
  var growth:=Label.new();growth.name="FoalGrowth174";growth.text=FoalGrowth174.text(h);growth.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;TextFit181.flow(growth,735);box.add_child(growth)
  var mature:=Button.new();mature.text="Hacerse adulto";mature.custom_minimum_size.y=48;mature.disabled=not FoalGrowth174.ready(h);box.add_child(mature);mature.pressed.connect(func():SaveData.mature_horse174(h.id);refresh())
 var actions:Array=[["Usar caballo",func():SaveData.select_horse(h.id);refresh()],["Mapa genealógico",func():show_page("family")]]
 if can_edit:
  actions.append(["Emblema",func():var editor:=EmblemPanel.new();editor.horse_id=h.id;editor.saved.connect(refresh);add_child(editor)])
  actions.append(["Mustang: patas oscuras",func():SaveData.set_horse_legs(h.id,0,true);refresh()])
  if not SaveData.horse_collection.is_adult(h.id):actions.append(["Crecer (prueba)",func():SaveData.mature_horse_trial(h.id);refresh()])
 for action in actions:
  var b:=Button.new();b.text=action[0];b.custom_minimum_size.y=48;box.add_child(b);b.pressed.connect(action[1])
  if action[0] in ["Usar caballo","Emblema"]:b.disabled=not SaveData.horse_collection.is_adult(h.id)
 var sell:=Button.new();sell.text=tr("MARKET_SELL")%HorseMarket.sell_price(h);sell.custom_minimum_size.y=48;sell.disabled=not HorseMarket.can_sell(SaveData.horse_collection,h.id);box.add_child(sell);sell.pressed.connect(func():confirm_trade(h,true))
func atlas_entries()->Array[Dictionary]:
 if page=="atlas_variants":
  var variants:Array[Dictionary]=HorseAtlas.variants(atlas_family,atlas_filters,SaveData.horse_collection.horses)
  if not atlas_owned_first:variants.sort_custom(func(a,b):return HorseAtlas.signature(a.horse.traits)<HorseAtlas.signature(b.horse.traits))
  return variants
 if page=="atlas" and not atlas_filters.is_empty():
  var found:Array[Dictionary]=HorseAtlas.filtered_entries(atlas_filters,SaveData.horse_collection.horses,atlas_owned_first)
  if int(atlas_filters.get("rarity",-1))==4:
   for item in UnicornAtlas.entries(SaveData.horse_collection.horses):
    if item.owned:continue # owned records already included by exact filters
    var hidden_horse:Dictionary={"traits":{"coat":3,"pattern":6,"mane":5,"eyes":20,"finish":"galaxy"},"name":"Legendario sin descubrir","stage":"adult"}
    found.append({"horse":hidden_horse,"owned":false,"mystery115":true})
   if atlas_owned_first:found=HorseAtlas.owned_first_order(found)
  return found
 if page=="market" and not SaveData.debug_mode and not SaveData.trial_session_active:
  var limited:Array[Dictionary]=[]
  for h in HorseMarket.offers(SaveData.highest_level_completed):
   if not SaveData.horse_collection.bought_offers.has(h.offer_id):limited.append({"horse":h,"owned":false})
  return limited
 var result:Array[Dictionary]=[];var exact:Dictionary={};var included:Dictionary={}
 for h in SaveData.horse_collection.horses:exact[HorseAtlas.signature(h.traits)]=h
 for n in range(HorseCollection.COATS.size()*HorseCollection.PATTERNS.size()*HorseCollection.MANES.size()):
  var t:Dictionary={"coat":int(n/(HorseCollection.PATTERNS.size()*6)),"pattern":int(n/6)%HorseCollection.PATTERNS.size(),"mane":n%6}
  if page!="market":t=HorseAtlas.traits(t,atlas_filters)
  var key:String=HorseAtlas.signature(t)
  if page!="market" and exact.has(key):result.append({"horse":exact[key],"owned":true});included[exact[key].id]=true
  else:result.append({"horse":{"traits":t,"name":HorseCollection.COATS[t.coat],"stage":"adult"},"owned":false})
 if page!="market":
  for h in SaveData.horse_collection.horses:
   if not included.has(h.id):result.append({"horse":h,"owned":true})
  if atlas_owned_first:result=HorseAtlas.owned_first_order(result)

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
 if page in ["atlas","atlas_variants"]:
  var order_btn:=button("Los míos primero"+(" ✓" if atlas_owned_first else ""),Vector2(690,100),func():atlas_owned_first=not atlas_owned_first;atlas_page=0;refresh(),300)
  order_btn.name="AtlasOrder114";order_btn.add_theme_font_size_override("font_size",19)

 _atlas_filter_bar()
 label("Galaxy: una llave del 20 y otra del 40. Cada llave adquiere uno; el dinero no sustituye la llave." if page=="market" else "6 por página · toca una tarjeta para ver "+("variantes" if atlas_filters.is_empty() and page=="atlas" else "la ficha"),Vector2(35,160),21)
 if page=="market" and entries_empty():label(tr("MARKET_EMPTY"),Vector2(40,300),22)
 var all_entries:Array[Dictionary]=atlas_entries()
 var entries:Array[Dictionary]=HorseFilters.apply(all_entries,atlas_filters);var pages:int=maxi(1,ceili(entries.size()/6.0));atlas_page=clampi(atlas_page,0,pages-1)
 var outer:Control=content
 var cards:=Control.new();cards.name="AtlasVisibleGrid117";cards.position=Vector2(20,200);cards.size=Vector2(1240,365);content.add_child(cards);content=cards
 for j in range(6):
  var n:int=atlas_page*6+j
  if n>=entries.size():break
  var entry:Dictionary=entries[n];var h:Dictionary=entry.horse;var t:Dictionary=h.traits
  var x:float=(j%3)*416;var y:float=int(j/3)*183
  var mystery:bool=not entry.owned and (bool(entry.get("mystery115",false)) or (int(atlas_filters.get("rarity",-1))==4 and HorseMarket.tier(h)==4))
  var tile:=Panel.new();tile.name="AtlasCard117_%d"%j;tile.position=Vector2(x,y);tile.size=Vector2(400,174);tile.add_theme_stylebox_override("panel",MapAppearance.frame());content.add_child(tile)
  if mystery:
   var shadow=TextureRect.new();shadow.texture=UnicornAtlasPanel.BASE;shadow.position=Vector2(x+8,y+12);shadow.size=Vector2(145,145);shadow.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;shadow.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
   var shader=Shader.new();shader.code="shader_type canvas_item;void fragment(){vec4 c=texture(TEXTURE,UV);COLOR=vec4(.16,.24,.28,c.a);}"
   var material=ShaderMaterial.new();material.shader=shader;shadow.material=material;content.add_child(shadow)
  else:sprite(h,Vector2(x+8,y+12),145)
  var title:String="Sin descubrir" if mystery else (str(h.name) if entry.owned or page=="market" else tr(HorseCollection.COATS[t.coat])+" · "+tr(HorseCollection.PATTERNS[t.pattern])+"\nCrin: "+tr(HorseCollection.MANES[t.mane]))
  var name_label:=label(title,Vector2(x+160,y+14),23);TextFit181.fixed(name_label,Vector2(228,60),23,18,2)
  var rarity:int=4 if mystery or h.get("species","")=="unicorn" else HorseMarket.tier(h)
  var rarity_label:=label(tr(HorseCollection.RARITIES[rarity]),Vector2(x+160,y+78),22);TextFit181.fixed(rarity_label,Vector2(228,28),22,18)
  TextFit181.fixed(label("No conseguido" if mystery else ("✓ Conseguido" if entry.owned else "No conseguido"),Vector2(x+160,y+110),21),Vector2(228,26),21,18)
  if page=="market":TextFit181.fixed(label(("Galaxy · llave %d + %d puntos"%[int(h.galaxy_key173),HorseMarket.buy_price(h)]) if h.get("galaxy_key173",0)>0 else tr("MARKET_PRICE")%HorseMarket.buy_price(h),Vector2(x+160,y+140),16 if h.get("galaxy_key173",0)>0 else 20),Vector2(228,26),18,16)
  elif not mystery:TextFit181.fixed(label("Ver variantes ›" if page=="atlas" and atlas_filters.is_empty() else "Ver ficha ›",Vector2(x+160,y+140),20),Vector2(228,26),20,18)
  var open:=Button.new();open.flat=true;open.position=Vector2(x,y);open.size=Vector2(400,174);open.tooltip_text="Sin descubrir" if mystery else tr("UI_126");open.disabled=mystery;content.add_child(open);open.pressed.connect(func():
   if page=="atlas" and atlas_filters.is_empty():
    atlas_family_page=atlas_page;atlas_family=h.traits.duplicate(true);atlas_page=0;show_page("atlas_variants")
   else:detail_entries=entries.filter(func(e):return e.owned or not (bool(e.get("mystery115",false)) or (int(atlas_filters.get("rarity",-1))==4 and HorseMarket.tier(e.horse)==4)));focus_id=str(h.get("id",""));focus_preview=h;show_page("detail"))
 content=outer
 ItemPager.create(content,Vector2(345,575),540,atlas_page,pages,func(i:int):atlas_page=i;refresh())
 if not atlas_filters.is_empty():label(tr("FILTER_COUNT")%[entries.size(),all_entries.size()],Vector2(892,588),17)

func confirm_trade(h:Dictionary,selling:bool)->void:
 var dialog:=ConfirmationDialog.new();dialog.title=tr("MARKET_TITLE")
 var amount:int=HorseMarket.sell_price(h) if selling else (0 if SaveData.debug_mode or SaveData.trial_session_active else HorseMarket.buy_price(h))
 dialog.dialog_text=(tr("MARKET_CONFIRM_SELL") if selling else tr("MARKET_CONFIRM_BUY"))%[h.name,amount,SaveData.equipment_points]
 if not selling and h.get("galaxy_key173",0)>0:dialog.dialog_text+="\nSe consume la llave del nivel %d. No se recupera al vender el caballo."%int(h.galaxy_key173)
 dialog.get_cancel_button().text=tr("MARKET_CANCEL");dialog.min_size=Vector2i(600,180);dialog.dialog_autowrap=true;add_child(dialog);RanchTheme.style_dialog(dialog,true)
 dialog.confirmed.connect(func():
  var ok:bool=SaveData.sell_market_horse(str(h.id)) if selling else SaveData.buy_market_horse(h)
  message=tr("MARKET_OK") if ok else tr("MARKET_FAILED");page="collection";refresh();dialog.queue_free())
 dialog.canceled.connect(dialog.queue_free);dialog.popup_centered()

func entries_empty()->bool:return atlas_entries().is_empty()
