class_name HorseVictory251
extends CanvasLayer
var reward:Dictionary={}
var canvas:Control
var progress:float=0.0
var bar:ProgressBar
var spark:Control
static func present(host:Node)->void:
 var data:Dictionary=SaveData.take_growth251()
 if data.is_empty():return
 var view:=HorseVictory251.new();view.reward=data;host.add_child(view)
func _ready()->void:
 layer=120;process_mode=Node.PROCESS_MODE_ALWAYS
 var screen:=Control.new();screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(screen);MenuInputGuard.install(screen)
 var shade:=ColorRect.new();shade.color=Color(0.015,.04,.055,.9);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);screen.add_child(shade)
 canvas=Control.new();canvas.size=Vector2(1280,720);screen.add_child(canvas);get_viewport().size_changed.connect(_layout);_layout()
 var panel:=Panel.new();panel.position=Vector2(150,72);panel.size=Vector2(980,576);panel.add_theme_stylebox_override("panel",RanchTheme.box(Color("14333d"),Color("dfbc74"),24));canvas.add_child(panel)
 _label("VICTORIA · TU CABALLO MEJORA",Vector2(198,101),29,Color("ffe1a1"))
 _label(str(reward.horse.name),Vector2(198,156),35,Color("fff3cf"))
 var portrait:=TextureRect.new();portrait.position=Vector2(196,228);portrait.size=Vector2(310,260);portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;portrait.texture=PixelLabTrial.pose_texture("horse","side",0,reward.horse.traits,reward.horse);portrait.mouse_filter=Control.MOUSE_FILTER_IGNORE
 if not HorseFinish168.style(reward.horse).is_empty():portrait.material=HorseAdorn169.material(reward.horse,HorseFinish168.selected_spec("walk","horse"),0)
 canvas.add_child(portrait)
 var stats:=HorseStats.read(reward.horse)
 for i in HorseSummary185.STATS.size():
  var spec:Array=HorseSummary185.STATS[i];var active:bool=spec[1]==reward.get("key","");var y:float=234.+i*48.
  _label(spec[0]+("  +" if active else ""),Vector2(548,y),22,Color("ffe1a1") if active else Color("a7bdc1"))
  var line:=HorseStatBars.row(canvas,"",VictoryGrowth251.visual(spec,stats[spec[1]]),0.,1.,true);line.position=Vector2(748,y+4);line.size=Vector2(300,30);line.get_child(0).custom_minimum_size.x=0;line.get_child(0).hide()
  if active:
   bar=line.get_child(1);bar.step=0.;bar.value=VictoryGrowth251.visual([reward.title,reward.key,reward.low,base_high251()],reward.before);bar.add_theme_stylebox_override("fill",StyleBoxEmpty.new())
 var message:String=str(reward.title)+" mejorada · progreso guardado"
 if reward.has("new_horse"):message+="\nNuevo caballo en tu cuadra: "+str(reward.new_horse.name)
 if reward.has("champion"):message+="\nLinaje maestro: "+str(reward.champion.name)
 if reward.get("fallback",false):message+="\nLa propiedad de este modo ya estaba al máximo."
 _label(message,Vector2(198,477),20,Color("d5e3dd"))
 var close:=Button.new();close.name="Continue251";close.text="Continuar";close.position=Vector2(738,558);close.size=Vector2(310,60);canvas.add_child(close);close.pressed.connect(queue_free)
 spark=GrowthSpark251.new();spark.name="GrowthIncrement252";spark.mouse_filter=Control.MOUSE_FILTER_IGNORE;spark.clip_contents=false;bar.add_child(spark)
 _advance.call_deferred(0.)
 if not reward.get("maxed",false):
  var tween:=create_tween();tween.tween_interval(.35);tween.tween_method(_advance,0.,1.,1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT);tween.tween_callback(func():_advance(1.));tween.tween_method(_fade_effect253,1.,0.,1.0)
 else:spark.hide()
func _advance(value:float)->void:
 progress=value
 if bar!=null:bar.value=VictoryGrowth251.visual([reward.title,reward.key,reward.low,base_high251()],lerpf(reward.before,reward.after,value))
 var spec:Array=[reward.title,reward.key,reward.low,base_high251()]
 var before:float=VictoryGrowth251.visual(spec,reward.before)
 var current:float=VictoryGrowth251.visual(spec,lerpf(reward.before,reward.after,value))
 var inner_width:float=maxf(0.,bar.size.x-2.)
 spark.position=Vector2(1.,1.)
 spark.size=Vector2(inner_width,maxf(0.,bar.size.y-2.))
 spark.old_x=inner_width*before;spark.current_x=inner_width*current
 spark.phase=value;spark.queue_redraw()
func _fade_effect253(value:float)->void:
 spark.effect_alpha=value;spark.queue_redraw()
func base_high251()->float:
 for spec in HorseSummary185.STATS:
  if spec[1]==reward.key:return spec[3]
 return reward.high
func _layout()->void:
 var size_:Vector2=get_viewport().get_visible_rect().size;var k:float=minf(size_.x/1280.,size_.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size_-Vector2(1280,720)*k)/2.
func _label(text_:String,at:Vector2,font:int,color:Color)->void:
 var label:=Label.new();label.text=text_;label.position=at;label.add_theme_font_size_override("font_size",font);label.add_theme_color_override("font_color",color);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;canvas.add_child(label)
 if at.y==477:TextFit181.fixed(label,Vector2(875,76),font,16,3)
 elif at.y==156:TextFit181.fixed(label,Vector2(875,64),font,24,2)
func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):queue_free();get_viewport().set_input_as_handled()
class GrowthSpark251 extends Control:
 const BASE_COLOR=Color("ffcf70")
 const INCREMENT_COLOR=Color("68edce")
 var phase:float=0.
 var old_x:float=0.
 var current_x:float=0.
 var effect_alpha:float=1.
 static func rounded253(color:Color,width:float,height:float)->StyleBoxFlat:
  var style:=StyleBoxFlat.new();style.bg_color=color;style.set_corner_radius_all(int(minf(5.,minf(width,height)*.5)));return style
 func star_origin253()->Vector2:return Vector2((old_x+current_x)*.5,size.y*.5)
 func _draw():
  var width:float=maxf(0.,current_x-old_x)
  if current_x>0.:draw_style_box(rounded253(BASE_COLOR,current_x,size.y),Rect2(Vector2.ZERO,Vector2(current_x,size.y)))
  if width<=0.:return
  draw_style_box(rounded253(INCREMENT_COLOR,width,size.y),Rect2(Vector2(old_x,0),Vector2(width,size.y)))
  # The burst is rooted at the earned interval. Rays may extend outside the
  # narrow bar so even a small real improvement has a readable visual effect.
  var center:=star_origin253();var alpha:float=effect_alpha*minf(1.,phase*5.)
  var radius:float=5.+sin(phase*PI)*5.
  draw_circle(center,radius*1.8,Color(.40,1.,.84,alpha*.16))
  draw_circle(center,radius*1.2,Color(.65,1.,.91,alpha*.3))
  var points:=PackedVector2Array()
  for i in 8:
   var angle:float=-PI*.5+i*PI*.25;var r:float=radius if i%2==0 else radius*.24
   points.append(center+Vector2(cos(angle),sin(angle))*r)
  draw_colored_polygon(points,Color(1.,1.,.91,alpha))
  draw_line(center-Vector2(0,radius*1.65),center+Vector2(0,radius*1.65),Color(.76,1.,.96,alpha*.7),1.5,true)
