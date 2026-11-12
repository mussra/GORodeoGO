extends Control
var font:Font=ThemeDB.fallback_font
const GOLD=Color("f2d987")
const PALE=Color("eee9dc")
func text(value:String,p:Vector2,size_:int=22):draw_string(font,p,value,HORIZONTAL_ALIGNMENT_LEFT,-1,size_,PALE)
func star(center:Vector2,r:float,color:Color):
 var points=PackedVector2Array()
 for i in 10:points.append(center+Vector2.from_angle(-PI/2+i*PI/5)*(r if i%2==0 else r*.43))
 draw_colored_polygon(points,color)
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("10252d"))
 text("DEMO · RASGOS VISUALES",Vector2(35,60),31)
 text("Lavanda con estrellas",Vector2(35,125),29)
 text("Solo propuesta · el texto del juego no cambia",Vector2(35,674),23)
 var labels=["Pelaje","Patrón","Manchas","Crin / cola","Ojos","Patas bajas","Acabado","Emblema","Rareza"]
 for i in 9:
  var p=Vector2(475+(i%3)*250,160+int(i/3)*155)
  draw_style_box(MapAppearance.frame(),Rect2(p,Vector2(235,140)))
  text(labels[i],p+Vector2(15,30),23)
  var c=p+Vector2(50,82)
  match i:
   0:draw_circle(c,27,Color(HorseAppearance.COLORS[16]));draw_arc(c,27,0,TAU,40,PALE,2);text("Lavanda",p+Vector2(90,90),21)
   1:star(c,30,PALE);text("Estrellas",p+Vector2(90,90),21)
   2:
    draw_circle(c,30,Color(HorseAppearance.COLORS[16]));star(c+Vector2(-9,-8),12,PALE);star(c+Vector2(12,10),10,PALE);text("Blancas",p+Vector2(90,90),21)
   3:
    for n in 4:
     var points=PackedVector2Array()
     for y in 32:points.append(c+Vector2(-22+n*12+sin(y*.17)*6,y-16))
     draw_polyline(points,PALE,7,true)
    text("Blanca",p+Vector2(90,90),21)
   4:
    var pts=PackedVector2Array([c+Vector2(-32,0),c+Vector2(-16,-19),c+Vector2(0,-23),c+Vector2(16,-19),c+Vector2(32,0),c+Vector2(16,19),c+Vector2(0,23),c+Vector2(-16,19),c+Vector2(-32,0)])
    draw_polyline(pts,PALE,3,true);draw_circle(c,16,Color("80533a"));draw_circle(c,8,Color("10252d"));draw_circle(c+Vector2(-5,-6),4,Color.WHITE);text("Castaños",p+Vector2(90,90),21)
   5:
    draw_rect(Rect2(c+Vector2(-17,-28),Vector2(34,52)),Color(HorseAppearance.COLORS[16]));draw_rect(Rect2(c+Vector2(-23,12),Vector2(46,17)),Color("fff3d3"));text("Original",p+Vector2(90,90),21)
   6:draw_circle(c,27,Color(HorseAppearance.COLORS[16]));text("Normal",p+Vector2(90,90),21)
   7:
    var pts=PackedVector2Array([c+Vector2(-24,-27),c+Vector2(24,-27),c+Vector2(20,10),c+Vector2(0,30),c+Vector2(-20,10),c+Vector2(-24,-27)])
    draw_polyline(pts,PALE,3,true);draw_line(c+Vector2(-14,14),c+Vector2(14,-14),PALE,3);text("Ninguno",p+Vector2(90,90),21)
   8:
    for n in 3:draw_colored_polygon(PackedVector2Array([c+Vector2(-24+n*22,-12),c+Vector2(-14+n*22,0),c+Vector2(-24+n*22,12),c+Vector2(-34+n*22,0)]),GOLD)
    text("Raro",p+Vector2(110,90),21)
func _ready():
 get_tree().root.size=Vector2i(896,414);var canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 position=(get_viewport_rect().size-Vector2(1280,720))/2
 var view=TextureRect.new();HorsePortrait.apply_horse(view,{"traits":{"coat":16,"pattern":6,"mane":1},"stage":"adult"},"blue");view.position=Vector2(30,170);view.size=Vector2(415,415);add_child(view)
 queue_redraw();await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/rasgos119-demo.png");get_tree().quit()
