shader_type canvas_item;
uniform bool emblem_enabled=false;
uniform sampler2D emblem_mask: filter_linear;
uniform sampler2D eye_mask: filter_linear;
uniform vec4 eye_color: source_color = vec4(.6,.3,.1,1);
uniform bool custom_eyes = false;
uniform int eye_style = 0;
uniform bool galaxy = false;
uniform sampler2D region_mask: filter_linear;
uniform vec4 coat_color: source_color = vec4(.6,.3,.1,1);
uniform vec4 mane_color: source_color = vec4(1,.95,.8,1);
uniform vec4 hat_color: source_color = vec4(.2,.3,.45,1);
uniform bool original_horse = true;
uniform bool original_hat = true;
uniform bool rainbow = false;
uniform int pattern = 0;
vec3 soft_rainbow(float t) {
 vec3 a=vec3(.925,.376,.424);vec3 b=vec3(.937,.722,.365);vec3 c=vec3(.910,.847,.455);vec3 d=vec3(.467,.784,.533);vec3 e=vec3(.416,.663,.855);vec3 f=vec3(.600,.502,.784);
 float u=clamp(t,0.,.999)*6.;float k=smoothstep(0.,1.,fract(u));
 if(u<1.)return mix(a,b,k);if(u<2.)return mix(b,c,k);if(u<3.)return mix(c,d,k);if(u<4.)return mix(d,e,k);if(u<5.)return mix(e,f,k);return mix(f,a,k);
}
uniform vec4 spot_data[128];
uniform int spot_count=0;
float natural_spots(vec2 p){
 float cover=0.;
 for(int i=0;i<128;i++){
  if(i>=spot_count)break;
  vec4 spot=spot_data[i];vec2 q=p-spot.xy;
  float cs=cos(spot.w),sn=sin(spot.w);q=mat2(vec2(cs,-sn),vec2(sn,cs))*q;
  vec2 edge=abs(q)-vec2(spot.z,spot.z*.85);
  float distance_to_edge=max(edge.x,edge.y);
  cover=max(cover,1.-smoothstep(-.1,.1,distance_to_edge));
 }
 return cover;
}
float shape_cover(vec2 q,int shape){
 if(shape==5){q.y=-q.y+.25;float a=dot(q,q)-1.;return 1.-smoothstep(-.04,.04,a*a*a-q.x*q.x*q.y*q.y*q.y);}
 if(shape==6){
  bool inside=false;vec2 last=vec2(cos(-1.570796+9.*.6283185),sin(-1.570796+9.*.6283185))*.48;
  for(int k=0;k<10;k++){float angle=-1.570796+float(k)*.6283185;vec2 v=vec2(cos(angle),sin(angle))*(k%2==0?1.2:.48);
   if((v.y>q.y)!=(last.y>q.y) && q.x<(last.x-v.x)*(q.y-v.y)/(last.y-v.y)+v.x)inside=!inside;last=v;}
  return inside?1.:0.;
 }
 if(shape==7)return (q.y>-.95 && q.y<.95 && abs(q.x)<(q.y+.95)*.58)?1.:0.;
 if(shape==8)return 1.-smoothstep(1.06,1.18,abs(q.x)*.8+abs(q.y));
 return 0.;
}
float genetic_pattern(vec2 p,int shape){
 if(shape==9){float wave=p.x*.95+sin(p.y*.16)*1.35+sin(p.y*.37+p.x*.055)*.55;return smoothstep(.57,.67,sin(wave));}
 float cover=0.;
 for(int i=0;i<128;i++){if(i>=spot_count)break;vec4 spot=spot_data[i];vec2 q=p-spot.xy;float cs=cos(spot.w),sn=sin(spot.w);q=mat2(vec2(cs,-sn),vec2(sn,cs))*q/spot.z;if(dot(q,q)>3.5)continue;cover=max(cover,shape_cover(q,shape));}
 return cover;
}
vec3 galaxy_color(vec2 p){
 float wave=(sin(p.x*.22+p.y*.12)+cos(p.y*.29-p.x*.09)+2.)/4.;float neb=exp(-pow((p.y-(.45*p.x+21.))/9.,2.));
 vec3 c=vec3(30.+105.*wave+45.*neb,28.+40.*wave+60.*neb,80.+100.*wave+55.*neb)/255.;
 vec2 stars[10]={vec2(27,48),vec2(32,60),vec2(60,56),vec2(69,38),vec2(77,45),vec2(62,65),vec2(24,69),vec2(72,67),vec2(53,73),vec2(67,28)};
 for(int i=0;i<10;i++)if(distance(p,stars[i])<.5)c=vec3(.957,.969,1.);
 return c;
}
vec3 special_eye(vec2 p){
 if(eye_style==20)return soft_rainbow(p.y);
 float wave=(sin(p.x*10.+p.y*5.)+cos(p.y*13.-p.x*4.)+2.)/4.;vec3 c=vec3(.12+.40*wave,.08+.22*wave,.35+.42*wave);
 vec2 stars[4]={vec2(.25,.25),vec2(.65,.38),vec2(.42,.72),vec2(.78,.75)};
 for(int i=0;i<4;i++)if(distance(p,stars[i])<.022)c=vec3(.957,.969,1.);
 return c;
}
void fragment(){
 vec4 src=texture(TEXTURE,UV);vec3 m=texture(region_mask,UV).rgb;vec3 col=src.rgb;
 float shade=clamp(max(src.r,max(src.g,src.b))/0.83,.16,1.2);
 if(!original_horse){
  vec3 c=coat_color.rgb;
  vec2 p=UV*vec2(800.,840.)+vec2(240.,0.);
  bool mark=(pattern==1 && (distance(p,vec2(465.,550.))<45. || distance(p,vec2(850.,570.))<42.)) || (pattern==2 && fract(p.x/65.)<.35 && fract(p.y/70.)<.35) || (pattern==3 && p.x<520. && p.y>410.) || (pattern==4 && p.y>655.);
  if(pattern==2)c=mix(c,vec3(.96,.93,.85),natural_spots(p*.12));
  else if(pattern>=5)c=mix(c,vec3(.96,.93,.85),genetic_pattern(p*.12,pattern));
  else if(mark)c=vec3(.96,.93,.85);
  if(galaxy)c=galaxy_color(p*.12);
  col=mix(col,c*shade,m.r);
  vec3 mane=rainbow?soft_rainbow(p.x<540.?(p.y-300.)/340.:(p.y-80.)/275.):mane_color.rgb;
  if(galaxy)mane=galaxy_color(p*.12);
  col=mix(col,mane*shade,m.g);
 }
 if(!original_hat)col=mix(col,hat_color.rgb*shade,m.b);
 if(custom_eyes){vec3 eye=eye_color.rgb;if(eye_style>=20)eye=special_eye(vec2((UV.x*936.-748.)/118.,(UV.y*983.-244.)/25.));col=mix(col,eye*clamp(max(src.r,max(src.g,src.b))/.65,.15,1.15),texture(eye_mask,UV).r);}
 if(emblem_enabled){
  vec2 step_uv=1./vec2(936.,983.);float ink=texture(emblem_mask,UV).a;float edge=ink;
  for(int y=-1;y<=1;y++){for(int x=-1;x<=1;x++){edge=max(edge,texture(emblem_mask,UV+vec2(float(x),float(y))*step_uv).a);}}
  vec3 sample_col=texture(TEXTURE,vec2(.29,.63)).rgb;float lum=original_horse?.25:dot(coat_color.rgb,vec3(.2126,.7152,.0722));vec3 fg=lum>.46?vec3(.125,.106,.11):vec3(1.,.95,.85);vec3 opposite=lum>.46?vec3(1.,.95,.85):vec3(.125,.106,.11);
  col=mix(col,opposite,edge*.9);col=mix(col,fg,ink);
 }
 COLOR=vec4(col,src.a);
}
