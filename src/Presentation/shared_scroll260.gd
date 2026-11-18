class_name SharedScroll260
extends Node
var views:Array[ScrollContainer]=[]
var queued:bool=false
var active:ScrollContainer
var finger:int=-1
var origin:Vector2
var last:Vector2
var start:Vector2
var velocity:Vector2=Vector2.ZERO
var moved:bool=false
var bar_axis:int=-1
var slider:Slider
var slider_start:float
var slider_mode:bool=false
var replay:bool=false
var stamp:int=0
func _ready():
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().node_added.connect(_added);_scan.call_deferred()
func _added(_node):
 if not queued:queued=true;_scan.call_deferred()
func _scan():
 queued=false;_collect(get_tree().root)
func _collect(n:Node):
 if n is ScrollContainer and not views.has(n):
  views.append(n);n.set_meta("shared_scroll260",true);n.clip_contents=true
  for bar in [n.get_v_scroll_bar(),n.get_h_scroll_bar()]:
   bar.custom_minimum_size=Vector2(24,24)
   bar.add_theme_stylebox_override("scroll",RanchTheme.box(Color("17333d"),Color("35545e"),8))
   for style in ["grabber","grabber_highlight","grabber_pressed"]:bar.add_theme_stylebox_override(style,RanchTheme.box(Color("caa35d"),Color("f7d58a"),8))
  if n.vertical_scroll_mode!=ScrollContainer.SCROLL_MODE_DISABLED:n.vertical_scroll_mode=ScrollContainer.SCROLL_MODE_AUTO
 for c in n.get_children():_collect(c)
func _rank(n:Node)->int:
 var rank:int=0
 while n!=null:
  if n is CanvasLayer:rank+=n.layer*100000
  if n is CanvasItem:rank+=n.z_index*1000
  n=n.get_parent()
 return rank
func _modals(n:Node,point:Vector2,out:Array):
 for c in n.get_children():
  if c is Control and c.has_meta("ui_modal") and c.is_visible_in_tree() and c.get_global_rect().has_point(point):out.append(c)
  _modals(c,point,out)
func at(point:Vector2)->ScrollContainer:
 var found:ScrollContainer
 var modals:Array=[];_modals(get_tree().root,point,modals)
 var best:int=-99999
 var index:int=0
 for v in views:
  index+=1
  if not is_instance_valid(v) or not v.is_visible_in_tree() or not v.get_global_rect().has_point(point):continue
  var covered:bool=false
  var v_rank:int=_rank(v)
  for modal in modals:
   if not modal.is_ancestor_of(v) and modal!=v and not v.is_ancestor_of(modal) and _rank(modal)>=v_rank:covered=true
  if covered:continue
  var n:Node=v;var rank:int=index;var clipped:bool=false
  while n!=null:
   if n is CanvasLayer:rank+=n.layer*100000
   if n is CanvasItem:rank+=n.z_index*1000
   if n is Control and n.clip_contents and not n.get_global_rect().has_point(point):clipped=true
   n=n.get_parent()
  if not clipped and rank>=best:found=v;best=rank
 return found
func _slider(n:Node,point:Vector2)->Slider:
 for c in n.get_children():
  if c is Slider and c.is_visible_in_tree() and c.get_global_rect().has_point(point):return c
  var nested:=_slider(c,point)
  if nested!=null:return nested
 return null
func _offset(v:ScrollContainer)->Vector2:return Vector2(v.scroll_horizontal,v.scroll_vertical)
func _scale(v:ScrollContainer)->Vector2:return v.get_global_transform().get_scale().abs().max(Vector2(.01,.01))
func _set_offset(value:Vector2):
 if not is_instance_valid(active):return
 active.scroll_horizontal=roundi(value.x);active.scroll_vertical=roundi(value.y)
