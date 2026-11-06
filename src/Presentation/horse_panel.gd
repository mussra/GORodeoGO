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
 button(tr("GEN_TITLE"),Vector2(795,130),func():add_child(GenealogyPanel.new()),360)
 var random_button:=button(tr("UI_076"),Vector2(795,75),func():
  if not SaveData.debug_mode and not SaveData.trial_session_active and not SaveData.begin_trial_session():
   message=tr("UI_077");refresh();return
  var before:Dictionary=SaveData.horse_collection.export_state();var added:Array[Dictionary]=SaveData.horse_collection.add_random_trial_pair();
  if not SaveData.save_progress():SaveData.horse_collection.restore(before);message=tr("UI_086");refresh();return
  parent_b=added[0].id;page="collection";scroll_to_newest=true;message=tr("UI_078")%SaveData.horse_collection.horses.size();refresh(),360)
 random_button.visible=SaveData.debug_mode or SaveData.trial_session_active
 var trial_note:=label(tr("UI_079"),Vector2(30,138),18);trial_note.size=Vector2(745,28);trial_note.clip_text=true
 match page:
  "collection":collection_view()
  "breed":breed_view()
  "family":family_view()
  "atlas":atlas_view()
  "detail":detail_view()
 label(message,Vector2(30,625),22)
 label(tr("UI_080"),Vector2(30,675),18)
func sprite(h:Dictionary,pos:Vector2,size_px:float=130)->void:
 var tex:=TextureRect.new();tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 if h.get("stage","adult")=="foal":tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits)
 else:HorsePortrait.apply(tex,h.traits,SaveData.hat_color)
 tex.position=pos;tex.size=Vector2.ONE*size_px;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;content.add_child(tex)
