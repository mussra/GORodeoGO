class_name DodgeEdgeCue
extends Node2D
var player:Node
func _process(_delta:float)->void:queue_redraw()
func _draw()->void:
	if not is_instance_valid(player) or not player._drawing_dodge or player._draw_edge_elapsed<=0:return
	var view:Vector2=get_viewport_rect().size
	var at:Vector2=player._last_pointer.clamp(Vector2(22,86),view-Vector2(22,55))
	var color:=Color("80e8d4") if player._draw_edge_active else Color("e6c68b")
	draw_circle(at,18,Color(.03,.13,.18,.8))
	draw_arc(at,17,-PI/2,-PI/2+TAU*minf(player._draw_edge_elapsed/player.DRAW_EDGE_DWELL,1),24,color,3,true)
	var direction:Vector2=player._draw_heading
	draw_line(at-direction*6,at+direction*9,color,2,true)
	draw_line(at+direction*9,at+direction*3+direction.orthogonal()*5,color,2,true)
	draw_line(at+direction*9,at+direction*3-direction.orthogonal()*5,color,2,true)
	var text:String=tr("Prolongando") if player._draw_edge_active else tr("Mantén para prolongar")
	var x:float=clampf(at.x+25,12,view.x-165)
	var y:float=at.y+38 if at.y<130 else at.y-26
	draw_style_box(RanchTheme.box(Color(.03,.13,.18,.88),Color.TRANSPARENT,5),Rect2(x-5,y-17,160,24))
	draw_string(ThemeDB.fallback_font,Vector2(x,y),text,HORIZONTAL_ALIGNMENT_LEFT,-1,13,color)
