class_name SaveSlots334
extends RefCounted
var root:String='user://partidas334'
var state:Dictionary={}
var error:String=''
func setup(normal:String,debug:String)->bool:
 if not DirAccess.dir_exists_absolute(root) and DirAccess.make_dir_absolute(root)!=OK:error='No se pudo abrir la carpeta de partidas.';return false
 var dir=DirAccess.open(root);var revisions:Array=[]
 for file in dir.get_files():
  if file.begins_with('catalog-') and file.ends_with('.cfg'):revisions.append(file)
 revisions.sort();revisions.reverse()
 if not revisions.is_empty():
  var cfg=ConfigFile.new()
  if cfg.load(root+'/'+revisions[0])!=OK or not valid(cfg.get_value('slots','state',{})):error='El catálogo de partidas está protegido. No se reemplaza.';return false
  state=cfg.get_value('slots','state');return true
 var rows:Array=[]
 for pair in [[normal,false,'Partida actual'],[debug,true,'DEBUG actual']]:
  if FileAccess.file_exists(pair[0]) and backup(pair[0]).is_empty():return false
  rows.append({'id':'legacy-debug' if pair[1] else 'legacy-normal','path':pair[0],'debug':pair[1],'name':pair[2],'thumbnail':'','saved_at':0})
 state={'version':1,'sequence':0,'active_normal':'legacy-normal','active_debug':'legacy-debug','rows':rows}
 return commit()
func valid(raw:Variant)->bool:
 if not raw is Dictionary or raw.get('version')!=1 or not raw.get('sequence') is int or not raw.get('rows') is Array:return false
 var ids=[];var paths=[]
 for row in raw.rows:
  if not row is Dictionary:return false
  for key in ['id','path','name','thumbnail']:
   if not row.get(key) is String:return false
  if row.id.is_empty() or row.name.strip_edges().is_empty() or row.id in ids or row.path in paths or not row.get('debug') is bool or not row.get('saved_at') is int:return false
  if not row.path.begins_with('user://') or '..' in row.path:return false
  ids.append(row.id);paths.append(row.path)
 for mode in ['active_normal','active_debug']:
  if not raw.get(mode) is String or not raw.rows.any(func(row):return row.id==raw[mode] and row.debug==(mode=='active_debug')):return false
 return true
func commit()->bool:
 var next=state.duplicate(true);next.sequence+=1
 if not valid(next):error='Catálogo de partidas no válido.';return false
 var path=root+'/catalog-%012d.cfg'%next.sequence
 if FileAccess.file_exists(path):error='La revisión del catálogo ya existe. No se sobrescribe.';return false
 var cfg=ConfigFile.new();cfg.set_value('slots','state',next)
 if cfg.save(path+'.pending')!=OK:error='No se pudo guardar el catálogo.';return false
 var verify=ConfigFile.new()
 if verify.load(path+'.pending')!=OK or verify.get_value('slots','state')!=next:error='No se pudo verificar el catálogo.';return false
 if FileAccess.file_exists(path) or DirAccess.rename_absolute(path+'.pending',path)!=OK:error='No se pudo confirmar el catálogo.';return false
 state=next;return true
func backup(path:String)->String:
 var folder=root+'/original-'+str(Time.get_ticks_usec())+'-'+str(randi())
 if DirAccess.make_dir_absolute(folder)!=OK:error='No se pudo reservar la copia original.';return ''
 var bytes=FileAccess.get_file_as_bytes(path);var hash_=FileAccess.get_sha256(path)
 var f=FileAccess.open(folder+'/original.cfg',FileAccess.WRITE)
 if f==null:error='No se pudo escribir la copia original.';return ''
 f.store_buffer(bytes);f.flush();var err=f.get_error();f.close()
 if err!=OK or FileAccess.get_file_as_bytes(folder+'/original.cfg')!=bytes or FileAccess.get_sha256(folder+'/original.cfg')!=hash_:error='La copia original no coincide.';return ''
 return folder+'/original.cfg'
