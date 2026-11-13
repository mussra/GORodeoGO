class_name JumpBadge
extends Button
var capable:bool=false
var skill:String="jump"
func _ready()->void:
 custom_minimum_size=Vector2(64,56);size_flags_vertical=Control.SIZE_SHRINK_CENTER;flat=true
 for state in ["normal","hover","pressed","focus","disabled"]:add_theme_stylebox_override(state,StyleBoxEmpty.new())
 pressed.connect(show_explanation)
 tooltip_text=tr("DODGE_CAPABLE" if capable else "DODGE_GROUNDED") if skill=="dodge" else (tr("JUMP_CAPABLE") if capable else tr("JUMP_GROUNDED"))
 queue_redraw()
func show_explanation()->void:
 var explanation:=AcceptDialog.new();explanation.title=tr("DODGE_BADGE_TITLE" if skill=="dodge" else "JUMP_BADGE_TITLE");explanation.dialog_text=(tr("DODGE_CAPABLE") if capable else tr("DODGE_GROUNDED")) if skill=="dodge" else (tr("JUMP_CAPABLE") if capable else tr("JUMP_GROUNDED"));explanation.dialog_text=explanation.title+"\n\n"+explanation.dialog_text;explanation.min_size=Vector2i(460,120);explanation.dialog_autowrap=true;add_child(explanation);RanchTheme.style_dialog(explanation,true);explanation.confirmed.connect(explanation.queue_free);explanation.canceled.connect(explanation.queue_free);explanation.popup_centered()
func _draw()->void:
 AntIcons187.draw_fit(self,(3 if capable else 4) if skill=="dodge" else (1 if capable else 2),Rect2(0,0,64,56))

func _has_point(point:Vector2)->bool:
 return Rect2(Vector2.ZERO,Vector2(64,56)).has_point(point)
