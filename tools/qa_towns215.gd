extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 world._update_chunks()
 for child in world._toasts.get_children():
  if child is CanvasItem:child.visible=false
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/towns215-"+name_+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://towns215-qa.cfg";SaveData._load_valid=true;SaveData.world_garden212=Garden212.fresh()
 SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 var cover=get_tree().root.get_node_or_null("FrontierTransition")
 if cover!=null:cover.free()
 world.visible=true;world.set_process(false);world.player.set_physics_process(false)
 var port:Vector2=WorldTerrain103.ridge(752026,0).port
 world.player.position=port+Vector2(-190,65);get_viewport().get_camera_2d().reset_smoothing();await shot("porton")
 var point:=VillageCousins140.point(SaveData.world_cousins140,"home")
 world.player.position=point;get_viewport().get_camera_2d().reset_smoothing();world._open_cousin140("home");world._npc_dialog._hint215();await shot("npc")
 get_tree().root.size=Vector2i(960,540);await shot("npc-960")
 get_tree().root.size=Vector2i(1280,720)
 world._close_npc();world._toggle_map();await shot("mapa")
 world._map_overlay._show_town215(SaveData.world_cousins140.hint215);await shot("detalle")
 GameState.close_top_overlay(world);await get_tree().process_frame
 world._toggle_map()
 var gallery:=Control.new();gallery.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);world._hud.add_child(gallery)
 var background:=ColorRect.new();background.color=Color("18302c");background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);gallery.add_child(background)
 for i in 4:
  var id:String=VillageCousins140.IDS[i];var x:float=80+(i%2)*620;var y:float=75+(i/2)*300
  var label:=Label.new();label.text=TownIdentity215.title(SaveData.world_cousins140,id);label.position=Vector2(x,y);label.add_theme_font_size_override("font_size",24);gallery.add_child(label)
  var icon:=TownIcon215.new();icon.look=TownIdentity215.look(SaveData.world_cousins140,id);icon.position=Vector2(x,y+48);icon.size=Vector2(200,144);gallery.add_child(icon)
  var small:=TownIcon215.new();small.look=icon.look;small.position=Vector2(x+260,y+80);small.size=Vector2(64,46);gallery.add_child(small)
  var caption:=Label.new();caption.text="Icono 64 px";caption.position=Vector2(x+250,y+135);gallery.add_child(caption)
 await shot("iconos")
 for map_ in [world._chunk_pending,world._chunk_built]:
  for key in map_:world._discard_builder(map_[key])
 world.free();DirAccess.remove_absolute(SaveData.save_path);get_tree().quit()
