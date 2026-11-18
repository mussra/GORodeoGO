extends SceneTree
func _initialize():run.call_deferred()
func run():
 var checks=["res://art/ui/ant_icons187/05.png","res://art/ui/skills/stamina.png","res://art/world/modular87/grass-1.png","res://art/npc/loco-normal140.png","res://art/portraits/adult_hd.png","res://audio/music/menu.wav","res://src/Presentation/main_menu.tscn"]
 var failed:=false
 for path in checks:
  var resource=load(path)
  print("RESOURCE309 ",path," ",resource!=null)
  if resource==null:failed=true
 for path in ["res://art/ui/ant_icons187/source.png","res://brand/zumbel_source.png"]:
  if ResourceLoader.exists(path):failed=true
 print("EXPORTED_SMOKE309 ","FAIL" if failed else "PASS")
 quit(1 if failed else 0)
