class_name HorseGalaxyLook
extends RefCounted
## Presentation metadata comes from a specific horse, never from inferred traits.
static func state(horse:Dictionary)->Dictionary:
 if horse.is_empty() or horse.get("traits",{}).get("finish","")!="galaxy":return {}
 return {"percent":HorseMastery.percent(horse),"master":HorseMastery.galaxy_master(horse)}
static func hash2(p:Vector2)->float:return fposmod(sin(p.dot(Vector2(127.1,311.7)))*43758.5453,1.)
static func noise(p:Vector2)->float:
 var i=p.floor();var f=p-i;f=f*f*(Vector2(3,3)-2.*f)
 return lerpf(lerpf(hash2(i),hash2(i+Vector2.RIGHT),f.x),lerpf(hash2(i+Vector2.DOWN),hash2(i+Vector2.ONE),f.x),f.y)
static func cloud(p:Vector2)->float:
 var n=0.;var amp=.56
 for i in 4:
  n+=amp*noise(p);p=Vector2(.8*p.x-.6*p.y,.6*p.x+.8*p.y)*2.1+Vector2(13.2,7.1);amp*=.48
 return n
static func color_at(p:Vector2,look:Dictionary)->Color:
 var master=bool(look.get("master",false));var density=.04+.96*float(look.get("percent",0.))/100.
 var dark=Color("030b20") if master else Color("18031a");var light=Color("477ce7") if master else Color("ed4fa6")
 var cl=cloud(p*.105);var dust=cloud(p*.30+Vector2(8.1,4.2));var ribbon=exp(-pow((p.y-(.46*p.x+21.+sin(p.x*.12)*5.))/6.,2.))
 var wisps=smoothstep(.35,.77,cl)*(.30+.70*dust)
 var c=(dark*.4).lerp(light,.14+.55*wisps+.32*ribbon)
 c+=light.lerp(Color(.55,.76,1.),.18)*(ribbon*.28+smoothstep(.58,.78,dust)*ribbon*.44)
 c*=1.-smoothstep(.59,.79,cloud(p*.19+Vector2(29,29)))*.47
 var grid=p/4.3;var cell=grid.floor();var stars=0.
 for yy in range(-1,2):
  for xx in range(-1,2):
   var cc=cell+Vector2(xx,yy);var h=hash2(cc)
   if h>.38*density:continue
   var place=cc+Vector2(.18+.64*hash2(cc+Vector2(37,37)),.18+.64*hash2(cc+Vector2(93,93)))
   var d=(grid-place)*4.3;var r=d.length();var radius=lerpf(.10,.27,hash2(cc+Vector2(11,11)))
   var core=1.-smoothstep(radius*.3,radius+.10,r);var glow=exp(-r*r/(radius*radius*7.))*.30
   stars=maxf(stars,core+glow)
 c=c.lerp(Color(.98,.99,1.),clampf(stars,0.,1.))
 if not master:
  var lum=c.r*.2126+c.g*.7152+c.b*.0722
  c=Color(.36,.33,.43).lerp(Color(lum,lum,lum),.18).lerp(c,.30)
 c.a=1.;return c
static func configure_portrait(material:ShaderMaterial,horse:Dictionary)->void:
 var look=state(horse);var master=look.get("master",false)
 material.set_shader_parameter("galaxy_intensity",1. if master else .30)
 material.set_shader_parameter("galaxy_star_density",.04+.96*float(look.get("percent",0.))/100.)
 material.set_shader_parameter("mastery_aura",master);material.set_shader_parameter("mastery_aura_strength",1.8)
 material.set_shader_parameter("mastery_sun",master);material.set_shader_parameter("mastery_moon",master)
 material.set_shader_parameter("mastery_mark_scale",.7);material.set_shader_parameter("mastery_greek_preview",false)
 if master:
  material.set_shader_parameter("galaxy_dark",Color("030b20"));material.set_shader_parameter("galaxy_light",Color("477ce7"))
## UV anchors are explicit per view. Rear-facing views never show a chest sun.
static func marks(p:Vector2,view:String)->Vector2:
 var sun=Vector2(69,57);var moon=Vector2(29,57);var show_sun=true;var show_moon=true
 if view in ["down","walk_down"]:sun=Vector2(48,63);show_moon=false
 elif view in ["up","walk_up"]:show_sun=false;moon=Vector2(47,61)
 elif "diag_down" in view:sun=Vector2(59,62);moon=Vector2(33,54)
 elif "diag_up" in view:show_sun=false;moon=Vector2(39,61)
 elif view.begins_with("drink"):sun=Vector2(70,64);moon=Vector2(33,57)
 var q=(p-sun)/.7;var r=q.length();var angle=q.angle()
 var disc=1.-smoothstep(1.65,2.4,r)
 var rays=pow(maxf(0.,cos(angle*12.)),8.)*smoothstep(1.8,2.5,r)*(1.-smoothstep(2.6,4.,r))
 var a=clampf(disc+rays,0.,1.) if show_sun else 0.
 q=(p-moon)/.7
 var outer=1.-smoothstep(2.5,3.2,q.length());var cut=1.-smoothstep(2.3,2.9,(q-Vector2(1.5,-.9)).length())
 return Vector2(a,outer*(1.-cut) if show_moon else 0.)
static func finish(image:Image,mask:Image,uv:Image,view:String,bob:int,look:Dictionary)->void:
 if not look.get("master",false):return
 var silhouette=Image.create(image.get_width(),image.get_height(),false,Image.FORMAT_RF)
 for y in image.get_height():
  for x in image.get_width():
   var m=mask.get_pixel(x,y);var old=image.get_pixel(x,y)
   var horse=maxf(m.r,m.g)*old.a;silhouette.set_pixel(x,y,Color(horse,0,0,1))
   if m.r<.5 or old.a<.01:continue
   var point=HorseAppearance.body_point(uv,x,y,bob);var mark=marks(point,view)
   var ink=maxf(mark.x,mark.y)
   if ink>0:image.set_pixel(x,y,old.lerp(Color(.89,.97,1.,old.a),ink*.95))
 var src=image.duplicate()
 for y in image.get_height():
  for x in image.get_width():
   var old=src.get_pixel(x,y)
   if old.a>.02:continue
   var halo=0.
   for dy in range(-3,4):
    for dx in range(-3,4):
     if dx*dx+dy*dy>10:continue
     var xx=x+dx;var yy=y+dy
     if xx<0 or yy<0 or xx>=image.get_width() or yy>=image.get_height():continue
     halo=maxf(halo,silhouette.get_pixel(xx,yy).r*exp(-float(dx*dx+dy*dy)/4.)*.68)
   if halo>.015:image.set_pixel(x,y,Color(.24,.57,1.,halo))
