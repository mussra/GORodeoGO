class_name HorsePanel
extends Control
var canvas:Control
var content:Control
var message:String=""
var page:String="collection"
var parent_a:String="original"
var parent_b:String="original"
var choices:Dictionary={"coat":0,"pattern":0,"mane":0,"eyes":0,"finish":0}
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
 var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);content.add_child(l);return l
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
 label(tr("UI_071") if SaveData.trial_session_active else tr("UI_072"),Vector2(30,20),30)
 button(tr("UI_009"),Vector2(1050,20),hide,200)
 button(tr("UI_073"),Vector2(30,75),func():show_page("collection"))
 button(tr("UI_074"),Vector2(275,75),func():show_page("breed"))
 button(tr("UI_075"),Vector2(520,75),func():show_page("atlas"))
 button(tr("MARKET_TITLE"),Vector2(765,75),func():show_page("market"),230)
 button(tr("TRAIN_TITLE"),Vector2(520,130),func():add_child(TrainingPanel.new()),230)
 button(tr("GEN_TITLE"),Vector2(795,130),func():add_child(GenealogyPanel.new()),360)
 var random_button:=button(tr("UI_076"),Vector2(1010,75),func():
  if not SaveData.debug_mode and not SaveData.trial_session_active and not SaveData.begin_trial_session():
   message=tr("UI_077");refresh();return
  var before:Dictionary=SaveData.horse_collection.export_state();var added:Array[Dictionary]=SaveData.horse_collection.add_random_trial_pair();
  if not SaveData.save_progress():SaveData.horse_collection.restore(before);message=tr("UI_086");refresh();return
  parent_b=added[0].id;page="collection";scroll_to_newest=true;message=tr("UI_078")%SaveData.horse_collection.horses.size();refresh(),230)
 random_button.visible=SaveData.debug_mode or SaveData.trial_session_active
 var rules_normal:=not SaveData.debug_mode and not SaveData.trial_session_active
 label(tr("MARKET_RULES_A") if rules_normal else tr("TRIAL_RULES_A"),Vector2(30,136),17)
 label(tr("MARKET_RULES_B") if rules_normal else tr("TRIAL_RULES_B"),Vector2(30,160),17)
 match page:
  "collection":collection_view()
  "breed":breed_view()
  "family":family_view()
  "atlas":atlas_view()
  "market":atlas_view()
  "detail":detail_view()
 label(message,Vector2(30,625),22)
 label(tr("MARKET_LIVE_NOTE"),Vector2(30,675),17)
func sprite(h:Dictionary,pos:Vector2,size_px:float=130)->void:
 var tex:=TextureRect.new();tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 if h.get("stage","adult")=="foal":tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits)
 else:HorsePortrait.apply(tex,h.traits,SaveData.hat_color)
 tex.position=pos;tex.size=Vector2.ONE*size_px;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;content.add_child(tex)
