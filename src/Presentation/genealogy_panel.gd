class_name GenealogyPanel
extends Control
var collection:HorseCollection
var canvas:Control
var view:ScrollContainer
var world:Control
var info:Label
var counter:Label
var query:String=""
var filters:Dictionary={}
var only_matches:bool=false
var zoom:float=0.8
var selected:String=""
var lineage_filter:String=""
var origin_filter:int=0
var dragging:bool=false
var drag_start:Vector2
var drag_scroll:Vector2
func _ready()->void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=110
 collection=SaveData.horse_collection
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(_layout);_layout()
 _label(tr("GEN_TITLE"),Vector2(25,15),28)
 _button(tr("UI_009"),Vector2(1080,15),175,queue_free)
 var search:=LineEdit.new();search.placeholder_text=tr("GEN_SEARCH");search.position=Vector2(25,60);search.size=Vector2(330,46);canvas.add_child(search);search.text_changed.connect(func(v):query=v;draw_graph())
 var keys:Array=["coat","pattern","mane","eyes","finish"]
 var names:Array=[HorseCollection.COATS,HorseCollection.PATTERNS,HorseCollection.MANES,HorseCollection.EYES,["Normal","Galaxy","Original"]]
 for i in range(5):
  var pick:=OptionButton.new();pick.position=Vector2(365+i*176,60);pick.size=Vector2(168,46);pick.add_item(tr(["UI_129","UI_130","UI_090","UI_131","UI_091"][i]));pick.set_item_metadata(0,-1);canvas.add_child(pick)
  for j in range(names[i].size()):pick.add_item(tr(names[i][j]));pick.set_item_metadata(j+1,j)
  pick.item_selected.connect(func(n):filters[keys[i]]=int(pick.get_item_metadata(n));draw_graph())
 _button(tr("GEN_HIGHLIGHT"),Vector2(25,115),260,func():only_matches=false;draw_graph())
 _button(tr("GEN_ONLY"),Vector2(295,115),260,func():only_matches=true;draw_graph())
 _button("−",Vector2(570,115),65,func():set_zoom(zoom-.15));_button("+",Vector2(645,115),65,func():set_zoom(zoom+.15))
 _button(tr("GEN_RESET_VIEW"),Vector2(725,115),200,func():set_zoom(.8);view.scroll_horizontal=0;view.scroll_vertical=0)
 counter=_label("",Vector2(940,125),19)
 var lineage_pick:=OptionButton.new();lineage_pick.position=Vector2(25,163);lineage_pick.size=Vector2(350,44);lineage_pick.add_item(tr("GEN_ALL_LINEAGES"));canvas.add_child(lineage_pick)
 var labels:Array[String]=[]
 for h in HorseGenealogy.records(collection):
  var value:String=HorseGenealogy.lineage(h)
  if not labels.has(value):labels.append(value);lineage_pick.add_item(value)
 lineage_pick.item_selected.connect(func(n):lineage_filter="" if n==0 else labels[n-1];draw_graph())
 var origin_pick:=OptionButton.new();origin_pick.position=Vector2(390,163);origin_pick.size=Vector2(350,44);canvas.add_child(origin_pick)
 for key in ["GEN_ALL_ORIGINS","GEN_BRED","GEN_PURCHASED","GEN_ROOT"]:origin_pick.add_item(tr(key))
 origin_pick.item_selected.connect(func(n):origin_filter=n;draw_graph())
 view=ScrollContainer.new();view.position=Vector2(25,215);view.size=Vector2(1230,310);view.mouse_filter=Control.MOUSE_FILTER_PASS;canvas.add_child(view)
 view.gui_input.connect(_map_input)
 info=_label(tr("GEN_HINT"),Vector2(25,540),19);info.size=Vector2(1230,150);info.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 draw_graph()
func _layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func _label(text:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);canvas.add_child(l);return l
func _button(text:String,pos:Vector2,w:float,cb:Callable)->Button:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(w,44);b.pressed.connect(cb);canvas.add_child(b);return b
func set_zoom(value:float)->void:
 zoom=clampf(value,.35,1.8);draw_graph()
func _map_input(event:InputEvent)->void:
 if event is InputEventMagnifyGesture:set_zoom(zoom*event.factor)
 if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
  dragging=event.pressed;drag_start=event.position;drag_scroll=Vector2(view.scroll_horizontal,view.scroll_vertical)
 if event is InputEventMouseMotion and dragging:
  var delta:Vector2=event.position-drag_start;view.scroll_horizontal=int(drag_scroll.x-delta.x);view.scroll_vertical=int(drag_scroll.y-delta.y)
