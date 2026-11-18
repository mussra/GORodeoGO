class_name BuildingRoom262
extends CanvasLayer
## Shared illustrated-room shell. A missing painting is explicitly a prototype,
## not a procedurally drawn replacement for Ant's artwork.
signal closed
signal conversation_requested
signal object_requested(id:String,kind:String)
var title:String="INTERIOR"
var background_path:String=""
var npc_path:String=""
var npc_name:String=""
var prototype:bool=true
var canvas:Control
var message:Label
var objects:BoxContainer
var closing:bool=false
func _ready():
 layer=124;process_mode=Node.PROCESS_MODE_ALWAYS
 var root:=Control.new();root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(root);MenuInputGuard.install(root)
 var backdrop:=ColorRect.new();backdrop.color=Color("102a30");backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);root.add_child(backdrop)
 canvas=Control.new();canvas.size=Vector2(1280,720);root.add_child(canvas);get_viewport().size_changed.connect(_fit);_fit()
 var heading:=_label(title,Vector2(36,22),Vector2(1208,46),30);heading.add_theme_color_override("font_color",Color("f7cf7c"))
 if not background_path.is_empty() and ResourceLoader.exists(background_path):_image(background_path,Vector2(120,78),Vector2(1040,520))
 elif prototype:
  _label("MAQUETA FUNCIONAL · FONDO ILUSTRADO PENDIENTE",Vector2(40,90),Vector2(1200,35),21)
  _label("Solo imágenes existentes de Ant. No es el arte final del interior.",Vector2(40,132),Vector2(1200,36),20)
 if not npc_path.is_empty():_image(npc_path,Vector2(800,188),Vector2(300,340))
 var nameplate:=_label(npc_name,Vector2(790,486),Vector2(320,32),23);nameplate.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
 objects=BoxContainer.new();objects.vertical=true;objects.position=Vector2(44,214);objects.size=Vector2(540,235);objects.add_theme_constant_override("separation",16);canvas.add_child(objects)
 message=_label("Puedes mirar. Si te interesa algo, habla con quien atiende.",Vector2(44,555),Vector2(710,70),22)
 _button("Salir al rancho",Vector2(210,650),Vector2(370,54),finish)
 _button("Hablar con "+npc_name,Vector2(620,650),Vector2(520,54),func():conversation_requested.emit())
func add_object(id:String,caption:String,kind:String,description:String):
 assert(kind in ["inspect","ask"]) # The player shows interest; the owner decides any offer.
 var button:=Button.new();button.text=caption;button.custom_minimum_size=Vector2(540,64);QuestButtonStyle.apply(button);objects.add_child(button)
 button.pressed.connect(func():
  message.text=description
  object_requested.emit(id,kind))
func _label(text_:String,at:Vector2,extent:Vector2,font:int)->Label:
 var label:=Label.new();label.text=text_;label.position=at;label.size=extent;label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.mouse_filter=Control.MOUSE_FILTER_IGNORE;label.add_theme_font_size_override("font_size",font);canvas.add_child(label);return label
func _image(path_:String,at:Vector2,extent:Vector2)->TextureRect:
 var image:=TextureRect.new();image.texture=load(path_);image.position=at;image.size=extent;image.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;image.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;image.mouse_filter=Control.MOUSE_FILTER_IGNORE;canvas.add_child(image);image.size=extent;return image
func _button(text_:String,at:Vector2,extent:Vector2,action:Callable):
 var button:=Button.new();button.text=text_;button.position=at;button.size=extent;QuestButtonStyle.apply(button);canvas.add_child(button);button.pressed.connect(action)
func _fit():
 var extent:=get_viewport().get_visible_rect().size;var k:float=minf(extent.x/1280.,extent.y/720.)
 canvas.scale=Vector2.ONE*k;canvas.position=(extent-Vector2(1280,720)*k)*.5
func finish():
 if closing:return
 closing=true;closed.emit();queue_free()
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):finish();get_viewport().set_input_as_handled()
