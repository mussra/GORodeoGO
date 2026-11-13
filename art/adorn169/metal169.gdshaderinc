uniform sampler2D adorn_mask169: filter_nearest;
uniform int leg_metal169=0;
uniform int boot_metal169=0;
vec3 adorn_color169(vec3 source,vec2 uv,int metal){
 float light=clamp(max(source.r,max(source.g,source.b))/.82,.15,1.);
 float shine=pow(.5+.5*sin((uv.x+uv.y*.35)*70.-TIME*1.5),12.);
 vec3 low=metal==1?vec3(.43,.22,.035):vec3(.28,.34,.40);
 vec3 high=metal==1?vec3(1.,.79,.23):vec3(.88,.94,1.);
 vec3 color=mix(low,high,light*.75+.15);
 return mix(color,metal==1?vec3(1.,.97,.80):vec3(.97,.99,1.),shine*.55);
}
vec3 apply_adorn169(vec3 current,vec3 source,vec2 uv){
 vec2 areas=texture(adorn_mask169,uv).rg;
 if(leg_metal169>0)current=mix(current,adorn_color169(source,uv,leg_metal169),areas.r);
 if(boot_metal169>0)current=mix(current,adorn_color169(source,uv,boot_metal169),areas.g);
 return current;
}