func collection_view()->void:
 label(TranslationServer.translate_plural("UI_081","UI_081_PLURAL",SaveData.horse_collection.horses.size())%SaveData.horse_collection.horses.size(),Vector2(30,192),18)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(30,215);scroll.size=Vector2(1210,390);content.add_child(scroll)
 var rows:=VBoxContainer.new();rows.custom_minimum_size.x=1170;scroll.add_child(rows)
 for h in SaveData.horse_collection.horses:
  var row:=HBoxContainer.new();row.custom_minimum_size.y=100;rows.add_child(row)
  var tex:=TextureRect.new();tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits) if not SaveData.horse_collection.is_adult(h.id) else HorsePortrait.ART;tex.material=HorsePortrait.material_for(h.traits,SaveData.hat_color) if SaveData.horse_collection.is_adult(h.id) else null;tex.custom_minimum_size=Vector2(96,96);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(tex)
  var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=tr("UI_082")%[h.name,tr("UI_083") if h.get("stage","adult")=="foal" else "",tr(HorseCollection.COATS[h.traits.coat]),tr(HorseCollection.PATTERNS[h.traits.pattern]),tr(HorseCollection.MANES[h.traits.mane])];l.custom_minimum_size.x=510;row.add_child(l)
  var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);row.add_child(badge)
  var dodge_badge:=JumpBadge.new();dodge_badge.skill="dodge";dodge_badge.capable=HorseTraining.knows(h,"dodge");row.add_child(dodge_badge)
  if HorseEmblem.valid(h.traits.get("emblem")):
   var emblem:=TextureRect.new();emblem.texture=HorseEmblem.mask(h.traits.emblem);emblem.modulate=Color(HorseEmblem.COLORS[h.traits.emblem.color]);emblem.custom_minimum_size=Vector2(45,45);emblem.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;emblem.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(emblem)
  var eq:=Button.new();eq.text=tr("UI_060") if SaveData.horse_collection.selected==h.id else tr("UI_059");eq.disabled=SaveData.horse_collection.selected==h.id or not SaveData.horse_collection.is_adult(h.id);row.add_child(eq);eq.pressed.connect(func():
   message=(tr("UI_084") if SaveData.trial_session_active else tr("UI_085")) if SaveData.select_horse(h.id) else tr("UI_086");refresh())
  var fam:=Button.new();fam.text=tr("FICHA");row.add_child(fam);fam.pressed.connect(func():focus_id=h.id;show_page("detail"))
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
 label(tr("BIRTH_CREDITS")%SaveData.horse_collection.birth_credits if not SaveData.debug_mode and not SaveData.trial_session_active else tr("BIRTH_FREE"),Vector2(40,190),17)
 label(tr("UI_087"),Vector2(40,222),18);label(tr("UI_088"),Vector2(840,222),18)
 parent_picker(parent_a,Vector2(40,256),true);parent_picker(parent_b,Vector2(840,256),false)
 sprite(SaveData.horse_collection.find(parent_a),Vector2(110,330),105)
 sprite(SaveData.horse_collection.find(parent_b),Vector2(1045,330),105)
 label(tr("UI_089"),Vector2(420,222),18)
 var labels={"coat":tr("UI_129"),"pattern":tr("UI_130"),"mane":tr("UI_090"),"eyes":tr("UI_131")};var n:int=0
 for k in ["coat","pattern","mane","eyes"]:
  label(labels[k],Vector2(420,256+n*50),20)
  button("A" if choices[k]==0 else "B",Vector2(670,244+n*50),func():choices[k]=1-int(choices[k]);refresh(),65);n+=1
 label(tr("UI_091"),Vector2(850,510),20)
 var finish_source:String=parent_b if choices.get("finish",0)==1 else parent_a
 var finish_value:String=SaveData.horse_collection.find(finish_source).traits.get("finish","normal")
 button(("B" if choices.get("finish",0)==1 else "A")+" · "+("Galaxy" if finish_value=="galaxy" else "Normal"),Vector2(840,545),func():choices["finish"]=1-int(choices.get("finish",0));refresh(),340)
 var t:Dictionary=SaveData.horse_collection.preview(parent_a,parent_b,choices)
 if not t.is_empty():
  sprite({"traits":t,"stage":"foal"},Vector2(505,365),200)
  button(tr("UI_092"),Vector2(440,570),func():
   var h:Dictionary=SaveData.breed_horses(parent_a,parent_b,choices)
   message=(tr("BIRTH_NEED_WIN") if not SaveData.debug_mode and not SaveData.trial_session_active and SaveData.horse_collection.birth_credits<=0 else tr("UI_093")) if h.is_empty() else tr("UI_094")%h.name
   if not h.is_empty():focus_id=h.id
   refresh(),390)
 else:label(tr("UI_095"),Vector2(440,500),24)
func family_view()->void:
 var graph:=GenealogyPanel.new();add_child(graph);graph.select(focus_id);page="collection"

