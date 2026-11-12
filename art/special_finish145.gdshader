shader_type canvas_item;
uniform int style=0;
uniform sampler2D region_mask: filter_nearest;
uniform sampler2D body_uv: filter_nearest;
uniform bool uv_enabled=false;
uniform bool portrait=false;
float hash21(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
vec3 finish_color(vec2 p,float shade){
 float sheen=pow(.5+.5*sin(p.x*.075+p.y*.028-TIME*.8),14.);
 if(style==1){
  vec3 metal=mix(vec3(.38,.16,.025),vec3(1.,.73,.15),clamp(shade*.84,0.,1.));
  metal=mix(metal,vec3(1.,.97,.68),sheen*.9);
  float glint=pow(max(0.,sin(p.x*.31+p.y*.19+TIME*1.1)),90.);
  return metal+vec3(1.,.9,.5)*glint*.20;
 }
 vec2 cell=floor(p/9.);float facet=hash21(cell);
 float stripe=fract((p.x+p.y*.58)/13.);
 float edge=(1.-smoothstep(.025,.10,stripe))+smoothstep(.92,.99,stripe);
 if(style==2){
  vec3 glass=mix(vec3(.35,.82,.91),vec3(.75,.58,.92),facet);
  glass=mix(glass,vec3(.85,1.,1.),step(.78,facet)*.5);
  return glass*(.40+.48*shade)+vec3(.8,.98,1.)*(edge*.30+sheen*.34);
 }
 float frost=hash21(floor(p*1.7));
 vec3 ice=mix(vec3(.22,.62,.80),vec3(.82,.96,1.),clamp(shade*.85,0.,1.));
 float crack=pow(1.-abs(sin(p.x*.10+sin(p.y*.07)*2.)),22.);
 return mix(ice,vec3(.95,1.,1.),clamp(crack*.7+frost*.17+sheen*.18,0.,1.));
}
void fragment(){
 vec4 src=texture(TEXTURE,UV);vec3 mask=texture(region_mask,UV).rgb;
 float region=clamp(max(mask.r,mask.g),0.,1.);
 vec2 p=UV*96.;
 if(uv_enabled){vec2 anchor=texture(body_uv,UV).rg;p=anchor*96.;}
 if(portrait)p=(UV*vec2(800.,840.)+vec2(240.,0.))*.12;
 if(style==0 || region<.01){COLOR=src;}
 else{
  float shade=clamp(max(src.r,max(src.g,src.b))/.83,.16,1.18);
  vec3 col=mix(src.rgb,finish_color(p,shade),region);
  float alpha=src.a*(style==2?mix(1.,.70,region):1.);
  COLOR=vec4(col,alpha);
 }
}
