class_name MapNotesController159
extends Node
## One note editor/photo/rollback workflow for every world. World adapters own
## only scoped note storage and nearby-animal data, never a second dialog flow.
var world:Node2D
const PHOTO_RADIUS161:float=120.
var photo_position:Vector2=Vector2(INF,INF)
var photo:Image
var wrapper:Control
var notes_list162:MapNotesList162
func _ready():world=get_parent()
func capture()->void:
 photo_position=world.player.position
 if DisplayServer.get_name()!="headless":photo=get_viewport().get_texture().get_image()
func photo_dir()->String:return "user://map-photos/"+str(hash(SaveData.save_path))
func open(pos:Vector2)->void:
 if is_instance_valid(world._note_dialog106):return
 var map:WorldDiscoveryMap159=world._map_overlay
 var nearest:Dictionary=WorldNotes106.nearest(map.notes159(),pos,20.*map.cell_size159()/maxf(.01,map._map_geometry.cell))
 var horse_id:String="";var horse_text:String="";var horse_pos:Vector2=pos;var near_distance:float=350.
 for horse in world.map_note_horses159():
  if not is_instance_valid(horse) or horse.is_queued_for_deletion():continue
  var d:float=horse.position.distance_to(pos)
  if d<near_distance:
   near_distance=d;horse_id=str(horse.herd.get("member_id",""));horse_pos=horse.position
   var traits:Dictionary=horse.herd.get("traits",{})
   horse_text="Caballo "+HorseCollection.COATS[int(traits.get("coat",0))].to_lower()+" · crin "+HorseCollection.MANES[int(traits.get("mane",0))].to_lower()
 var note:Dictionary=nearest.duplicate(true)
 if note.is_empty():note={"id":"note_%d_%d"%[Time.get_unix_time_from_system(),Time.get_ticks_usec()],"pos":horse_pos,"text":horse_text,"icon":"horse" if not horse_id.is_empty() else "pin","horse":horse_id,"photo":"","created_at":int(Time.get_unix_time_from_system())}
 map._dragging=false;world.player.velocity=Vector2.ZERO;world.player.set_physics_process(false)
 wrapper=Control.new();wrapper.size=Vector2(1280,720);wrapper.z_index=160;world.map_note_host159().add_child(wrapper)
 var layout:Callable=func():
  if not is_instance_valid(wrapper):return
  var viewport:Vector2=get_viewport().get_visible_rect().size;var k:float=minf(viewport.x/1280.,viewport.y/720.);wrapper.scale=Vector2.ONE*k;wrapper.position=(viewport-Vector2(1280,720)*k)/2.
 var viewport_node:Viewport=get_viewport()
 viewport_node.size_changed.connect(layout)
 wrapper.tree_exiting.connect(func():
  if is_instance_valid(viewport_node) and viewport_node.size_changed.is_connected(layout):viewport_node.size_changed.disconnect(layout))
 layout.call()
 var dialog:=MapNoteDialog106.new();dialog.setup(nearest,horse_text,photo,photo_location_allowed161(note.pos));world._note_dialog106=dialog;wrapper.add_child(dialog)
 dialog.closed.connect(close)
 dialog.saved.connect(func(text:String,wants_photo:bool):
  note.text=text.left(240);var new_path:String=""
  if wants_photo and not photo_location_allowed161(note.pos):
   dialog.photo_allowed=false;dialog.photo_box.set_pressed_no_signal(false);dialog.refresh_photo160();world.map_note_message159("Acércate al marcador y vuelve a abrir el mapa para guardar su captura. La foto anterior se conserva.");return
  if wants_photo and photo==null:
   world.map_note_message159("No hay captura disponible. Cierra el mapa y vuelve a abrirlo.");return
  if wants_photo and photo!=null:
   var directory:=photo_dir();DirAccess.make_dir_recursive_absolute(directory);new_path=directory+"/"+note.id+"_"+str(Time.get_ticks_usec())+".png"
   if photo.save_png(new_path)!=OK:world.map_note_message159("No se pudo guardar la foto");return
   note.photo=new_path
  if not world.map_note_store159(note):
   if not new_path.is_empty():DirAccess.remove_absolute(new_path)
   note.photo=str(nearest.get("photo",""))
   world.map_note_message159(tr("WORLD_SAVE_FAILED104"));return
  var previous_photo:String=str(nearest.get("photo",""))
  if not new_path.is_empty() and previous_photo.begins_with(photo_dir()+"/"):DirAccess.remove_absolute(previous_photo)
  world.map_note_message159("Nota guardada · mantén pulsado sobre ella para editar o eliminar");close())
 dialog.deleted.connect(func():
  if not world.map_note_delete159(str(note.id)):world.map_note_message159(tr("WORLD_SAVE_FAILED104"));return
  var path:String=str(note.get("photo",""))
  if path.begins_with(photo_dir()+"/"):DirAccess.remove_absolute(path)
  close())
func close()->void:
 if is_instance_valid(wrapper):wrapper.queue_free()
 wrapper=null;world._note_dialog106=null;world.player.set_physics_process(not world._map_overlay.expanded)

func photo_location_allowed161(pos:Vector2)->bool:
 return photo_position.is_finite() and photo_position.distance_to(pos)<=PHOTO_RADIUS161 and world.player.position.distance_to(pos)<=PHOTO_RADIUS161

func show_list162()->void:
 if is_instance_valid(notes_list162) or is_instance_valid(world._note_dialog106):return
 notes_list162=MapNotesList162.new();notes_list162.notes=world._map_overlay.notes159();world.map_note_host159().add_child(notes_list162)
 notes_list162.closed.connect(close_list162)
 notes_list162.selected.connect(func(note:Dictionary):close_list162();world._map_overlay.center_note162(note))
func close_list162()->void:
 if is_instance_valid(notes_list162):notes_list162.queue_free()
 notes_list162=null
