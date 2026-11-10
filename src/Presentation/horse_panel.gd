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
 HorsePortrait.apply_horse(tex,h,SaveData.hat_color)
 tex.position=pos;tex.size=Vector2.ONE*size_px;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;content.add_child(tex)
func collection_view()->void:
 label(TranslationServer.translate_plural("UI_081","UI_081_PLURAL",SaveData.horse_collection.horses.size())%SaveData.horse_collection.horses.size(),Vector2(30,100),18)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(30,140);scroll.size=Vector2(1210,500);content.add_child(scroll)
 var rows:=VBoxContainer.new();rows.custom_minimum_size.x=1170;scroll.add_child(rows)
 for h in SaveData.horse_collection.horses:
  var row:=HBoxContainer.new();row.custom_minimum_size.y=170;rows.add_child(row)
  var tex:=TextureRect.new();HorsePortrait.apply_horse(tex,h,SaveData.hat_color);tex.custom_minimum_size=Vector2(160,160);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(tex)
  var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=tr("UI_082")%[h.name,tr("UI_083") if h.get("stage","adult")=="foal" else "",tr(HorseCollection.COATS[h.traits.coat]),tr(HorseCollection.PATTERNS[h.traits.pattern]),tr(HorseCollection.MANES[h.traits.mane])];l.custom_minimum_size.x=510;row.add_child(l)
  var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);row.add_child(badge)
  var dodge_badge:=JumpBadge.new();dodge_badge.skill="dodge";dodge_badge.capable=HorseTraining.knows(h,"dodge");row.add_child(dodge_badge)
  if HorseEmblem.valid(h.traits.get("emblem")):
   var emblem:=TextureRect.new();emblem.texture=HorseEmblem.mask(h.traits.emblem);emblem.modulate=Color(HorseEmblem.COLORS[h.traits.emblem.color]);emblem.custom_minimum_size=Vector2(45,45);emblem.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;emblem.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(emblem)
  var eq:=Button.new();eq.size_flags_vertical=Control.SIZE_SHRINK_CENTER;eq.custom_minimum_size=Vector2(124,56);eq.text=tr("UI_060") if SaveData.horse_collection.selected==h.id else tr("UI_059");eq.disabled=SaveData.horse_collection.selected==h.id or not SaveData.horse_collection.is_adult(h.id);row.add_child(eq);eq.pressed.connect(func():
   message=(tr("UI_084") if SaveData.trial_session_active else tr("UI_085")) if SaveData.select_horse(h.id) else tr("UI_086");refresh())
  var fam:=Button.new();fam.size_flags_vertical=Control.SIZE_SHRINK_CENTER;fam.custom_minimum_size=Vector2(100,56);fam.text=tr("FICHA");row.add_child(fam);fam.pressed.connect(func():detail_entries=SaveData.horse_collection.horses.map(func(item):return {"horse":item,"owned":true});focus_id=h.id;show_page("detail"))
 if scroll_to_newest:
  scroll_to_newest=false
  scroll.set_deferred("scroll_vertical",2147483647)
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
  var preview_title:=label("Vista de la cría",Vector2(700,255),19)
  preview_title.size.x=230;preview_title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
  sprite({"traits":t,"stage":"foal"},Vector2(700,290),230)
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
 label(title,Vector2(35,110),26)
 label("Tu caballo · desliza los valores" if owned else "Variante sin conseguir",Vector2(35,155),19)
 sprite(h,Vector2(30,205),390)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(470,130);scroll.size=Vector2(770,540);content.add_child(scroll)
 var box:=VBoxContainer.new();box.custom_minimum_size=Vector2(735,0);box.add_theme_constant_override("separation",12);scroll.add_child(box)
 for text in HorseValues.visual(t)+HorseValues.performance(h,owned)+(["Rareza: "+HorseCollection.RARITIES[HorseMarket.tier(h)]] if owned else []):
  var line:=Label.new();line.text=text;line.add_theme_font_size_override("font_size",22);box.add_child(line)
 if not owned:
  var note:=Label.new();note.text="Vista de posibilidad · no cambia tu colección";box.add_child(note)
  if detail_origin!="atlas_variants":
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
 label(tr("MARKET_DESIGN_NOTE") if page=="market" else ("Desliza para ver todas las tarjetas · ojos y patas desde Filtros" if page=="atlas_variants" else "1.440 familias · toca una para explorar manchas, ojos y patas"),Vector2(35,160),17)
 if page=="market" and entries_empty():label(tr("MARKET_EMPTY"),Vector2(40,300),22)
 var all_entries:Array[Dictionary]=atlas_entries()
 var entries:Array[Dictionary]=HorseFilters.apply(all_entries,atlas_filters);var pages:int=maxi(1,ceili(entries.size()/6.0));atlas_page=clampi(atlas_page,0,pages-1)
 var outer:Control=content
 var scroll:=ScrollContainer.new();scroll.position=Vector2(0,200);scroll.size=Vector2(1280,365);content.add_child(scroll)
 var cards:=Control.new();cards.custom_minimum_size=Vector2(1250,1335);scroll.add_child(cards);content=cards
 for j in range(6):
  var n:int=atlas_page*6+j
  if n>=entries.size():break
  var entry:Dictionary=entries[n];var h:Dictionary=entry.horse;var t:Dictionary=h.traits
  var x:float=30+(j%2)*620;var y:float=0+int(j/2)*445
  sprite(h,Vector2(x,y),175)
  var title:=label((h.name if page=="market" else ("✓ "+h.name if entry.owned else "? "+tr(HorseCollection.COATS[t.coat])+" · "+tr(HorseCollection.PATTERNS[t.pattern])+" · "+tr(HorseCollection.MANES[t.mane]))),Vector2(x+180,y),18);title.size=Vector2(410,35);title.clip_text=true
  var open:=Button.new();open.flat=true;open.position=Vector2(x,y);open.size=Vector2(600,420);open.tooltip_text=tr("UI_126");content.add_child(open);open.pressed.connect(func():
   if page=="atlas":
    atlas_family_page=atlas_page;atlas_family=h.traits.duplicate(true);atlas_page=0;show_page("atlas_variants")
   else:detail_entries=entries;focus_id=str(h.get("id",""));focus_preview=h;show_page("detail"))
  var texts:Array=HorseValues.visual(t)+HorseValues.performance(h,entry.owned)
  texts.append("Rareza: "+HorseCollection.RARITIES[HorseMarket.tier(h)])
  if page=="market":texts.append(tr("MARKET_PRICE")%HorseMarket.buy_price(h))
  for i in texts.size():label(str(texts[i]),Vector2(x+180,y+48+i*27),17)
 content=outer
 ItemPager.create(content,Vector2(345,575),540,atlas_page,pages,func(i:int):atlas_page=i;refresh())
 if not atlas_filters.is_empty():label(tr("FILTER_COUNT")%[entries.size(),all_entries.size()],Vector2(892,588),17)

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
