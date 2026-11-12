class_name SiestaCurtain147
extends CanvasLayer
## Shared siesta visual. The destination adapter owns state, loading and commits.
var destination:String=""
var horse:Dictionary={}
var hat:String="original"
var message:Label
var zlabel:Label
var clock:float=0.
func _ready():
 layer=220;process_mode=Node.PROCESS_MODE_ALWAYS
 var cover:=ColorRect.new();cover.color=Color("10252d");cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(cover)
 var image:=TextureRect.new();HorsePortrait.apply_horse(image,horse,hat);image.position=Vector2(480,200);image.size=Vector2(320,320);cover.add_child(image)
 zlabel=Label.new();zlabel.text="Z z z";zlabel.add_theme_font_size_override("font_size",42);zlabel.position=Vector2(780,190);cover.add_child(zlabel)
 message=Label.new();message.text="Una siesta rumbo a "+destination;message.position=Vector2(120,550);message.size.x=1040;message.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;message.add_theme_font_size_override("font_size",28);cover.add_child(message)
 var fit:Callable=func():
  var size_:Vector2=get_viewport().get_visible_rect().size;var k:float=minf(size_.x/1280.,size_.y/720.);image.scale=Vector2.ONE*k;image.position=(size_-Vector2(320,320)*k)/2.;zlabel.position=image.position+Vector2(300,-20)*k;message.position=Vector2(20,size_.y*.80);message.size.x=size_.x-40
 cover.resized.connect(fit);fit.call()
func _process(delta:float):
 clock+=delta
 if is_instance_valid(zlabel):zlabel.modulate.a=.55+.45*sin(clock*4.);zlabel.rotation=sin(clock*2.)*.08
