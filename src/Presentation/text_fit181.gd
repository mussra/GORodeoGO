class_name TextFit181
extends RefCounted
## Two explicit contracts: bounded summaries, or complete flowing text in a scroll.
static func fixed(label:Label,extent:Vector2,preferred:int=22,minimum:int=18,lines:int=1)->void:
 label.custom_minimum_size=Vector2.ZERO
 label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART if lines>1 else TextServer.AUTOWRAP_OFF
 label.clip_text=true;label.text_overrun_behavior=TextServer.OVERRUN_TRIM_ELLIPSIS
 label.max_lines_visible=lines;label.size=extent;label.tooltip_text=label.text
 label.set_meta("text_fit181",{"extent":extent,"preferred":preferred,"minimum":minimum,"lines":lines})
 _fit(label)
 if not label.has_meta("text_fit181_bound"):
  label.set_meta("text_fit181_bound",true)
  label.draw.connect(func():
   var signature:=var_to_str([label.text,label.get_meta("text_fit181")])
   if label.get_meta("text_fit181_signature","")!=signature:_fit.call_deferred(label))
static func _fit(label:Label)->void:
 if not is_instance_valid(label):return
 var spec:Dictionary=label.get_meta("text_fit181");var extent:Vector2=spec.extent
 var font:Font=label.get_theme_font("font");var chosen:int=spec.minimum
 var padding:Vector2=label.get_theme_stylebox("normal").get_minimum_size()
 for n in range(int(spec.preferred),int(spec.minimum)-1,-1):
  label.add_theme_font_size_override("font_size",n);label.size=extent
  var count:int=label.get_line_count()
  var height:float=count*label.get_line_height()+maxi(0,count-1)*label.get_theme_constant("line_spacing")+padding.y
  var width:float=font.get_string_size(label.text,HORIZONTAL_ALIGNMENT_LEFT,-1,n).x if spec.lines==1 else 0.
  if count<=spec.lines and height<=extent.y and width<=extent.x-padding.x:chosen=n;break
 label.add_theme_font_size_override("font_size",chosen);label.size=extent;label.tooltip_text=label.text
 label.set_meta("text_fit181_signature",var_to_str([label.text,spec]))
static func flow(label:Label,width:float=0.)->void:
 label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.clip_text=false
 label.text_overrun_behavior=TextServer.OVERRUN_NO_TRIMMING;label.max_lines_visible=-1
 label.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 if width>0:label.custom_minimum_size.x=width;label.size.x=width
static func button(button:Button,extent:Vector2=Vector2.ZERO)->void:
 button.clip_text=true;button.text_overrun_behavior=TextServer.OVERRUN_TRIM_ELLIPSIS;button.tooltip_text=button.text
 if extent!=Vector2.ZERO:button.size=extent