func _input(e:InputEvent):
 if replay:return
 if e is InputEventMouseButton and e.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN]:
  var view:=at(e.position)
  if view!=null:
   if e.pressed:view.scroll_vertical+=(-90 if e.button_index==MOUSE_BUTTON_WHEEL_UP else 90)
   velocity=Vector2.ZERO;get_viewport().set_input_as_handled()
 elif e is InputEventScreenTouch:
  if e.pressed:
   var v:=at(e.position)
   if v==null:return
   get_viewport().set_input_as_handled()
   if finger!=-1:return
   active=v;finger=e.index;origin=e.position;last=origin;start=_offset(v);velocity=Vector2.ZERO;moved=false;bar_axis=-1;slider_mode=false;slider=_slider(v,e.position)
   if slider!=null:slider_start=slider.value
   for axis in 2:
    var bar:ScrollBar=v.get_h_scroll_bar() if axis==0 else v.get_v_scroll_bar()
    if bar.visible and bar.get_global_rect().grow(4).has_point(e.position):bar_axis=axis
   stamp=Time.get_ticks_msec()
  elif e.index==finger:
   get_viewport().set_input_as_handled();finger=-1
   if e.canceled:velocity=Vector2.ZERO;active=null;return
   if not moved and bar_axis<0 and is_instance_valid(active) and active.get_global_rect().has_point(e.position):
    velocity=Vector2.ZERO;_click.call_deferred(e.position)
   if bar_axis>=0 or slider_mode:velocity=Vector2.ZERO
 elif e is InputEventScreenDrag and e.index==finger:
  get_viewport().set_input_as_handled()
  if not is_instance_valid(active) or not active.is_visible_in_tree():cancel();return
  var delta_:Vector2=(e.position-origin)/_scale(active)
  if not moved and delta_.length()>12:
   moved=true;slider_mode=is_instance_valid(slider) and absf(delta_.x)>absf(delta_.y)*1.3 and bar_axis<0
  if moved:
   if slider_mode:
    slider.value=slider_start+delta_.x/maxf(1.,slider.size.x)*(slider.max_value-slider.min_value)
   elif bar_axis>=0:
    var bar:ScrollBar=active.get_h_scroll_bar() if bar_axis==0 else active.get_v_scroll_bar()
    var extent:float=bar.size.x if bar_axis==0 else bar.size.y
    var thumb:float=maxf(24.,extent*bar.page/maxf(1.,bar.max_value))
    var offset:=start;offset[bar_axis]+=delta_[bar_axis]*(bar.max_value-bar.page)/maxf(1.,extent-thumb);_set_offset(offset)
   else:
    _set_offset(start-delta_)
    var now:=Time.get_ticks_msec();var dt:float=maxf(.008,(now-stamp)/1000.)
    velocity=velocity.lerp((last-e.position)/_scale(active)/dt,.5).limit_length(1800.)
  last=e.position;stamp=Time.get_ticks_msec()
 elif e is InputEventMouse and e.device==InputEvent.DEVICE_ID_EMULATION and (finger!=-1 or at(e.position)!=null):get_viewport().set_input_as_handled()
func _process(dt:float):
 if finger!=-1:return
 if not is_instance_valid(active) or not active.is_visible_in_tree():velocity=Vector2.ZERO;return
 if velocity.length()<8:velocity=Vector2.ZERO;return
 var before:=_offset(active);_set_offset(before+velocity*minf(dt,.04));var after:=_offset(active)
 if after.x==before.x:velocity.x=0
 if after.y==before.y:velocity.y=0
 velocity=velocity.move_toward(Vector2.ZERO,4000.*dt)
func _click(point:Vector2):
 replay=true
 for down in [true,false]:
  var e:=InputEventMouseButton.new();e.position=point;e.global_position=point;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;e.button_mask=MOUSE_BUTTON_MASK_LEFT if down else 0
  Input.parse_input_event(e.xformed_by(get_viewport().get_final_transform()));Input.flush_buffered_events()
 replay=false
func cancel():finger=-1;velocity=Vector2.ZERO;active=null
func _notification(what):
 if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED]:cancel()
