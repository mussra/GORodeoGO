class_name ItemPager
extends Control
## One previous/next control. Hit boxes stay fixed; only the arrow glyph sways.
signal changed(index:int)
var index:int=0
var total:int=0
var previous:Button
var next:Button
var counter:Label
var _left:Control
var _right:Control
var _elapsed:float=0
static func create(host:Control,pos:Vector2,width:float,current:int,count:int,selected:Callable)->ItemPager:
 var pager:=ItemPager.new();pager.name="ItemPager";pager.position=pos;pager.size=Vector2(width,56);pager.index=current;pager.total=count;host.add_child(pager);pager.changed.connect(selected);return pager
func _ready()->void:
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 previous=Button.new();previous.name="PreviousItem";previous.tooltip_text="Anterior";previous.size=Vector2(56,56);add_child(previous)
 next=Button.new();next.name="NextItem";next.tooltip_text="Siguiente";next.size=Vector2(56,56);add_child(next)
 _left=_glyph(previous,"←");_right=_glyph(next,"→")
 counter=Label.new();counter.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;counter.vertical_alignment=VERTICAL_ALIGNMENT_CENTER;counter.mouse_filter=Control.MOUSE_FILTER_IGNORE;counter.add_theme_font_size_override("font_size",19);add_child(counter)
 previous.pressed.connect(func():_step(-1));next.pressed.connect(func():_step(1));resized.connect(_layout);_layout();set_state(index,total)
func _glyph(host:Button,text:String)->Control:
 var holder:=Control.new();holder.mouse_filter=Control.MOUSE_FILTER_IGNORE;holder.size=Vector2(56,56);host.add_child(holder)
 var icon:=TextureRect.new();icon.texture=AntIcons187.texture(13 if text=="←" else 14);icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;icon.position=Vector2(8,8);icon.size=Vector2(40,40);icon.mouse_filter=Control.MOUSE_FILTER_IGNORE;holder.add_child(icon);return holder
func _layout()->void:
 if next==null:return
 next.position=Vector2(size.x-56,0);counter.position=Vector2(56,0);counter.size=Vector2(maxf(0,size.x-112),56)
func set_state(current:int,count:int)->void:
 total=maxi(0,count);index=clampi(current,0,maxi(0,total-1))
 if previous==null:return
 MenuInputGuard.set_button_disabled(previous,total<2 or index<=0);MenuInputGuard.set_button_disabled(next,total<2 or index>=total-1)
 counter.text=("%d/%d" if size.x<220 else "%d / %d")%[index+1 if total else 0,total]
 counter.add_theme_font_size_override("font_size",13 if size.x<220 else 19)
 _left.position.x=0;_right.position.x=0;_left.modulate.a=.3 if previous.disabled else 1.0;_right.modulate.a=.3 if next.disabled else 1.0
 set_process(total>1)
func _step(direction:int)->void:
 var target:int=index+direction
 if target<0 or target>=total:return
 set_state(target,total);changed.emit(index)
func _process(delta:float)->void:
 if not is_visible_in_tree():return
 _left.modulate.a=.3 if previous.disabled else 1.0;_right.modulate.a=.3 if next.disabled else 1.0
 _elapsed+=delta;var sway:float=sin(_elapsed*3.0)*3.0
 _left.position.x=-sway if not previous.disabled else 0.0
 _right.position.x=sway if not next.disabled else 0.0
