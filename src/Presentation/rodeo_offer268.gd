class_name RodeoOffer268
extends NpcDialog
func _ready():
 setup_story("Granjero","Mis toros se han escapado","Eh, se te da bien el lazo. ¿Puedes ayudarme con unos toros?\n\nPor favor, ve al menú principal y, en Juegos > Rodeo de toros, podrás recuperar mis toros escapados.\n\nEl Rodeo ya está habilitado por haber completado el encargo de los tres cerdos. No necesitas aceptar otra misión.")
 name="RodeoOffer268"
 for child in get_children():
  if child is Button:child.text="Entendido"
 super._ready()