func row(id:String)->Dictionary:
 for item in state.get('rows',[]):
  if item.id==id:return item
 return {}
func active(debug:bool)->Dictionary:return row(state.get('active_debug' if debug else 'active_normal',''))
func attach(save:Node)->void:
 save.normal_mode_path=active(false).path;save.debug_mode_path=active(true).path
 save.save_path=save.debug_mode_path if save.debug_mode else save.normal_mode_path
func rename(id:String,name_:String)->bool:
 name_=name_.strip_edges().left(48)
 if name_.is_empty() or row(id).is_empty():error='Escribe un nombre para la partida.';return false
 var before=state.duplicate(true);row(id).name=name_
 if commit():return true
 state=before;return false
func save_current(save:Node)->bool:
 if save.trial_session_active:error='Sal de Práctica/Demos antes de guardar.';return false
 if active(save.debug_mode).get('path','')!=save.save_path:error='La partida activa no coincide con el catálogo.';return false
 if not save.save_progress():error=save.save_error330;return false
 var before=state.duplicate(true);active(save.debug_mode).saved_at=int(Time.get_unix_time_from_system())
 if commit():return true
 state=before;return false
func select(id:String,save:Node)->bool:
 var target=row(id)
 if target.is_empty() or target.debug!=save.debug_mode:error='Elige una partida del modo actual.';return false
 if target.path==save.save_path:return true
 if not FileAccess.file_exists(target.path):error='No se encuentra el archivo de esa partida. No se ha cambiado de partida.';return false
 if not save_current(save):return false
 var verify=save.get_script().new();verify.auto_recovery333=false;verify.save_path=target.path;verify.load_progress()
 var ok=verify._load_valid and not verify.cosmetic_protected332;verify.free()
 if not ok:error='La partida elegida está protegida. No se ha cambiado de partida.';return false
 var before=state.duplicate(true);state['active_debug' if save.debug_mode else 'active_normal']=id
 if not commit():state=before;return false
 attach(save);save.recovery_details333=[];save.recovery_backup333='';save.load_progress();return true
func create(name_:String,save:Node)->bool:
 name_=name_.strip_edges().left(48)
 if name_.is_empty():error='Escribe un nombre para la partida.';return false
 if not save_current(save):return false
 var id='slot-'+str(Time.get_ticks_usec())+'-'+str(randi());var path=root+'/'+id+'.cfg'
 if FileAccess.file_exists(path):error='Identificador de partida ya usado.';return false
 var fresh=save.get_script().new();fresh.save_path=path;fresh.load_progress();fresh.debug_mode=save.debug_mode;fresh.points_legacy_credit_applied=true
 if fresh.debug_mode:fresh.horse_collection.add_trial_parents()
 var ok=fresh.save_progress();fresh.load_progress();ok=ok and fresh._load_valid;fresh.free()
 if not ok:error='No se pudo crear y verificar la partida nueva.';return false
 var before=state.duplicate(true);state.rows.append({'id':id,'path':path,'name':name_,'debug':save.debug_mode,'thumbnail':'','saved_at':int(Time.get_unix_time_from_system())});state['active_debug' if save.debug_mode else 'active_normal']=id
 if not commit():state=before;return false
 attach(save);save.recovery_details333=[];save.recovery_backup333='';save.load_progress();return true
func thumbnail(image:Image,save:Node)->bool:
 if state.is_empty() or save.trial_session_active or active(save.debug_mode).get('path','')!=save.save_path:return false
 var copy=image.duplicate();copy.resize(480,270,Image.INTERPOLATE_LANCZOS)
 var path=root+'/view-'+str(Time.get_ticks_usec())+'-'+str(randi())+'.png'
 if FileAccess.file_exists(path) or copy.save_png(path)!=OK:error='No se pudo guardar la miniatura.';return false
 var before=state.duplicate(true);active(save.debug_mode).thumbnail=path
 if commit():return true
 state=before;return false
