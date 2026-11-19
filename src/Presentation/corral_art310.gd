class_name CorralArt310
extends RefCounted
const VERTICAL312=preload("res://art/corral312/rail-vertical.png")
const RAIL=preload("res://art/corral310/rail-horizontal.png")
const GATE=preload("res://art/corral310/gate-closed.png")
const OPEN_LEFT=preload("res://art/corral310/gate-open-left.png")
const OPEN_RIGHT=preload("res://art/corral310/gate-open-right.png")
static func fit(node:CanvasItem,texture:Texture2D,box:Rect2):
 var extent:=texture.get_size();extent*=minf(box.size.x/extent.x,box.size.y/extent.y)
 node.draw_texture_rect(texture,Rect2(box.get_center()-extent*.5,extent),false)
static func horizontal(node:CanvasItem,a:float,b:float,y:float):
 if b<=a:return
 var count:=maxi(1,int(ceil((b-a)/90.)));var width:float=(b-a)/count
 for i in count:fit(node,RAIL,Rect2(a+i*width,y-28,width+1,35))
static func closed(node:CanvasItem,x:float,y:float):fit(node,GATE,Rect2(x-60,y-43,120,50))
static func opened(node:CanvasItem,x:float,y:float):
 fit(node,OPEN_LEFT,Rect2(x-88,y-40,30,47))
 fit(node,OPEN_RIGHT,Rect2(x+58,y-40,30,47))

# Ant's complete three-post upright fence. Only transparent margins are cropped.
# Uniform scale preserves the supplied perspective; no rotation or repainting.
# First and final post bases are at source y=270 and y=2160.
static func vertical(node:CanvasItem,x:float,a:float,b:float):
 if b<=a:return
 var scale:float=(b-a)/1890.
 node.draw_texture_rect(VERTICAL312,Rect2(x-77.5*scale,a-270.*scale,155.*scale,2164.*scale),false)
