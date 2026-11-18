class_name BuildingRoom262
extends CanvasLayer
## Shared illustrated-room shell. A missing painting is explicitly a prototype,
## not a procedurally drawn replacement for Ant's artwork.
signal closed
signal conversation_requested
signal object_requested(id:String,kind:String)
signal collectible_found264(site_id:String,item_id:String,ownership:String)
var search264:=InteriorSearch264.new()
var search_regions264:Dictionary={}
var search_buttons264:Dictionary={}
var title:String="INTERIOR"
var background_path:String=""
var npc_path:String=""
var npc_name:String=""
var prototype:bool=true
var canvas:Control
var message:Label
var objects:BoxContainer
var closing:bool=false
var room_id264:String=""
var pending264:Array[String]=[]
var exit_dialog264:NpcDialog
var exit_block264:Control
var found_names264:Dictionary={}
var reserved_ui264:Array[Rect2]=[Rect2(0,590,1280,130)]
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
 if closing or is_instance_valid(exit_dialog264):return
 if not pending264.is_empty():
  show_exit_conversation264();return
 close_room264()
func close_room264():
 if closing:return
 closing=true;closed.emit();queue_free()
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel") and is_instance_valid(exit_dialog264):exit_dialog264.closed.emit();get_viewport().set_input_as_handled();return
 if event.is_action_pressed("ui_cancel"):finish();get_viewport().set_input_as_handled()

## Sites are authored regions. Decorative taps elsewhere and UI taps do not count.
## Discovery emits an event only; the owner/inventory workflow must authorize
## and save any subsequent transfer before it can announce a receipt.
func add_search_site264(id:String,region:Rect2,item_id:String="",ownership:String="owner")->bool:
 if not search_region_allowed264(region) or search_buttons264.has(id):return false
 search264.define(id,item_id,ownership);search_regions264[id]=region
 if not room_id264.is_empty():
  var saved:Variant=SaveData.interior_search264.get(room_id264,{})
  if saved is Dictionary:
   search264.restore_found(saved.get("sites",{}))
   var old_pending:Variant=saved.get("pending",[])
   if old_pending is Array:
    for value in old_pending:
     if value is String and not pending264.has(value) and search264.sites.has(value) and search264.sites[value].found:pending264.append(value)
 var hotspot:=Button.new();hotspot.name="SearchSite264_"+id;hotspot.flat=true;hotspot.focus_mode=Control.FOCUS_NONE;hotspot.mouse_default_cursor_shape=Control.CURSOR_POINTING_HAND;hotspot.position=region.position;hotspot.size=region.size
 for state in ["normal","hover","pressed","focus"]:hotspot.add_theme_stylebox_override(state,StyleBoxEmpty.new())
 canvas.add_child(hotspot);canvas.move_child(hotspot,mini(4,canvas.get_child_count()-1));search_buttons264[id]=hotspot
 hotspot.pressed.connect(func():search_site264(id))
 return true
func search_site264(id:String)->Dictionary:
 var before:Dictionary=search264.export_state()
 var result:=search264.tap(id)
 if message.text in [InteriorSearch264.EMPTY_HINT,InteriorSearch264.EXHAUSTED_HINT]:message.text=""
 if result.kind=="found":
  pending264.append(id)
  if not save_search264():
   search264.sites=before;pending264.erase(id);message.text="No se pudo guardar el hallazgo. Sigue aquí para intentarlo de nuevo.";return {"kind":"save_failed","message":message.text}
  message.text="Le mostraré esto a "+npc_name+"."
  collectible_found264.emit(id,result.item,result.ownership)
 elif not str(result.get("message","")).is_empty():message.text=result.message
 return result

func search_region_allowed264(region:Rect2)->bool:
 if region.size.x<=0 or region.size.y<=0 or not Rect2(120,78,1040,510).encloses(region):return false
 for reserved in reserved_ui264:
  if reserved.intersects(region):return false
 return true
func save_search264()->bool:
 if room_id264.is_empty():return true
 var before:=SaveData.interior_search264.duplicate(true)
 SaveData.interior_search264[room_id264]={"sites":search264.export_state(),"pending":pending264.duplicate()}
 if SaveData.save_progress():return true
 SaveData.interior_search264=before;return false
func show_exit_conversation264():
 exit_block264=Control.new();exit_block264.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(exit_block264);MenuInputGuard.install(exit_block264)
 exit_dialog264=NpcDialog.new()
 var names:PackedStringArray=[]
 for id in pending264:names.append(str(found_names264.get(id,"lo que has encontrado")))
 exit_dialog264.setup_story(npc_name.capitalize(),"Antes de irte",exit_response264(names))
 for child in exit_dialog264.get_children():
  if child is Sprite2D and not npc_path.is_empty():child.texture=load(npc_path);child.scale=Vector2.ONE*(180./child.texture.get_height())
  if child is Button:child.text="Entendido · salir al rancho"
 add_child(exit_dialog264)
 exit_dialog264.closed.connect(func():
  var before:=pending264.duplicate();pending264.clear()
  if not save_search264():
   pending264=before;message.text="No se pudo guardar la conversación. Puedes volver a intentarlo.";exit_dialog264.queue_free();exit_dialog264=null;exit_block264.queue_free();return
  exit_dialog264.queue_free();exit_dialog264=null;exit_block264.queue_free();close_room264())
func exit_response264(names:PackedStringArray)->String:
 return "Me enseñas "+", ".join(names)+". Gracias por mostrármelo. Son materiales del local; voy a guardarlos aquí. ¡Hasta pronto!"
