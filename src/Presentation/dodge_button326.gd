class_name DodgeButton326
extends Button
## One explicit, independent action for every scene using the shared regate.
var player:CharacterBody2D
func _ready()->void:
 name='DodgeButton326';set_meta('independent_touch301',true)
 size=Vector2(112,112);custom_minimum_size=size;focus_mode=Control.FOCUS_NONE
 QuestButtonStyle.apply(self);add_theme_font_size_override('font_size',16)
 tooltip_text='Tiempo bala: pulsa Regate y dibuja con el mando izquierdo. Suelta el mando para ejecutar.'
 pressed.connect(activate326)
 get_viewport().size_changed.connect(layout326);layout326();_refresh326()
func activate326()->void:
 if not disabled and is_instance_valid(player):player.dodge.begin_drawing326()
func _process(_delta:float)->void:_refresh326()
func _refresh326()->void:
 if not is_instance_valid(player) or player.dodge==null:hide();return
 var d:DodgeController=player.dodge
 visible=d.available and player.is_visible_in_tree() and player.is_physics_processing() and not get_tree().paused
 disabled=not visible or d.drawing or d.cooldown>0. or d.remaining>0. or not d.path.is_empty() or not d.can_start.call()
 text='DIBUJA\nizquierda' if d.drawing else 'REGATE\n%d s'%ceili(d.cooldown) if d.cooldown>0. else 'TIEMPO\nBALA'
 queue_redraw()
func _draw()->void:
 if is_instance_valid(player) and player.dodge.cooldown>0.:
  draw_arc(size*.5,49.,-PI*.5,-PI*.5+TAU*(1.-player.dodge.cooldown/maxf(.01,player.dodge.recharge_seconds)),48,Color('ffe29b'),4.,true)
static func placement326(extent:Vector2,safe:Rect2=Rect2())->Vector2:
 return ScareButton265.placement301(extent,safe)-Vector2(124,0)
func layout326()->void:
 var safe:=Rect2()
 if OS.has_feature('android') or OS.has_feature('ios'):
  var raw:=Rect2(DisplayServer.get_display_safe_area())
  if raw.has_area():safe=get_viewport().get_final_transform().affine_inverse()*raw
 position=placement326(get_viewport_rect().size,safe)
