class_name AttributeBar306
extends ProgressBar
## Shared five-sector scale. Gold is the current property; mint is an improvement.
var baseline306:float=-1.0
var ends306:bool=true
var fill306:Color=Color("e8c16f")
func _ready()->void:
 show_percentage=false;mouse_filter=Control.MOUSE_FILTER_IGNORE
 add_theme_stylebox_override('background',StyleBoxEmpty.new());add_theme_stylebox_override('fill',StyleBoxEmpty.new())
 value_changed.connect(func(_v):queue_redraw());resized.connect(queue_redraw)
func _draw()->void:
 var fraction:float=clampf((value-min_value)/maxf(.0001,max_value-min_value),0.,1.)
 var baseline:float=baseline306 if baseline306>=0. else fraction
 var top:float=13. if ends306 else 1.
 var height:float=maxf(7.,size.y-top-2.)
 var gap:float=4.;var width:float=(size.x-gap*4.)/5.
 for i in AttributeRanges306.SECTORS:
  var box:=Rect2(Vector2(i*(width+gap),top),Vector2(width,height))
  draw_style_box(RanchTheme.box(Color('183b46'),Color('bd9750'),3),box)
  var lo:float=float(i)/5.;var portion:float=clampf((fraction-lo)*5.,0.,1.)
  if portion>0.:draw_rect(Rect2(box.position+Vector2(2,2),Vector2(maxf(0.,(width-4.)*portion),height-4.)),fill306)
  var start:float=clampf((baseline-lo)*5.,0.,1.)
  if portion>start:draw_rect(Rect2(box.position+Vector2(2+(width-4.)*start,2),Vector2((width-4.)*(portion-start),height-4.)),Color('68d9bc'))
 if baseline306>=0.:
  var marker:float=clampf(baseline306,0.,1.)*size.x
  draw_line(Vector2(marker,top-2),Vector2(marker,top+height+2),Color("fff1d2"),2.)
 if ends306:
  var font:=ThemeDB.fallback_font
  draw_string(font,Vector2(0,10),'Peor',HORIZONTAL_ALIGNMENT_LEFT,-1,11,RanchTheme.CREAM)
  draw_string(font,Vector2(size.x-38,10),'Mejor',HORIZONTAL_ALIGNMENT_LEFT,-1,11,RanchTheme.CREAM)
