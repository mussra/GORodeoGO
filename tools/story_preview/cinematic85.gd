extends Node
const FPS=24
const FRAMES=580
var world
var actor:AnimatedSprite2D
func _ready():run.call_deferred()
func camera_ease(a:Vector2,b:Vector2,t:float)->Vector2:return a.lerp(b,smoothstep(0.,1.,clampf(t,0.,1.)))
func run():
 get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://cinematic85-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_edits=[];SaveData.world_position=Vector2(100,150);SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.8).timeout
 world.process_mode=Node.PROCESS_MODE_DISABLED;world._hud.visible=false;world._marker.visible=false
 actor=world.player._sprite_swap._sprite
 var local_offset=actor.position
 actor.reparent(world,false)
 world.player.visible=false
 world._prototype_goats.visible=false
 for child in world.get_children():
  if child.get_script() in [load("res://src/Presentation/wild_goat.gd"),load("res://src/Presentation/wild_pig.gd"),load("res://src/Presentation/wild_horse.gd")]:child.visible=false
 # Remove gameplay-only labels/cues from this staged movie, not the game.
 for child in world.get_children():
  if child is Label:child.visible=false
  if child is WorldNpc:
   for item in child.get_children():
    if item is Label:item.visible=false
 var camera=Camera2D.new();camera.position_smoothing_enabled=false;world.add_child(camera);camera.make_current()
 actor.stop()
 DirAccess.make_dir_recursive_absolute("/downloads/cinematic85-frames")
 for n in FRAMES:
  var t=n/float(FPS);var animation="walk_side";var u=0.;var left=false
  if t<5.4:
   u=t/5.4
   world.player.position=Vector2(-120,35).lerp(Vector2(100,35),u)
   camera.position=camera_ease(Vector2(-30,-10),Vector2(90,90),u)
   camera.zoom=Vector2.ONE*lerpf(1.05,1.4,u)
  elif t<12.1:
   u=(t-5.4)/6.7;animation="walk_down"
   var y=lerpf(300.,530.,u)
   world.player.position=Vector2(WorldMap.branch_x_at(752026,y),y)
   camera.position=camera_ease(Vector2(180,310),Vector2(480,400),u)
   camera.zoom=Vector2.ONE*lerpf(1.4,1.15,u)
  elif t<16.9:
   u=(t-12.1)/4.8
   world.player.position=Vector2(395,530).lerp(Vector2(680,530),u)
   camera.position=camera_ease(Vector2(500,400),Vector2(665,370),u)
   camera.zoom=Vector2.ONE*lerpf(1.3,1.85,u)
  else:
   u=(t-16.9)/7.2;left=true
   world.player.position=Vector2(105,80).lerp(Vector2(-30,80),minf(1.,u*1.4))
   camera.position=camera_ease(Vector2(180,15),Vector2(0,-5),u)
   camera.zoom=Vector2.ONE*lerpf(1.25,1.05,u)
   if u>.74:animation="idle"
  actor.position=world.player.position+local_offset
  actor.animation=animation;actor.flip_h=left
  actor.frame=int(t*9.)%actor.sprite_frames.get_frame_count(animation)
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/cinematic85-frames/%04d.png"%n)
  if n%100==0:print("CINEMATIC85 frame ",n)
 get_tree().quit()
