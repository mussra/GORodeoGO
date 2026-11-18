class_name MenuNavigation
extends RefCounted
## Shared header and large entry cards. Sections never repeat their parent tabs.
const ICONS302={"editor":"res://art/ui/ant_icons187/05.png","book256":"res://art/ui/frontier303/book.png","crowns240":"res://art/ui/frontier303/crowns.png","rodeo240":"res://art/ui/frontier303/mission.png","debug213":"res://art/ui/frontier303/debug.png","performance245":"res://art/ui/frontier303/performance.png","modular_preview":"res://art/ui/ant_icons187/05.png","country146":"res://art/ui/menu_entries189/atlas.png","country_saved152":"res://art/ui/menu_entries189/atlas.png","mode":"res://art/ui/ant_icons187/05.png","tools":"res://art/ui/icons300/horse.png"}
static func header(host:Control,title:String,back:Callable)->void:
 var heading:=Label.new();heading.text=title;heading.position=Vector2(30,22);heading.add_theme_font_size_override("font_size",30);host.add_child(heading);TextFit181.fixed(heading,Vector2(990,48),30,22)
 var button:=Button.new();button.name="NavigationBack";button.text="VOLVER";button.position=Vector2(1050,20);button.size=Vector2(200,56);button.pressed.connect(back);host.add_child(button);ButtonSkin272.apply(button);button.icon=EquipmentIcon229.texture300("back");button.expand_icon=true;button.add_theme_constant_override("icon_max_width",34)
static func cards(host:Control,entries:Array,selected:Callable)->void:
 var cols:int=2 if entries.size()==4 else 3
 var width:float=560 if cols==2 else 380
 var gap:float=600 if cols==2 else 410
 for i in entries.size():
  var entry:Dictionary=entries[i].duplicate();
  if not entry.has("icon223") and ICONS302.has(str(entry.id)):
   entry.icon223=ICONS302[str(entry.id)];entry.compact250=true
  var button:=Button.new();button.name="Navigate_"+str(entry.id);button.tooltip_text=str(entry.title);button.position=Vector2(40+i%cols*gap,150+int(i/cols)*200);button.size=Vector2(width,165);button.pressed.connect(selected.bind(str(entry.id)));host.add_child(button)
  for state in ["normal","hover","pressed","focus"]:
   var box:=StyleBoxFlat.new();box.bg_color=Color("1b3d49") if state=="normal" else Color("285a68");box.border_color=Color("478b9a") if state=="normal" else Color("a1f1ef");box.set_border_width_all(2 if state!="focus" else 3);box.set_corner_radius_all(16);button.add_theme_stylebox_override(state,box)
  ButtonSkin272.apply(button)
  if entry.has("icon223") and entry.get("compact250",false):
   var icon:=TextureRect.new();icon.name="GameIcon223";icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.texture=load(str(entry.icon223));icon.position=Vector2(12,39);icon.size=Vector2(82,82);icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;icon.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(icon)
   var title:=Label.new();title.name="GameName223";title.text=str(entry.title);title.position=Vector2(104,20);title.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(title);TextFit181.fixed(title,Vector2(width-116,54),24,20,2)
   var hint:=Label.new();hint.name="GameHint250";hint.text=str(entry.get("hint",""));hint.position=Vector2(104,81);hint.add_theme_color_override("font_color",Color("bbd4dc"));hint.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(hint);TextFit181.fixed(hint,Vector2(width-116,66),19,17,3)
   if entry.get("locked251",false):
    button.self_modulate=Color("67757b");icon.modulate=Color("778086");title.modulate=Color("a6b1b5");hint.modulate=Color("9ba8ad")
    var lock:=Label.new();lock.text="BLOQUEADO";lock.position=Vector2(104,139);lock.add_theme_font_size_override("font_size",12);lock.modulate=Color("839298");lock.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(lock)
   continue
  if entry.has("icon223"):
   var icon:=TextureRect.new();icon.name="GameIcon223";icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.texture=load(str(entry.icon223));icon.position=Vector2((width-104.)*.5,10);icon.size=Vector2(104,104);icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;icon.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(icon)
   var caption:=Label.new();caption.name="GameName223";caption.text=str(entry.title);caption.position=Vector2(10,120);caption.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;caption.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(caption);TextFit181.fixed(caption,Vector2(width-20,34),22,18,1)
   continue
  var glyph:=MenuGlyph.new();glyph.kind=str(entry.id);glyph.position=Vector2(22,30);glyph.size=Vector2(60,60);button.add_child(glyph)
  var title:=Label.new();title.text=str(entry.title);title.position=Vector2(96,28);title.add_theme_font_size_override("font_size",27);title.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(title);TextFit181.fixed(title,Vector2(width-115,48),27,20,2)
  var hint:=Label.new();hint.text=str(entry.get("hint",""));hint.position=Vector2(96,80);hint.size=Vector2(width-115,62);hint.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;hint.add_theme_font_size_override("font_size",19);hint.modulate=Color("bbd4dc");hint.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(hint);TextFit181.fixed(hint,Vector2(width-115,62),19,18,2)
static func reveal(host:Control)->void:
 host.modulate.a=0.0
 host.create_tween().tween_property(host,"modulate:a",1.0,.14)
