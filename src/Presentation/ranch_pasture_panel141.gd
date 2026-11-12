class_name RanchPasturePanel141
extends Control
signal horse_opened(id:String)
signal list_requested
signal closed
const AdultArt=preload("res://src/Presentation/wild_horse_art.gd")
var canvas:Control
var content:Control
var tier:int=-1
var page_index:int=0
var family_id:String=""
var animated:Array=[]
func _ready():
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=100;MenuInputGuard.install(self)
 var bg:=ColorRect.new();bg.color=RanchTheme.INK;bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(_layout);_layout();refresh()
func _layout():
 if canvas==null:return
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func _label(text:String,at:Vector2,width:float=280,font:int=20)->Label:
 var l:=Label.new();l.text=text;l.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED;l.position=at;l.size.x=width;l.text_overrun_behavior=TextServer.OVERRUN_TRIM_ELLIPSIS;l.tooltip_text=text;l.add_theme_font_size_override("font_size",font);content.add_child(l);return l
func _button(text:String,at:Vector2,width:float,action:Callable)->Button:
 var b:=Button.new();b.text=text;b.position=at;b.size=Vector2(width,48);content.add_child(b);b.pressed.connect(action);return b
func refresh():
 if content!=null:canvas.remove_child(content);content.queue_free()
 animated.clear();content=Control.new();canvas.add_child(content)
 MenuNavigation.header(content,"MI RANCHO" if family_id.is_empty() else "FAMILIA EN EL RANCHO",func():
  if not family_id.is_empty():family_id="";refresh()
  else:closed.emit())
 if not family_id.is_empty():_family();return
 _button("Ver lista de colección",Vector2(760,23),265,func():list_requested.emit())
 var tabs:Array=["Todos"]+HorseCollection.RARITIES
 for i in tabs.size():
  var t:int=i-1;var amount:int=RanchPastures141.horses(SaveData.horse_collection,t).size()
  var b:=_button(str(tabs[i])+" · %d"%amount,Vector2(30+i*206,92),194,func():tier=t;page_index=0;refresh())
  b.disabled=tier==t
 var all_:Array=RanchPastures141.horses(SaveData.horse_collection,tier)
 var pages:int=maxi(1,ceili(float(all_.size())/RanchPastures141.PAGE_SIZE));page_index=clampi(page_index,0,pages-1)
 _label("Adultos en movimiento · potrillos quietos · toca un caballo para ver su ficha",Vector2(30,150),1210,20)
 var entries:Array=RanchPastures141.page(SaveData.horse_collection,tier,page_index)
 if entries.is_empty():_label("Todavía no tienes caballos en este corral.",Vector2(300,350),700,28)
 for i in entries.size():_card(entries[i],Vector2(30+(i%4)*310,190+int(i/4)*145))
 var prev:=_button("Anterior",Vector2(330,650),190,func():page_index-=1;refresh());prev.disabled=page_index==0
 _label("%d / %d · %d caballos"%[page_index+1,pages,all_.size()],Vector2(535,662),250,21)
 var next:=_button("Siguiente",Vector2(790,650),190,func():page_index+=1;refresh());next.disabled=page_index==pages-1
func _ground(rect:Rect2):
 var panel:=Panel.new();panel.position=rect.position;panel.size=rect.size;panel.mouse_filter=Control.MOUSE_FILTER_IGNORE
 panel.add_theme_stylebox_override("panel",RanchTheme.box(Color("49763b"),Color("c29966"),8));content.add_child(panel)
func _actor(h:Dictionary,feet:Vector2,scale_:float=1.0):
 if h.get("stage","adult")=="foal":
  var foal:=Sprite2D.new();foal.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,h.traits);foal.position=feet;foal.offset=Vector2(0,-foal.texture.get_height()/2.);foal.scale=Vector2.ONE*50./foal.texture.get_height()*scale_;content.add_child(foal)
 else:
  var art=AdultArt.new();art.configure_preview141(h);art.position=feet;art.scale=Vector2.ONE*scale_;content.add_child(art);art.set_motion107(Vector2(120,0));art.walk_dir="side";art._update_anim();animated.append(art)
func _card(h:Dictionary,at:Vector2):
 _ground(Rect2(at,Vector2(295,132)))
 _actor(h,at+Vector2(66,104),.95)
 if GalaxyPure143.is_pure(h):_label(GalaxyPure143.BADGE,at+Vector2(4,110),108,12).modulate=RanchTheme.GOLD
 _label(str(h.name),at+Vector2(115,8),170,21)
 _label(("Potrillo" if h.get("stage","adult")=="foal" else "Adulto")+(" · equipado" if h.id==SaveData.horse_collection.selected else ""),at+Vector2(115,38),170,18)
 var tap:=_button("",at+Vector2(2,4),108,func():horse_opened.emit(str(h.id)));tap.size.y=124;tap.tooltip_text="Ver ficha: "+str(h.name)
 for state in ["normal","hover","pressed","focus"]:tap.add_theme_stylebox_override(state,StyleBoxEmpty.new())
 var open:=_button("Ficha",at+Vector2(120,74),150,func():horse_opened.emit(str(h.id)));open.name="PastureHorse_"+str(h.id)
 if h.parents.size()==2:
  open.size.x=74
  var fam:=_button("Familia",at+Vector2(200,74),83,func():family_id=h.id;refresh());fam.add_theme_font_size_override("font_size",16)
func _family():
 var members:Array=RanchPastures141.family(SaveData.horse_collection,family_id)
 _label("Padres y cría · solo vista, no cambia crecimiento ni habilidades",Vector2(30,105),1200,22)
 _ground(Rect2(70,190,1140,350))
 for i in members.size():
  var h:Dictionary=members[i];var x:float=230.+i*360.
  _actor(h,Vector2(x,430),1.8 if h.get("stage","adult")=="adult" else 1.5)
  _label(str(h.name),Vector2(x-140,450),280,24)
  _label(("Progenitor" if i<members.size()-1 else ("Cría · "+GalaxyPure143.BADGE if GalaxyPure143.is_pure(h) else "Cría"))+(" · vendido, registro familiar" if h.get("sold",false) else ""),Vector2(x-140,487),280,18)
 _label("Potrillos estáticos · esta vista no acelera el crecimiento ni cambia el adiestramiento.",Vector2(90,590),1130,21)
