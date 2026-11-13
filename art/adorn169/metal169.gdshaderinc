uniform sampler2D adorn_mask169: filter_nearest;
uniform int leg_metal169=0;
uniform int boot_metal169=0;
float adorn_region169(vec2 uv,int slot){return slot==0?texture(adorn_mask169,uv).r:texture(adorn_mask169,uv).g;}
vec3 adorn_color169(vec3 source,vec2 uv,int metal,int slot){
 vec2 pixel=1./vec2(textureSize(adorn_mask169,0));
 float stride=max(1.,float(textureSize(adorn_mask169,0).x)/160.);
 float left=0.;float right=0.;bool l=true;bool r=true;
 for(int i=1;i<=18;i++){
  float distance_=float(i)*pixel.x*stride;
  l=l && adorn_region169(uv-vec2(distance_,0.),slot)>.25;
  r=r && adorn_region169(uv+vec2(distance_,0.),slot)>.25;
  if(l)left+=1.;if(r)right+=1.;
 }
 float cross_section=(left+.5)/max(1.,left+right+1.);
 float volume=pow(max(0.,sin(cross_section*3.14159)),.65);
 float light=clamp(dot(source,vec3(.28,.56,.16))/.78,.12,1.1);
 float specular=exp(-pow((cross_section-.34)/.16,2.));
 vec3 shadow=metal==1?vec3(.32,.19,.055):vec3(.22,.27,.31);
 vec3 mid=metal==1?vec3(.77,.53,.17):vec3(.59,.66,.70);
 vec3 highlight=metal==1?vec3(1.,.87,.52):vec3(.94,.97,.99);
 vec3 color=mix(shadow,mid,volume*.82+.10)*(.53+.47*light);
 color=mix(color,highlight,specular*(.16+.32*light));
 return color;
}
vec3 apply_adorn169(vec3 current,vec3 source,vec2 uv){
 vec2 pixel=1./vec2(textureSize(adorn_mask169,0));
 vec2 areas=texture(adorn_mask169,uv).rg;
 vec2 around=(texture(adorn_mask169,uv+vec2(pixel.x,0.)).rg+texture(adorn_mask169,uv-vec2(pixel.x,0.)).rg+texture(adorn_mask169,uv+vec2(0.,pixel.y)).rg+texture(adorn_mask169,uv-vec2(0.,pixel.y)).rg)*.25;
 areas*=mix(vec2(.58),vec2(1.),around);
 if(leg_metal169>0 && areas.r>.001)current=mix(current,adorn_color169(source,uv,leg_metal169,0),areas.r);
 if(boot_metal169>0 && areas.g>.001)current=mix(current,adorn_color169(source,uv,boot_metal169,1),areas.g);
 return current;
}
