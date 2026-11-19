extends Node
func _ready():
 var entries:=HorseAtlas.filtered_entries({},[],false)
 var visible:=HorseAtlas.visible_groups261(entries)
 print('HORSE_COUNT319 raw=',entries.size(),' visible=',visible.size(),' families=',HorseCollection.COATS.size()*HorseCollection.PATTERNS.size()*HorseCollection.MANES.size())
 get_tree().quit()
