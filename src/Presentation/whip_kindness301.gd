class_name WhipKindness301
extends Control
## Sound waves and horse deliberately separated. No contact or strike drawing.
const PREF_PATH="user://whip_kindness301.cfg"
const MESSAGE="¡Solo ruido! No toca ni hace daño a ningún animal."
var left301:float=8.
static func show_once(host:Node)->void:
 var cfg:=ConfigFile.new()
 if cfg.load(PREF_PATH)==OK and bool(cfg.get_value("notice","seen",false)):return
 var notice:=WhipKindness301.new();host.get_parent().add_child(notice)
 cfg.set_value("notice","seen",true);cfg.save(PREF_PATH)
func _ready():
 mouse_filter=Control.MOUSE_FILTER_IGNORE;z_index=80
 var label:=Label.new();label.text=MESSAGE;label.position=Vector2(108,15);label.size=Vector2(530,70);label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.add_theme_font_size_override("font_size",22);label.add_theme_color_override("font_color",Color("fff1d2"));label.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(label)
 get_viewport().size_changed.connect(layout301);layout301()
func layout301():
 var extent:=get_viewport_rect().size
 position=Vector2(maxf(16.,(extent.x-660.)*.5),82.);size=Vector2(650,100);queue_redraw()
func _process(delta:float):
 left301-=delta
 if left301<=0.:queue_free()
func _draw():
 draw_style_box(RanchTheme.box(Color("10252dfa"),Color("efb950"),14),Rect2(Vector2.ZERO,size))
 # Sound source on left, waves face away from the existing horse emblem on the right.
 for radius in [13.,22.,31.]:draw_arc(Vector2(43,49),radius,PI*.65,PI*1.35,18,Color("f7cf7c"),3.,true)
 draw_circle(Vector2(46,49),5.,Color("f7cf7c"))
 draw_texture_rect(EquipmentIcon229.texture300("horse"),Rect2(61,30,40,40),false)
