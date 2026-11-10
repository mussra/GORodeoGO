class_name ToastStack
extends Control
## Shared compact, nonblocking notices. One visible; the rest wait FIFO.
const MAX_VISIBLE:int=1
var active:Array[Dictionary]=[]
var pending:Array[Dictionary]=[]
var column:VBoxContainer
var top_offset:float=60.0
static func reading_seconds(text:String,minimum:float=0.0)->float:
 return maxf(minimum,clampf(2.5+float(text.length())/24.0,3.0,7.0))
static func backdrop(label:Label)->void:
 var box:=RanchTheme.box(Color(0.035,0.09,0.12,.56),Color(.45,.65,.64,.8),10)
 box.content_margin_left=10;box.content_margin_right=10
 box.content_margin_top=5;box.content_margin_bottom=5
 label.add_theme_stylebox_override("normal",box)
 label.add_theme_color_override("font_color",Color("fff1d2"))
 label.mouse_filter=Control.MOUSE_FILTER_IGNORE
func _ready()->void:
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 column=VBoxContainer.new();column.mouse_filter=Control.MOUSE_FILTER_IGNORE
 column.add_theme_constant_override("separation",8);add_child(column)
 get_viewport().size_changed.connect(_layout);_layout()
func _layout()->void:
 if column==null:return
 var viewport_size:Vector2=get_viewport_rect().size
 var width:float=minf(640.0,viewport_size.x*.44)
 column.position=Vector2(16,top_offset)
 column.size.x=width
 for notice in active:notice.label.custom_minimum_size.x=width
func set_top(value:float)->void:
 if is_equal_approx(top_offset,value):return
 top_offset=value;_layout()
func push(text:String,minimum:float=0.0)->void:
 if text.strip_edges().is_empty():return
 var duration:float=reading_seconds(text,minimum)
 for notice in active:
  if notice.text==text:notice.left=maxf(notice.left,duration);notice.label.modulate.a=1.0;return
 for notice in pending:
  if notice.text==text:notice.duration=maxf(notice.duration,duration);return
 pending.append({"text":text,"duration":duration});_fill()
func _fill()->void:
 if column==null:return
 while active.size()<MAX_VISIBLE and not pending.is_empty():
  var next:Dictionary=pending.pop_front()
  var label:=Label.new();label.auto_translate_mode=Node.AUTO_TRANSLATE_MODE_DISABLED
  label.text=next.text;label.horizontal_alignment=HORIZONTAL_ALIGNMENT_LEFT
  label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  label.add_theme_font_size_override("font_size",20);backdrop(label)
  label.custom_minimum_size.x=column.size.x
  column.add_child(label)
  active.append({"text":next.text,"left":next.duration,"label":label})
func _process(delta:float)->void:advance(delta)
func advance(delta:float)->void:
 for i in range(active.size()-1,-1,-1):
  active[i].left-=delta
  if active[i].left<=0.0:
   var label:Label=active[i].label;column.remove_child(label);label.queue_free();active.remove_at(i)
  else:active[i].label.modulate.a=clampf(active[i].left/.5,0.0,1.0)
 _fill()
func clear()->void:
 pending.clear()
 for notice in active:column.remove_child(notice.label);notice.label.queue_free()
 active.clear()
