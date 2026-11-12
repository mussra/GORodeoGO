shader_type canvas_item;
uniform sampler2D adorn_mask: filter_nearest;
uniform int metal=0;
uniform bool horse=true;
uniform bool boots=true;
void fragment(){
 vec4 source=texture(TEXTURE,UV);
 vec2 areas=texture(adorn_mask,UV).rg;
 float coverage=max(horse?areas.r:0.,boots?areas.g:0.);
 if(metal==0 || coverage<.01){COLOR=source;}
 else{
  float light=clamp(max(source.r,max(source.g,source.b))/.82,.15,1.);
  float shine=pow(.5+.5*sin((UV.x+UV.y*.35)*70.-TIME*1.5),12.);
  vec3 low=metal==1?vec3(.43,.22,.035):vec3(.28,.34,.40);
  vec3 high=metal==1?vec3(1.,.79,.23):vec3(.88,.94,1.);
  vec3 color=mix(low,high,light*.75+.15);
  color=mix(color,vec3(1.,.97,.80),shine*.55);
  COLOR=vec4(mix(source.rgb,color,coverage),source.a);
 }
}
