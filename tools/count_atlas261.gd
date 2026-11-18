extends Node
func _ready():run.call_deferred()
func run():
 for filters in [{},{"mane":5},{"coat":6},{"rarity":3}]:
  var t:=Time.get_ticks_usec();var entries:=HorseAtlas.filtered_entries(filters,[],false);var groups:=HorseAtlas.visible_groups261(entries)
  print("ATLAS261_COUNT ",filters," raw=",entries.size()," visible_keys=",groups.size()," ms=",(Time.get_ticks_usec()-t)/1000.)
 var panel:=HorsePanel.new();panel.page="atlas";panel.atlas_filters={"rarity":3};add_child(panel);await get_tree().process_frame
 for i in 3:
  var t:=Time.get_ticks_usec();var entries:=panel.atlas_entries();print("ATLAS261_CACHE ",i," groups=",entries.size()," ms=",(Time.get_ticks_usec()-t)/1000.)
 panel.free();get_tree().quit()
