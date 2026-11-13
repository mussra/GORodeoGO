class_name Campaign173
extends RefCounted
## Explicit second campaign: ten bulls, varied release dependencies, not count inflation.
const ROWS:Array=[
 [240,[4,6],[[1],[]],false],
 [260,[5,5],[[],[0]],true],
 [280,[3,3,4],[[1],[],[]],false],
 [300,[4,3,3],[[],[2],[]],true],
 [300,[2,4,4],[[1,2],[],[]],false],
 [320,[3,4,3],[[],[2],[0]],true],
 [340,[5,5],[[1],[0]],false],
 [360,[4,3,3],[[1],[2],[]],true],
 [360,[3,3,4],[[2],[],[1]],false],
 [380,[2,3,5],[[2],[],[]],true],
 [380,[4,6],[[],[0]],false],
 [400,[3,4,3],[[1,2],[],[]],true],
 [410,[4,3,3],[[2],[0],[]],false],
 [420,[3,3,4],[[],[0,2],[]],true],
 [430,[2,4,4],[[],[2],[0]],false],
 [440,[3,4,3],[[1],[2],[0]],true],
 [450,[5,5],[[1],[0]],true],
 [460,[4,3,3],[[2],[0],[1]],false],
 [470,[3,3,4],[[1,2],[],[]],false],
 [480,[2,3,5],[[1,2],[2],[0]],true]
]
static func apply(data:LevelData)->void:
 var spec:Array=ROWS[data.level_number-21];data.bull_count=10;data.time_limit_seconds=float(spec[0]);data.obstacle_rects=[];data.pens=[]
 if data.level_number in [23,26,29,32,35,38]:data.obstacle_rects=[Rect2(-60,-160,120,32)]
 if data.level_number in [24,28,33,37,40]:data.obstacle_rects=[Rect2(-60,105,120,32)]
 var next:int=0
 for i in spec[1].size():
  var bulls:Array=[]
  for j in int(spec[1][i]):bulls.append(next);next+=1
  data.pens.append({"bull_indices":bulls,"door_hold_seconds":1.2,"opens_pen_indices":spec[2][i].duplicate(),"layout_mirror_x":bool(spec[3])})
