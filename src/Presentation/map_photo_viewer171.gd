class_name MapPhotoViewer171
extends CanvasLayer
## Original saved image, full viewport, aspect preserved. No save changes.
var image:Image
var picture:TextureRect
var close_button:Button
var canvas:Control
func _ready():
 layer=250;process_mode=Node.PROCESS_MODE_ALWAYS
 canvas=Control.new();canvas.mouse_filter=Control.MOUSE_FILTER_STOP;add_child(canvas)
 var bg:=ColorRect.new();bg.color=Color("081419f5");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);canvas.add_child(bg)
 picture=TextureRect.new();picture.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;picture.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;picture.mouse_filter=Control.MOUSE_FILTER_IGNORE
 if image!=null:picture.texture=ImageTexture.create_from_image(image)
 canvas.add_child(picture)
 close_button=Button.new();close_button.text="Cerrar imagen";QuestButtonStyle.apply(close_button);canvas.add_child(close_button);close_button.pressed.connect(queue_free)
 get_viewport().size_changed.connect(layout);layout()
func layout():
 var size_:Vector2=get_viewport().get_visible_rect().size
 canvas.size=size_;picture.position=Vector2(12,64);picture.size=(size_-Vector2(24,76)).max(Vector2.ONE);close_button.position=Vector2(maxf(12,size_.x-240),8);close_button.size=Vector2(228,48)
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):queue_free();get_viewport().set_input_as_handled()
static func open(owner_:Node,image_:Image)->MapPhotoViewer171:
 if image_==null:return null
 var viewer:=MapPhotoViewer171.new();viewer.image=image_;owner_.add_child(viewer);return viewer