func _unhandled_input(event:InputEvent)->void:
 if event is InputEventMagnifyGesture:set_zoom(zoom*event.factor);get_viewport().set_input_as_handled()
func draw_graph()->void:
 if view==null:return
 for child in view.get_children():view.remove_child(child);child.queue_free()
 world=Control.new();world.mouse_filter=Control.MOUSE_FILTER_PASS;view.add_child(world);world.gui_input.connect(_map_input)
 var positions:Dictionary=HorseGenealogy.layout(collection);var hits:int=0;var shown:Dictionary={};var bounds:Vector2=Vector2(1200,350)
 for h in HorseGenealogy.records(collection):
  var ok:bool=_matches(h);if ok:hits+=1
  if only_matches and not ok:continue
  shown[h.id]=true;bounds=bounds.max(positions[h.id]+Vector2(250,190))
 world.custom_minimum_size=bounds*zoom
 var layer:=Control.new();layer.mouse_filter=Control.MOUSE_FILTER_PASS;layer.scale=Vector2.ONE*zoom;layer.size=bounds;world.add_child(layer);layer.gui_input.connect(_map_input)
 for h in HorseGenealogy.records(collection):
  if not shown.has(h.id):continue
  for parent in h.parents:
   if not shown.has(parent):continue
   var a:Vector2=positions[parent]+Vector2(115,160);var b:Vector2=positions[h.id]+Vector2(115,0);var line:=Line2D.new();line.width=3;line.default_color=Color("729b9c");line.points=PackedVector2Array([a,b]);layer.add_child(line)
 for h in HorseGenealogy.records(collection):
  if not shown.has(h.id):continue
  var card:=Button.new();card.position=positions[h.id];card.size=Vector2(230,160);card.text="";card.add_theme_stylebox_override("normal",RanchTheme.box(Color("245346") if _matches(h) else Color("1e333d"),Color("e7c67f") if selected==h.id else Color("6d9b94"),10));card.modulate.a=1 if _matches(h) else .4;layer.add_child(card)
  var tex:=TextureRect.new();tex.position=Vector2(8,8);tex.size=Vector2(65,70);tex.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;tex.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;tex.mouse_filter=Control.MOUSE_FILTER_IGNORE
  if h.get("stage","adult")=="foal":tex.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits)
  else:HorsePortrait.apply(tex,h.traits,SaveData.hat_color)
  card.add_child(tex)
  var text:=Label.new();text.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;text.position=Vector2(80,10);text.size=Vector2(142,65);text.text=str(h.name);text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;text.add_theme_font_size_override("font_size",17);text.mouse_filter=Control.MOUSE_FILTER_IGNORE;card.add_child(text)
  var desc:=Label.new();desc.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;desc.position=Vector2(10,83);desc.size=Vector2(210,70);desc.text=tr(HorseCollection.COATS[h.traits.coat])+" · "+tr(HorseCollection.PATTERNS[h.traits.pattern])+"\n"+HorseGenealogy.lineage(h)+"\n"+(tr("GEN_ROOT") if h.parents.is_empty() else HorseGenealogy.origin(h));desc.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;desc.add_theme_font_size_override("font_size",13);desc.mouse_filter=Control.MOUSE_FILTER_IGNORE;card.add_child(desc)
  card.pressed.connect(func():select(h.id))
  card.gui_input.connect(func(event):
   if event is InputEventScreenDrag:
    view.scroll_horizontal-=int(event.relative.x);view.scroll_vertical-=int(event.relative.y))
 counter.text=tr("GEN_COUNT")%[hits,HorseGenealogy.records(collection).size()]
 if hits==0:info.text=tr("GEN_EMPTY")
func _matches(h:Dictionary)->bool:
 var simple:Dictionary=filters.duplicate();simple.erase("finish")
 if not HorseGenealogy.matches(h,query,simple):return false
 if not lineage_filter.is_empty() and HorseGenealogy.lineage(h)!=lineage_filter:return false
 if origin_filter==1 and h.parents.is_empty():return false
 if origin_filter==2 and h.get("origin","")!="purchased":return false
 if origin_filter==3 and not h.parents.is_empty():return false
 var f:int=int(filters.get("finish",-1));return f<0 or h.traits.get("finish","normal")==["normal","galaxy","original"][f]
func select(id:String)->void:
 selected=id;var h:Dictionary=collection.known_record(id);var parents:Array=[]
 for p in h.parents:parents.append(str(collection.known_record(p).get("name",p)))
 info.text=str(h.name)+" · "+HorseGenealogy.lineage(h)+"\n"+tr("GEN_PARENTS")+(" + ".join(parents) if not parents.is_empty() else tr("GEN_UNRECORDED"))+"\n"+tr("GEN_NO_INVENT")
 draw_graph()
