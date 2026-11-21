class_name ScareButton265
extends Button
## Explicit action, larger than the 76px clocks. Text + clock-style arc.
var player:CharacterBody2D
var cooldown265:float=0.
var cooldown_total265:float=5.
var pulse265:float=0.
var affected265:int=0
var status271:Label
var audio265:AudioStreamPlayer
func _ready():
 name="ScareButton265";set_meta("independent_touch301",true);size=Vector2(112,112);custom_minimum_size=size;focus_mode=Control.FOCUS_NONE;QuestButtonStyle.apply(self);add_theme_font_size_override("font_size",18)
 tooltip_text="Solo ruido: no toca ni hace daño a ningún animal"
 get_viewport().size_changed.connect(layout301);layout301()
 var art:=TextureRect.new();art.name="WhipArt271";art.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;art.position=Vector2(22,6);art.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;art.texture=load("res://art/equipment271/latigo.png");art.size=Vector2(68,68);art.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;art.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(art);art.set_deferred("size",Vector2(68,68))
 ActionIcons327.attach327(self,1)
 status271=get_node_or_null("ActionLabel327")
 if status271==null:
  status271=Label.new();status271.position=Vector2(4,77);status271.size=Vector2(104,29);status271.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;status271.add_theme_font_size_override("font_size",18);status271.add_theme_color_override("font_color",Color("30200d"));status271.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(status271)
 pressed.connect(activate265)
 audio265=AudioStreamPlayer.new();audio265.stream=load("res://audio/scare265.wav");add_child(audio265)
 _refresh265()
func settings265()->Dictionary:
 var item:=EquipmentEffects._equipped_item("scare_whip")
 return AnimalScare265.for_quality305(int(item.get("scare_level265",1)))
func can_activate265()->bool:
 if not is_instance_valid(player) or cooldown265>0. or EquipmentEffects._equipped_item("scare_whip").is_empty():return false
 if not player.is_physics_processing() or get_tree().paused:return false
 if float(player.get("_stun_time_remaining"))>0.:return false
 var host:Node=player.get_parent()
 if "_npc_dialog" in host and is_instance_valid(host._npc_dialog):return false
 return true
func activate265():
 if not can_activate265():return
 var settings:=settings265();cooldown_total265=float(settings.cooldown);cooldown265=cooldown_total265;pulse265=.35;affected265=0
 for animal in get_tree().get_nodes_in_group("scare_animals265"):
  if animal is Node2D and AnimalScare265.apply_to(animal,player.global_position,settings):affected265+=1
 if GameState.sound_enabled:audio265.play()
 WhipKindness301.show_once(self)
 _refresh265()
func _process(delta:float):
 cooldown265=maxf(0.,cooldown265-delta);pulse265=maxf(0.,pulse265-delta);_refresh265()
func _refresh265():
 visible=not EquipmentEffects._equipped_item("scare_whip").is_empty()
 text=""
 if is_instance_valid(status271):status271.text="%d s"%int(ceil(cooldown265)) if cooldown265>0. else "LÁTIGO"
 disabled=not can_activate265();queue_redraw()
func _draw():
 if cooldown265>0.:draw_arc(size*.5,49.,-PI*.5,-PI*.5+TAU*(1.-cooldown265/maxf(.01,cooldown_total265)),48,Color("ffe29b"),4.,true)
 if pulse265>0.:draw_arc(size*.5,44.+(1.-pulse265/.35)*9.,0.,TAU,48,Color("f7cf7c",pulse265/.35),3.,true)

static func placement301(extent:Vector2,safe:Rect2=Rect2())->Vector2:
 var area:=Rect2(Vector2.ZERO,extent) if safe.size==Vector2.ZERO else safe.intersection(Rect2(Vector2.ZERO,extent))
 return Vector2(maxf(area.position.x+16.,area.end.x-128.),clampf(extent.y-210.,area.position.y+90.,area.end.y-128.))
func layout301()->void:
 var safe:=Rect2()
 if OS.has_feature("android") or OS.has_feature("ios"):
  var raw:=Rect2(DisplayServer.get_display_safe_area())
  if raw.size.x>0. and raw.size.y>0.:
   safe=get_viewport().get_final_transform().affine_inverse()*raw
 position=placement301(get_viewport_rect().size,safe)
