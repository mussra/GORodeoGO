extends Node
func _ready():run.call_deferred()
func shot(path:String):
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.equipment_points=20000;SaveData.equipment_owned=[];SaveData.equipment_equipped={}
 var panel:=EquipmentPanel.new();add_child(panel)
 await shot("/downloads/juanito-panel-top.png")
 var scroll:ScrollContainer=panel._canvas.get_children().filter(func(c):return c is ScrollContainer)[0]
 scroll.scroll_vertical=680
 await shot("/downloads/juanito-panel-mid.png")
 scroll.scroll_vertical=1400
 await shot("/downloads/juanito-panel-bottom.png")
 panel._confirm_purchase("spurs_basic")
 await shot("/downloads/juanito-confirm.png")
 panel.free()
 for id in ["cosmetic_hat_deluxe","cosmetic_blanket_deluxe"]:
  SaveData.equipment_owned.append(id);SaveData.equipment_equipped[EquipmentCatalog.ITEMS[id].slot]=id
 var bg:=ColorRect.new();bg.color=Color("617e61");bg.size=Vector2(1280,720);add_child(bg)
 for j in 5:
  var player=load("res://src/Presentation/world_player.gd").new();add_child(player);player.position=Vector2(150+j*240,430);player.set_physics_process(false)
  player._sprite_swap.play("walk_"+["side","down","up","diag_down","diag_up"][j]);player._sprite_swap._sprite.pause()
 await shot("/downloads/juanito-cosmetics.png")
 var walk_sheet:Image=Image.create(96*5,96*9,false,Image.FORMAT_RGBA8)
 var jump_sheet:Image=Image.create(96*5,96*8,false,Image.FORMAT_RGBA8)
 var reference=load("res://src/Presentation/world_player.gd").new();add_child(reference);reference.set_physics_process(false)
 for j in 5:
  var suffix:String=["side","down","up","diag_down","diag_up"][j]
  for k in 9:
   var im:Image=reference._sprite_swap._frames.get_frame_texture("walk_"+suffix,k).get_image()
   if im.is_compressed():im.decompress()
   walk_sheet.blit_rect(im,Rect2i(0,0,96,96),Vector2i(j*96,k*96))
  for k in 8:
   var im:Image=reference._sprite_swap._frames.get_frame_texture("jump_"+suffix,k).get_image()
   if im.is_compressed():im.decompress()
   jump_sheet.blit_rect(im,Rect2i(0,0,96,96),Vector2i(j*96,k*96))
 walk_sheet.resize(960,1728,Image.INTERPOLATE_NEAREST);walk_sheet.save_png("/downloads/juanito-walk-sheet.png")
 jump_sheet.resize(960,1536,Image.INTERPOLATE_NEAREST);jump_sheet.save_png("/downloads/juanito-jump-sheet.png")
 for child in get_children():child.queue_free()
 await get_tree().process_frame
 get_tree().root.size=Vector2i(960,540)
 SaveData.save_path="user://qa-equipment-world243.cfg";SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=6
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.world_roaming139={};SaveData.world_herd_town217={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_garden212=Garden212.fresh();SaveData.world_discovered=[]
 SaveData.world_position=WorldNominal98.home()
 SaveData.equipment_owned.append("spurs_basic");SaveData.equipment_equipped["spurs"]="spurs_basic"
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(2.).timeout
 await shot("/downloads/juanito-world-hud.png")
 Input.action_press("move_right")
 for i in 3:await get_tree().physics_frame
 print("SPUR_QA ",world.player.try_activate_spurs()," ratio ",world.player.stamina_ratio243)
 await shot("/downloads/juanito-world-burst.png")
 Input.action_release("move_right")
 world._open_service231("east140")
 await shot("/downloads/juanito-service.png")
 world._npc_dialog.open_requested.emit()
 await shot("/downloads/juanito-960.png")
 world.free();get_tree().quit()
