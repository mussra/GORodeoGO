extends Node
func _ready():run.call_deferred()
func run():
 var traits:Array=[{"coat":10,"mane":0,"pattern":0,"legs":0,"spots":1,"eyes":10,"finish":"normal"},{"coat":6,"mane":4,"pattern":2,"legs":3,"spots":1,"eyes":10,"finish":"normal"},{"coat":18,"mane":1,"pattern":0,"legs":1,"eyes":10,"finish":"normal"},{"coat":3,"mane":5,"pattern":11,"legs":5,"spots":1,"eyes":10,"finish":"normal"}]
 for i in traits.size():
  var tex=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,traits[i]);tex.get_image().save_png("/downloads/foalmask72-%d.png"%i)
 get_tree().quit()