func collection_view()->void:
 label(tr("UI_081")%SaveData.horse_collection.horses.size(),Vector2(30,162),18)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(30,185);scroll.size=Vector2(1210,420);content.add_child(scroll)
 var rows:=VBoxContainer.new();rows.custom_minimum_size.x=1170;scroll.add_child(rows)
 for h in SaveData.horse_collection.horses:
  var row:=HBoxContainer.new();row.custom_minimum_size.y=100;rows.add_child(row)
  var tex:=TextureRect.new();tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits) if not SaveData.horse_collection.is_adult(h.id) else HorsePortrait.ART;tex.material=HorsePortrait.material_for(h.traits,SaveData.hat_color) if SaveData.horse_collection.is_adult(h.id) else null;tex.custom_minimum_size=Vector2(96,96);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;row.add_child(tex)
  var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=tr("UI_082")%[h.name,tr("UI_083") if h.get("stage","adult")=="foal" else "",tr(HorseCollection.COATS[h.traits.coat]),tr(HorseCollection.PATTERNS[h.traits.pattern]),tr(HorseCollection.MANES[h.traits.mane])];l.custom_minimum_size.x=590;row.add_child(l)
  var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);row.add_child(badge)
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
 label(tr("UI_087"),Vector2(40,185));label(tr("UI_088"),Vector2(840,185))
 parent_picker(parent_a,Vector2(40,220),true);parent_picker(parent_b,Vector2(840,220),false)
 sprite(SaveData.horse_collection.find(parent_a),Vector2(110,310),105)
 sprite(SaveData.horse_collection.find(parent_b),Vector2(1045,310),105)
 label(tr("UI_089"),Vector2(390,185),21)
 var labels={"coat":tr("UI_129"),"pattern":tr("UI_130"),"mane":tr("UI_090"),"eyes":tr("UI_131")};var n:int=0
 for k in ["coat","pattern","mane","eyes"]:
  label(labels[k],Vector2(420,230+n*50),20)
  button("A" if choices[k]==0 else "B",Vector2(670,218+n*50),func():choices[k]=1-int(choices[k]);refresh(),65);n+=1
 label(tr("UI_091"),Vector2(850,510),20)
 var finish_source:String=parent_b if choices.get("finish",0)==1 else parent_a
 var finish_value:String=SaveData.horse_collection.find(finish_source).traits.get("finish","normal")
 button(("B" if choices.get("finish",0)==1 else "A")+" · "+("Galaxy" if finish_value=="galaxy" else "Normal"),Vector2(840,545),func():choices["finish"]=1-int(choices.get("finish",0));refresh(),340)
 var t:Dictionary=SaveData.horse_collection.preview(parent_a,parent_b,choices)
 if not t.is_empty():
  sprite({"traits":t,"stage":"foal"},Vector2(505,375),200)
  button(tr("UI_092"),Vector2(440,570),func():
   var h:Dictionary=SaveData.breed_horses(parent_a,parent_b,choices)
   message=tr("UI_093") if h.is_empty() else tr("UI_094")%h.name
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
  label(tr("UI_105"),Vector2(450,430),22)
  button(tr("UI_106"),Vector2(450,510),func():show_page("atlas"),340)
  return
 var title:=label(h.name,Vector2(40,175),27);title.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;title.size.x=365;title.clip_text=true
 sprite(h,Vector2(70,250),235)
 var name_edit:=LineEdit.new();name_edit.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;name_edit.text=h.name;name_edit.placeholder_text=tr("UI_107");name_edit.max_length=60;name_edit.position=Vector2(40,485);name_edit.size=Vector2(200,48);content.add_child(name_edit)
 button(tr("UI_108"),Vector2(245,485),func():
  message=tr("UI_109") if SaveData.rename_horse(h.id,name_edit.text) else tr("UI_110");refresh(),160)
 if SaveData.horse_collection.is_adult(h.id):
  var equip:=button(tr("UI_060") if SaveData.horse_collection.selected==h.id else tr("UI_111"),Vector2(40,545),func():
   message=tr("UI_112") if SaveData.select_horse(h.id) else tr("UI_086");refresh(),360)
  equip.disabled=SaveData.horse_collection.selected==h.id
 label(tr("UI_102")+tr(HorseCollection.COATS[h.traits.coat])+tr("UI_103")+tr(HorseCollection.PATTERNS[h.traits.pattern])+tr("UI_113")+tr(HorseCollection.MANES[h.traits.mane]),Vector2(420,220),24)
 var badge:=JumpBadge.new();badge.capable=HorseJump.capable(h);badge.position=Vector2(420,470);badge.size=Vector2(64,56);content.add_child(badge)
 var st:Dictionary=HorseStats.read(h)
 label(tr("UI_114")%[tr(HorseCollection.EYES[HorseCollection.eye_index(h.traits)]),st.speed,st.handling,st.power*100,st.dodge*100],Vector2(420,340),22)
 if not SaveData.horse_collection.is_adult(h.id):
  label(tr("UI_115"),Vector2(560,505),18)
  button(tr("UI_116"),Vector2(40,545),func():
   message=tr("UI_117") if SaveData.mature_horse_trial(h.id) else tr("UI_086");refresh(),360)
 label(tr("UI_118") if not SaveData.horse_collection.is_adult(h.id) else tr("UI_119")%SaveData.equipped_whip_reach(),Vector2(560,535),18)
 button(tr("UI_120"),Vector2(420,570),func():show_page("family"),420)
func atlas_entries()->Array[Dictionary]:
 var result:Array[Dictionary]=[];var owned:Dictionary={}
 for h in SaveData.horse_collection.horses:
  result.append({"horse":h,"owned":true})
  owned["%d_%d_%d"%[h.traits.coat,h.traits.pattern,h.traits.mane]]=true
 if not atlas_owned_first:
  result.clear()
 for n in range(HorseCollection.COATS.size()*HorseCollection.PATTERNS.size()*HorseCollection.MANES.size()):
  var t:Dictionary={"coat":int(n/(HorseCollection.PATTERNS.size()*6)),"pattern":int(n/6)%HorseCollection.PATTERNS.size(),"mane":n%6}
  if not atlas_owned_first or not owned.has("%d_%d_%d"%[t.coat,t.pattern,t.mane]):result.append({"horse":{"traits":t,"name":HorseCollection.COATS[t.coat],"stage":"adult"},"owned":false})
 if not atlas_owned_first:
  for entry in result:
   var t:Dictionary=entry.horse.traits
   for h in SaveData.horse_collection.horses:
    if h.traits.coat==t.coat and h.traits.pattern==t.pattern and h.traits.mane==t.mane:
     entry.horse=h;entry.owned=true;break
 return result
func atlas_view()->void:
 label(tr("UI_121"),Vector2(35,170),25)
 button(tr("UI_122") if atlas_owned_first else tr("UI_123"),Vector2(765,165),func():atlas_owned_first=not atlas_owned_first;atlas_page=0;refresh(),470)
 label(tr("UI_124"),Vector2(35,208),18)
 var entries:Array[Dictionary]=atlas_entries();var pages:int=ceili(entries.size()/8.0);atlas_page=clampi(atlas_page,0,pages-1)
 for j in range(8):
  var n:int=atlas_page*8+j
  if n>=entries.size():break
  var entry:Dictionary=entries[n];var h:Dictionary=entry.horse;var t:Dictionary=h.traits
  var x:float=35+(j%4)*305;var y:float=250+int(j/4)*160
  sprite(h,Vector2(x,y),90)
  var title:=label(("✓ "+h.name if entry.owned else "? "+tr(HorseCollection.COATS[t.coat])),Vector2(x+92,y),18);title.size=Vector2(205,30);title.clip_text=true
  label(tr(HorseCollection.PATTERNS[t.pattern])+tr("UI_125")+tr(HorseCollection.MANES[t.mane]),Vector2(x+92,y+32),16)
  var open:=Button.new();open.flat=true;open.position=Vector2(x,y);open.size=Vector2(295,130);open.tooltip_text=tr("UI_126");content.add_child(open);open.pressed.connect(func():focus_id=str(h.get("id",""));focus_preview=h;show_page("detail"))
  if not entry.owned:label(tr("UI_127"),Vector2(x+92,y+87),16)
 button(tr("UI_132"),Vector2(35,575),func():atlas_page=maxi(0,atlas_page-1);refresh())
 label(tr("UI_128")%[atlas_page+1,pages],Vector2(345,585),23)
 button(tr("UI_133"),Vector2(650,575),func():atlas_page=mini(pages-1,atlas_page+1);refresh())