func detail_view()->void:
 var h:Dictionary=SaveData.horse_collection.find(focus_id)
 var is_owned:bool=not h.is_empty()
 if not is_owned:h=focus_preview
 if h.is_empty():return
 if not is_owned:
  label(tr(HorseCollection.COATS[h.traits.coat])+tr("UI_101"),Vector2(40,185),28);sprite(h,Vector2(60,245),300)
  label(tr("UI_102")+tr(HorseCollection.COATS[h.traits.coat])+tr("UI_103")+tr(HorseCollection.PATTERNS[h.traits.pattern])+tr("UI_104")+tr(HorseCollection.MANES[h.traits.mane]),Vector2(450,250),26)
  label(tr("MARKET_VALUE")%[tr(HorseCollection.RARITIES[HorseMarket.tier(h)]),HorseMarket.buy_price(h)],Vector2(450,380),22)
  var purchase:=button(tr("MARKET_BUY")%(0 if SaveData.debug_mode or SaveData.trial_session_active else HorseMarket.buy_price(h)),Vector2(450,440),func():confirm_trade(h,false),400);purchase.disabled=not SaveData.debug_mode and not SaveData.trial_session_active and (SaveData.equipment_points<HorseMarket.buy_price(h) or not HorseMarket.available(SaveData.horse_collection,h,SaveData.highest_level_completed))
  button(tr("UI_106"),Vector2(450,510),func():show_page("atlas"),340)
  return
 var title:=label(h.name,Vector2(40,190),27);title.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;title.size.x=365;title.clip_text=true
 if PackLeader.is_leader(h,SaveData.horse_collection):
  var badge:=label(tr("LEADER_TITLE"),Vector2(40,224),18);badge.add_theme_color_override("font_color",Color("ffd23d"))
 sprite(h,Vector2(70,250),235)
 var name_edit:=LineEdit.new();name_edit.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;name_edit.text=h.name;name_edit.placeholder_text=tr("UI_107");name_edit.max_length=60;name_edit.position=Vector2(40,495);name_edit.size=Vector2(200,48);content.add_child(name_edit)
 button(tr("UI_108"),Vector2(245,495),func():
  message=tr("UI_109") if SaveData.rename_horse(h.id,name_edit.text) else tr("UI_110");refresh(),160)
 if SaveData.horse_collection.is_adult(h.id):
  var equip:=button(tr("UI_060") if SaveData.horse_collection.selected==h.id else tr("UI_111"),Vector2(40,555),func():
   message=tr("UI_112") if SaveData.select_horse(h.id) else tr("UI_086");refresh(),360)
  equip.disabled=SaveData.horse_collection.selected==h.id
 label(tr("UI_102")+tr(HorseCollection.COATS[h.traits.coat])+tr("UI_103")+tr(HorseCollection.PATTERNS[h.traits.pattern])+tr("UI_113")+tr(HorseCollection.MANES[h.traits.mane]),Vector2(420,225),24)
 button(tr("EMBLEM_TITLE"),Vector2(420,505),func():
  var editor:=EmblemPanel.new();editor.horse_id=h.id;editor.saved.connect(refresh);add_child(editor),360).disabled=not SaveData.horse_collection.is_adult(h.id)
 var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);badge.position=Vector2(1120,225);badge.size=Vector2(64,56);content.add_child(badge)
 var dodge_badge:=JumpBadge.new();dodge_badge.skill="dodge";dodge_badge.capable=HorseTraining.knows(h,"dodge");dodge_badge.position=Vector2(1120,290);dodge_badge.size=Vector2(64,56);content.add_child(dodge_badge)
 var st:Dictionary=HorseStats.read(h)
 label(tr("UI_114")%[tr(HorseCollection.EYES[HorseCollection.eye_index(h.traits)]),st.speed,st.handling,st.power*100,st.dodge*100],Vector2(420,335),20)
 if not SaveData.horse_collection.is_adult(h.id):
  label(tr("UI_115"),Vector2(790,512),16)
  button(tr("UI_116"),Vector2(40,555),func():
   message=tr("UI_117") if SaveData.mature_horse_trial(h.id) else tr("UI_086");refresh(),360)
 label(tr("UI_118") if not SaveData.horse_collection.is_adult(h.id) else tr("UI_119")%SaveData.equipped_whip_reach(),Vector2(420,562),16)
 button(tr("UI_120"),Vector2(420,590),func():show_page("family"),420)
 var sell:=button(tr("MARKET_SELL")%HorseMarket.sell_price(h),Vector2(860,590),func():confirm_trade(h,true),360);sell.disabled=not HorseMarket.can_sell(SaveData.horse_collection,h.id)
 sell.tooltip_text=tr("MARKET_PROTECT")
