class_name FloristRoom262
extends BuildingRoom262
## Illustrated shared florist room. World supplies the existing conversation.
var use_existing_conversation:bool=false
var dialog:NpcDialog
var dialog_block:Control
func _ready():
 room_id264="home:florist";prototype=false;title="FLORISTERÍA";npc_name="la florista";npc_path="res://art/npc/florist.png"
 background_path="res://art/interiors262/florist-room.png"
 super._ready()
 add_object("display_flowers","Examinar las flores","inspect","Florista: Son mis muestras. Puedes mirarlas de cerca; no se recogen del mostrador.")
 add_object("ribbon","Interesarme por los lazos","ask","Florista: Los uso para preparar ramos. Si te interesa algo, habla conmigo.")
 add_object("catalogue","Examinar el catálogo","inspect","Florista: En este catálogo preparo mis ideas para los ramos. Si te interesa algo, habla conmigo.")
 objects.position=Vector2(36,520);objects.size=Vector2(1200,58);objects.vertical=false
 for button in objects.get_children():button.custom_minimum_size=Vector2(384,52);button.size_flags_vertical=Control.SIZE_SHRINK_BEGIN;button.add_theme_font_size_override("font_size",18)
 message.position=Vector2(40,592);message.size=Vector2(1200,50);message.add_theme_font_size_override("font_size",20)
 reserved_ui264.append(Rect2(36,520,1200,58))
 found_names264={"worktable":"un lazo de la mesa de trabajo"}
 add_search_site264("worktable",Rect2(572,220,90,80),"work_ribbon","owner")
 add_search_site264("left_floor",Rect2(510,410,130,80))
 add_search_site264("right_shelf",Rect2(810,132,75,60))
 if not use_existing_conversation:conversation_requested.connect(_talk)
func _talk():
 if is_instance_valid(dialog):return
 dialog_block=Control.new();dialog_block.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(dialog_block);MenuInputGuard.install(dialog_block)
 dialog=NpcDialog.new();dialog.setup_story("Florista","Bienvenido a mi floristería","Pasa y mira con calma. Las flores del mostrador son muestras de la tienda. Si te interesa algo, habla conmigo.\n\nMis encargos te esperan cuando quieras ayudarme.")
 for child in dialog.get_children():
  if child is Sprite2D:child.texture=load(npc_path);child.scale=Vector2.ONE*(180./child.texture.get_height())
 add_child(dialog)
 dialog.closed.connect(_close_talk)
func _close_talk():
 if is_instance_valid(dialog):dialog.queue_free()
 if is_instance_valid(dialog_block):dialog_block.queue_free()
 dialog=null;dialog_block=null
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel") and use_existing_conversation:
  for child in get_children():
   if child is Control and child.has_signal("closed"):
    child.emit_signal("closed");get_viewport().set_input_as_handled();return
 if event.is_action_pressed("ui_cancel") and is_instance_valid(dialog):_close_talk();get_viewport().set_input_as_handled();return
 super._unhandled_input(event)
