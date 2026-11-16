extends SceneTree
func _initialize():
 var stick:=VirtualJoystick.new()
 print('STICK_STYLES ',ThemeDB.get_default_theme().get_stylebox_list('VirtualJoystick'))
 for item in stick.get_property_list():
  if 'size' in str(item.name) or 'dead' in str(item.name):print('STICK_PROP ',item)
 stick.free();quit()
