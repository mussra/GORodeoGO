class_name FloristRoom262
extends BuildingRoom262
## Standalone work-in-progress. Not connected to world doors until final art and
## the existing quest dialogue have been tested together.
var dialog:NpcDialog
var dialog_block:Control
func _ready():
 title="FLORISTERÍA · SEGUNDO INTERIOR EN PREPARACIÓN";npc_name="la florista";npc_path="res://art/npc/florist.png"
 background_path="res://art/interiors262/florist-room.png"
 super._ready()
 add_object("display_flowers","Examinar las flores de muestra","inspect","Florista: Son mis muestras. Puedes mirarlas de cerca; no se recogen del mostrador.")
 add_object("ribbon","Preguntar por los lazos del mostrador","ask","Florista: Los uso para preparar ramos. Si preparo un regalo para ti, te lo ofreceré expresamente.")
 add_object("catalogue","Consultar el catálogo (en preparación)","inspect","El catálogo y sus precios todavía no están implementados. Esta maqueta no cobra puntos ni entrega objetos.")
 conversation_requested.connect(_talk)
func _talk():
 if is_instance_valid(dialog):return
 dialog_block=Control.new();dialog_block.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(dialog_block);MenuInputGuard.install(dialog_block)
 dialog=NpcDialog.new();dialog.setup_story("Florista","Bienvenido a mi floristería","Pasa y mira con calma. Las flores del mostrador son muestras de la tienda. Para comprar algo o recibir un regalo, habla conmigo primero.\n\nEsta conversación es de prueba: los encargos existentes seguirán funcionando cuando conectemos la puerta del edificio.")
 for child in dialog.get_children():
  if child is Sprite2D:child.texture=load(npc_path);child.scale=Vector2.ONE*(180./child.texture.get_height())
 add_child(dialog)
 dialog.closed.connect(_close_talk)
func _close_talk():
 if is_instance_valid(dialog):dialog.queue_free()
 if is_instance_valid(dialog_block):dialog_block.queue_free()
 dialog=null;dialog_block=null
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel") and is_instance_valid(dialog):_close_talk();get_viewport().set_input_as_handled();return
 super._unhandled_input(event)