func atlas_entries()->Array[Dictionary]:
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
  if page=="market" or not atlas_owned_first or not owned.has("%d_%d_%d"%[t.coat,t.pattern,t.mane]):result.append({"horse":{"traits":t,"name":HorseCollection.COATS[t.coat],"stage":"adult"},"owned":false})
 if not atlas_owned_first and page!="market":
  for entry in result:
   var t:Dictionary=entry.horse.traits
   for h in SaveData.horse_collection.horses:
    if h.traits.coat==t.coat and h.traits.pattern==t.pattern and h.traits.mane==t.mane:
     entry.horse=h;entry.owned=true;break
 return result
func atlas_view()->void:
 label(tr("MARKET_BALANCE")%SaveData.equipment_points if page=="market" else tr("UI_121"),Vector2(35,200),25)
 if page!="market":button(tr("UI_122") if atlas_owned_first else tr("UI_123"),Vector2(765,195),func():atlas_owned_first=not atlas_owned_first;atlas_page=0;refresh(),470)
 label(tr("MARKET_DESIGN_NOTE"),Vector2(35,236),17)
 if page=="market" and entries_empty():label(tr("MARKET_EMPTY"),Vector2(40,300),22)
 var entries:Array[Dictionary]=atlas_entries();var pages:int=maxi(1,ceili(entries.size()/8.0));atlas_page=clampi(atlas_page,0,pages-1)
 for j in range(8):
  var n:int=atlas_page*8+j
  if n>=entries.size():break
  var entry:Dictionary=entries[n];var h:Dictionary=entry.horse;var t:Dictionary=h.traits
  var x:float=35+(j%4)*305;var y:float=274+int(j/4)*160
  sprite(h,Vector2(x,y),90)
  var title:=label((h.name if page=="market" else ("✓ "+h.name if entry.owned else "? "+tr(HorseCollection.COATS[t.coat]))),Vector2(x+92,y),18);title.size=Vector2(205,30);title.clip_text=true
  label(tr(HorseCollection.PATTERNS[t.pattern])+" · "+tr(HorseCollection.MANES[t.mane]),Vector2(x+92,y+32),16)
  var open:=Button.new();open.flat=true;open.position=Vector2(x,y);open.size=Vector2(295,130);open.tooltip_text=tr("UI_126");content.add_child(open);open.pressed.connect(func():focus_id=str(h.get("id",""));focus_preview=h;show_page("detail"))
  label(tr(HorseCollection.RARITIES[HorseMarket.tier(h)]),Vector2(x+92,y+58),16)
  label(tr("MARKET_PRICE")%HorseMarket.buy_price(h),Vector2(x+92,y+82),16)
  if HorseJump.capable(h):
   var jump:=JumpBadge.new();jump.capable=true;jump.position=Vector2(x,y+88);jump.size=Vector2(64,56);content.add_child(jump)
 button(tr("UI_132"),Vector2(35,575),func():atlas_page=maxi(0,atlas_page-1);refresh())
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
