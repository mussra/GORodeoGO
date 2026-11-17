extends CanvasLayer
## On-device measurements only, refreshed twice/second. No remote telemetry.
var label:Label
var clock:float=0.
var frame_sum:float=0.
var frame_max:float=0.
var frame_count:int=0
var physics_steps246:int=0
var physics_sum246:float=0.
var idle_sum246:float=0.
var wall246:int=0
var _cpu_last_ns242:int=0
var _cpu_last_wall242:int=0
func _ready():
 layer=250;process_mode=Node.PROCESS_MODE_ALWAYS
 label=Label.new();label.mouse_filter=Control.MOUSE_FILTER_IGNORE
 label.add_theme_font_size_override('font_size',17)
 label.add_theme_color_override('font_color',Color('e0fff1'))
 var box:=StyleBoxFlat.new();box.bg_color=Color(.025,.07,.08,.88)
 box.content_margin_left=9;box.content_margin_right=9;box.content_margin_top=5;box.content_margin_bottom=5
 label.add_theme_stylebox_override('normal',box);add_child(label);label.hide()
func _physics_process(_delta:float):
 if GameState.performance_osd245 or SaveData.debug_mode:
  physics_steps246+=1;physics_sum246+=Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)*1000.
func _process(delta:float):
 var enabled:bool=GameState.trial_tools_enabled() and (SaveData.debug_mode or GameState.performance_osd245)
 label.visible=enabled and not get_tree().paused
 if not enabled:clock=0.;frame_sum=0.;frame_count=0;frame_max=0.;physics_steps246=0;physics_sum246=0.;idle_sum246=0.;wall246=0;return
 var now_:int=Time.get_ticks_usec()
 var actual_:float=(now_-wall246)/1000000. if wall246>0 else delta
 wall246=now_
 idle_sum246+=Performance.get_monitor(Performance.TIME_PROCESS)*1000.
 frame_sum+=actual_;frame_count+=1;frame_max=maxf(frame_max,actual_);clock+=actual_
 if clock<.5:return
 var mean:float=frame_sum/maxi(1,frame_count)
 var sv:Dictionary=SaveData.save_metrics242
 var video:float=Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED)/1048576.
 var cpu:float=Performance.get_monitor(Performance.TIME_PROCESS)*1000.
 var physics:float=physics_sum246/maxi(1,physics_steps246)
 var process_cpu:String=_process_cpu242()
 var io:String=_process_io242()
 label.text='RENDIMIENTO · %.0f FPS | frame %.1f ms · pico %.1f ms\nMotor muestra %.1f ms | física %.1f ms/paso | CPU %s\nRAM motor %.1f MiB | vídeo %.1f MiB | GPU %%: N/D\nDibujo %d calls | nodos %d | objetos %d\nGuardados %d · fallo %d | último %.1f ms · máx %.1f ms\nÚltimo archivo %.1f KiB | E/S proceso %s'%[
  1./maxf(mean,.00001),mean*1000.,frame_max*1000.,cpu,physics,process_cpu,
  Performance.get_monitor(Performance.MEMORY_STATIC)/1048576.,video,
  int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),int(Performance.get_monitor(Performance.OBJECT_COUNT)),
  sv.calls,sv.failures,sv.last_usec/1000.,sv.max_usec/1000.,sv.last_bytes/1024.,io]
 var world:Node=_find_world242(get_tree().current_scene)
 label.text+='\nFísica %.1f pasos/frame · %.1f ms muestreados/frame'%[float(physics_steps246)/maxi(1,frame_count),physics_sum246/maxi(1,frame_count)]
 if world!=null:
  label.text+='\nFrontera: %d chunks · %d cola | mapa %d rebuilds | flores mapa 0'%[world._chunks.size(),world._build_queue.size(),world._map_overlay.terrain_rebuilds]
 if world!=null and world.get('_camera_controls243')!=null:
  label.text+='\nCámara %.0f%% · LOD flores decorativas %s'%[world._camera_controls243.factor*100.,'normal' if world._camera_controls243.factor>=.99 else 'resumido']
 if world!=null and world.get('_arrival244')!=null and world._arrival244.active:
  label.text+='\nLlegada %.0f%% · %.2f / 3.40 s · LOD %s'%[world._arrival244.camera.zoom.x*100.,world._arrival244.elapsed,'resumido' if world._arrival244.lod_applied else 'normal']
 if world!=null and world.get('perf246')!=null:
  var p_:Dictionary=world.perf246
  label.text+='\nMundo: CPU %.1f + física %.1f ms/frame'%[p_.idle_us/1000./maxi(1,p_.idle_count),p_.physics_us/1000./maxi(1,p_.idle_count)]
  p_.idle_us=0;p_.physics_us=0;p_.idle_count=0;p_.physics_count=0
 label.text+='\nCaché caballos %d tipos · texturas %d · pintura %d'%[load('res://src/Presentation/wild_horse_art.gd').frame_cache.size(),PixelLabTrial.texture_cache.size(),TownPaint215.textures.size()]
 label.text+='\nCPU/GPU del sistema: N/D · contadores del motor, no %% de uso GPU'
 var viewport:Vector2=get_viewport().get_visible_rect().size
 var k:float=clampf(minf(viewport.x/1280.,viewport.y/720.),.65,1.4)
 label.scale=Vector2.ONE*k
 # Below the minimap, left of the rider and clear of top menu/touch buttons.
 label.position=Vector2(14,maxf(205.*k,viewport.y*.31))
 clock=0.;frame_sum=0.;frame_count=0;frame_max=0.;physics_steps246=0;physics_sum246=0.;idle_sum246=0.
func _find_world242(node:Node)->Node:
 if not is_instance_valid(node):return null
 if node.has_method('_update_chunks') and node.get('_map_overlay')!=null:return node
 for child in node.get_children():
  var found:=_find_world242(child)
  if found!=null:return found
 return null
# Linux/Android procfs may be denied. Never imply an unsupported counter is zero.
func _process_cpu242()->String:
 var f:=FileAccess.open('/proc/self/schedstat',FileAccess.READ)
 if f==null:return 'N/D'
 var fields:=f.get_line().strip_edges().split(' ',false)
 if fields.is_empty() or not fields[0].is_valid_int():return 'N/D'
 var ns:int=int(fields[0]);var wall:int=Time.get_ticks_usec()
 var result:String='midiendo'
 if _cpu_last_wall242>0 and wall>_cpu_last_wall242:
  result='%.0f%% hilo principal / 1 núcleo'%(100.*float(ns-_cpu_last_ns242)/(float(wall-_cpu_last_wall242)*1000.))
 _cpu_last_ns242=ns;_cpu_last_wall242=wall
 return result
func _process_io242()->String:
 var f:=FileAccess.open('/proc/self/io',FileAccess.READ)
 if f==null:return 'N/D'
 var values:Dictionary={}
 while not f.eof_reached():
  var pair:=f.get_line().split(':')
  if pair.size()==2:values[pair[0]]=int(pair[1].strip_edges())
 if not values.has('write_bytes'):return 'N/D'
 return 'R %.1f / W %.1f MiB'%[float(values.get('read_bytes',0))/1048576.,float(values.write_bytes)/1048576.]
