shader_type canvas_item;
uniform vec4 emblem_color : source_color = vec4(0.45,0.8,0.7,1.);
uniform bool emblem_enabled=false;
uniform sampler2D emblem_mask: filter_linear;
uniform sampler2D eye_mask: filter_linear;
uniform vec4 eye_color: source_color = vec4(.6,.3,.1,1);
uniform bool custom_eyes = false;
uniform int eye_style = 0;
uniform bool galaxy = false;
// Art-direction intensity, independent of mastery progress.
uniform float galaxy_intensity: hint_range(0.,1.) = 1.;
// Mastery-only silhouette halo. Disabled for regular Galaxy and all other horses.
uniform bool mastery_aura = false;
uniform bool mastery_sun = false;
uniform bool mastery_moon = false;
uniform bool mastery_greek_preview = false;
uniform float mastery_mark_scale: hint_range(.5,2.) = 1.;
uniform vec2 mastery_sun_center=vec2(.70,.60);
uniform float mastery_aura_strength: hint_range(0.,2.) = 1.;
uniform float galaxy_star_density: hint_range(0.,1.) = 1.;
uniform vec4 mastery_aura_color: source_color=vec4(.24,.57,1.,1.);
// Opt-in palette study. Defaults retain the released Galaxy appearance exactly.
uniform bool galaxy_palette_preview = false;
uniform vec4 galaxy_dark: source_color=vec4(.12,.03,.09,1.);
uniform vec4 galaxy_light: source_color=vec4(.95,.30,.65,1.);
uniform bool galaxy_blue_mix=false;
uniform sampler2D hat_mask: filter_linear;
uniform bool separate_hat_mask=false;
uniform sampler2D region_mask: filter_linear;
uniform sampler2D light_legs_mask: filter_linear;
uniform sampler2D lower_legs_mask: filter_linear;
uniform bool custom_legs=false;
uniform vec4 legs_color: source_color=vec4(1.);
uniform vec4 coat_color: source_color = vec4(.6,.3,.1,1);
uniform vec4 mane_color: source_color = vec4(1,.95,.8,1);
uniform vec4 hat_color: source_color = vec4(.2,.3,.45,1);
uniform bool original_horse = true;
uniform bool original_hat = true;
uniform bool rainbow = false;
uniform int pattern = 0;
uniform sampler2D cow_map: repeat_enable, filter_nearest;
uniform sampler2D giraffe_map: repeat_enable, filter_nearest;
uniform sampler2D zebra_map: repeat_enable, filter_nearest;
uniform vec4 spot_color: source_color=vec4(.96,.93,.85,1.);
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
  cover=max(cover,1.-smoothstep(-max(fwidth(distance_to_edge),.1),max(fwidth(distance_to_edge),.1),distance_to_edge));
 }
 return cover;
}
float shape_cover(vec2 q,int shape){
 if(shape==5){q.y=-q.y+.25;float a=dot(q,q)-1.;float field=a*a*a-q.x*q.x*q.y*q.y*q.y;float aa=max(fwidth(field),.025);return 1.-smoothstep(-aa,aa,field);}
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
 if(shape==11)return texture(cow_map,p/96.).r;
 if(shape==10)return texture(giraffe_map,p/96.).r;
 if(shape==9)return texture(zebra_map,p/96.).r;
 float cover=0.;
 for(int i=0;i<128;i++){if(i>=spot_count)break;vec4 spot=spot_data[i];vec2 q=p-spot.xy;float cs=cos(spot.w),sn=sin(spot.w);q=mat2(vec2(cs,-sn),vec2(sn,cs))*q/spot.z;if(dot(q,q)>3.5)continue;cover=max(cover,shape_cover(q,shape));}
 return cover;
}
float galaxy_hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float galaxy_noise(vec2 p){
 vec2 i=floor(p),f=fract(p);f=f*f*(3.-2.*f);
 return mix(mix(galaxy_hash(i),galaxy_hash(i+vec2(1,0)),f.x),mix(galaxy_hash(i+vec2(0,1)),galaxy_hash(i+vec2(1,1)),f.x),f.y);
}
float galaxy_cloud(vec2 p){
 float n=0.,amp=.56;
 for(int i=0;i<4;i++){n+=amp*galaxy_noise(p);p=mat2(vec2(.8,.6),vec2(-.6,.8))*p*2.1+vec2(13.2,7.1);amp*=.48;}
 return n;
}
float galaxy_stars(vec2 p){
 vec2 grid=p/4.3;vec2 cell=floor(grid);float brightness=0.;
 for(int yy=-1;yy<=1;yy++){for(int xx=-1;xx<=1;xx++){
  vec2 c=cell+vec2(float(xx),float(yy));float h=galaxy_hash(c);
  if(h>.38*galaxy_star_density)continue;
  vec2 place=c+vec2(.18+.64*galaxy_hash(c+37.),.18+.64*galaxy_hash(c+93.));
  vec2 d=(grid-place)*4.3;float r=length(d);float radius=mix(.10,.27,galaxy_hash(c+11.));
  float core=1.-smoothstep(radius*.3,radius+.10,r);
  float glow=exp(-r*r/(radius*radius*7.))*.30;
  float rays=(exp(-abs(d.x)*25.)*exp(-abs(d.y)*3.)+exp(-abs(d.y)*25.)*exp(-abs(d.x)*3.))*.38;
  brightness=max(brightness,core+glow+(h<.075?rays:0.));
 }}
 return clamp(brightness,0.,1.);
}
vec3 galaxy_color(vec2 p){
 float wave=(sin(p.x*.22+p.y*.12)+cos(p.y*.29-p.x*.09)+2.)/4.;float neb=exp(-pow((p.y-(.45*p.x+21.))/9.,2.));
 vec3 c=vec3(30.+105.*wave+45.*neb,28.+40.*wave+60.*neb,80.+100.*wave+55.*neb)/255.;
 if(galaxy_palette_preview){
  float cloud=galaxy_cloud(p*.105);
  float dust=galaxy_cloud(p*.30+vec2(8.1,4.2));
  float ribbon=exp(-pow((p.y-(.46*p.x+21.+sin(p.x*.12)*5.))/6.,2.));
  float wisps=smoothstep(.35,.77,cloud)*(.30+.70*dust);
  c=mix(galaxy_dark.rgb*.40,galaxy_light.rgb,.14+.55*wisps+.32*ribbon);
  if(galaxy_blue_mix){
   float blend=smoothstep(.28,.70,galaxy_cloud(p*.07+vec2(19,7)));
   vec3 blue=mix(vec3(.008,.018,.09),vec3(.08,.34,.82),.20+.65*cloud+.20*ribbon);
   c=mix(c,blue,blend);
  }
  // Pale nebula filaments, deep dust lanes and a seeded point-star field.
  float filament=smoothstep(.58,.78,dust)*ribbon;
  c+=mix(galaxy_light.rgb,vec3(.55,.76,1.),galaxy_blue_mix?.65:.18)*(ribbon*.28+filament*.44);
  c*=1.-smoothstep(.59,.79,galaxy_cloud(p*.19+29.))* .47;
  float stars=galaxy_stars(p);
  c=mix(c,vec3(.98,.99,1.),stars);
  return clamp(c,0.,1.);
 }
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
float mark_line(vec2 p,vec2 a,vec2 b){
 vec2 v=b-a;float t=clamp(dot(p-a,v)/dot(v,v),0.,1.);
 return 1.-smoothstep(1.1,2.3,length(p-a-v*t));
}
void fragment(){
 vec4 src=texture(TEXTURE,UV);vec3 m=texture(region_mask,UV).rgb;vec3 col=src.rgb;
 float shade=clamp(max(src.r,max(src.g,src.b))/0.83,.16,1.2);
 if(!original_horse){
  vec3 c=coat_color.rgb;
  vec2 p=UV*vec2(800.,840.)+vec2(240.,0.);
  bool mark=(pattern==1 && (distance(p,vec2(465.,550.))<45. || distance(p,vec2(850.,570.))<42.)) || (pattern==2 && fract(p.x/65.)<.35 && fract(p.y/70.)<.35) || (pattern==3 && p.x<520. && p.y>410.);
  if(pattern==2)c=mix(c,spot_color.rgb,natural_spots(p*.12));
  else if(pattern>=5)c=mix(c,spot_color.rgb,genetic_pattern(p*.12,pattern));
  else if(pattern==4)c=mix(c,vec3(.96,.93,.85),texture(light_legs_mask,UV).r);
  else if(mark)c=spot_color.rgb;
  if(galaxy){
   vec3 galaxy_rgb=galaxy_color(p*.12);
   // Turn down chroma and local contrast, never darken the base into saturation.
   float luma=dot(galaxy_rgb,vec3(.2126,.7152,.0722));
   vec3 quiet=mix(vec3(.36,.33,.43),vec3(luma),.18);
   c=mix(quiet,galaxy_rgb,galaxy_intensity);
  }
  float coat_shade=shade;
  if(pattern==4)coat_shade=mix(shade,min(shade+.12,1.2),texture(light_legs_mask,UV).r);
  col=mix(col,c*coat_shade,m.r);
  vec3 mane=rainbow?soft_rainbow(p.x<540.?(p.y-300.)/340.:(p.y-80.)/275.):mane_color.rgb;
  if(galaxy){
   vec3 galaxy_rgb=galaxy_color(p*.12);
   float luma=dot(galaxy_rgb,vec3(.2126,.7152,.0722));
   mane=mix(mix(vec3(.36,.33,.43),vec3(luma),.18),galaxy_rgb,galaxy_intensity);
  }
  col=mix(col,mane*shade,m.g);
 }
 if(custom_legs){
  float coverage=texture(lower_legs_mask,UV).r;
  if(pattern==4)coverage=max(coverage,step(.01,texture(light_legs_mask,UV).r));
  col=mix(col,legs_color.rgb*shade,coverage);
 }
 if(!original_hat)col=mix(col,hat_color.rgb*shade,(separate_hat_mask?texture(hat_mask,UV).b:m.b));
 if(custom_eyes){vec3 eye=eye_color.rgb;if(eye_style>=20)eye=special_eye(vec2((UV.x*936.-748.)/118.,(UV.y*983.-244.)/25.));col=mix(col,eye*clamp(max(src.r,max(src.g,src.b))/.65,.15,1.15),texture(eye_mask,UV).r);}
 if(emblem_enabled && !(mastery_moon && galaxy)){
  vec2 step_uv=1./vec2(936.,983.);float ink=texture(emblem_mask,UV).a;float edge=ink;
  for(int y=-1;y<=1;y++){for(int x=-1;x<=1;x++){edge=max(edge,texture(emblem_mask,UV+vec2(float(x),float(y))*step_uv).a);}}
  float lum=original_horse?.25:dot(coat_color.rgb,vec3(.2126,.7152,.0722));vec3 fg=emblem_color.rgb;vec3 opposite=lum>.46?vec3(.125,.106,.11):vec3(1.,.95,.85);
  float horse_only=step(.5,m.r)*step(.01,src.a);
  col=mix(col,opposite,edge*.9*horse_only);col=mix(col,fg,ink*horse_only);
 }
 // The mastery moon takes visual priority; saved emblems stay untouched.
 if(mastery_moon && galaxy){
  vec2 q=(UV*vec2(936.,983.)-vec2(305.,618.))/mastery_mark_scale;
  float outer=1.-smoothstep(27.,30.,length(q));
  float cut=1.-smoothstep(25.,28.,length(q-vec2(14.,-9.)));
  float crescent=outer*(1.-cut)*m.r*src.a;
  float glow=exp(-dot(q,q)/1400.)*.22*m.r*src.a;
  col=mix(col,vec3(.84,.94,1.),crescent*.96);
  col+=vec3(.25,.52,1.)*glow;
 }
 // A separate mastery mark, never written to hereditary emblems or masks.
 if(mastery_sun && galaxy){
  vec2 q=(UV-mastery_sun_center)*vec2(936.,983.)/mastery_mark_scale;
  float r=length(q);float angle=atan(q.y,q.x);
  float disc=1.-smoothstep(21.,25.,r);
  float ray_shape=pow(max(0.,cos(angle*12.)),8.);
  float rays=ray_shape*smoothstep(20.,27.,r)*(1.-smoothstep(28.,43.,r));
  float glow=exp(-r*r/1250.)*.42;
  float coat_only=m.r*src.a;
  vec3 sun_color=mix(vec3(1.,.69,.20),vec3(1.,.96,.72),disc*.8);
  col=mix(col,sun_color,(disc*.94+rays*.80)*coat_only);
  col+=vec3(.30,.56,1.)*glow*coat_only;
 }
 if(mastery_greek_preview && mastery_sun && mastery_moon && galaxy){
  vec2 a=((UV-mastery_sun_center)*vec2(936.,983.))/mastery_mark_scale-vec2(0.,49.);
  float alpha=max(max(mark_line(a,vec2(-10,12),vec2(0,-12)),mark_line(a,vec2(0,-12),vec2(10,12))),mark_line(a,vec2(-6,3),vec2(6,3)));
  vec2 o=(UV*vec2(936.,983.)-vec2(305.,618.))/mastery_mark_scale-vec2(0.,49.);
  float arc=(1.-smoothstep(1.1,2.3,abs(length(o)-11.)))*step(o.y,7.);
  float omega=max(arc,max(mark_line(o,vec2(-10,7),vec2(-6,12)),mark_line(o,vec2(10,7),vec2(6,12))));
  omega=max(omega,max(mark_line(o,vec2(-14,12),vec2(-6,12)),mark_line(o,vec2(6,12),vec2(14,12))));
  col=mix(col,vec3(.88,.96,1.),max(alpha,omega)*m.r*src.a);
 }
 float out_alpha=src.a;
 if(mastery_aura && galaxy){
  float halo=0.;float rim=0.;
  vec2 px=TEXTURE_PIXEL_SIZE;
  // Three soft rings around the horse-only region, not around the rider/hat.
  for(int k=0;k<16;k++){
   float angle=float(k)*.39269908;vec2 dir=vec2(cos(angle),sin(angle));
   for(int ring=1;ring<=3;ring++){
    vec2 q=UV+dir*px*float(ring)*7.;
    vec3 region=texture(region_mask,q).rgb;
    float horse=max(region.r,region.g)*texture(TEXTURE,q).a;
    halo+=horse*(ring==1?.5:(ring==2?.32:.18))/16.;
   }
   vec2 q=UV+dir*px*3.;
   rim+=texture(TEXTURE,q).a/16.;
  }
  float aura=clamp(halo*.72*mastery_aura_strength,0.,.80)*(1.-src.a);
  float horse_here=max(m.r,m.g);
  col+=mastery_aura_color.rgb*(1.-rim)*horse_here*.20*mastery_aura_strength;
  out_alpha=src.a+aura;
  col=(col*src.a+mastery_aura_color.rgb*aura)/max(out_alpha,.0001);
 }
 COLOR=vec4(col,out_alpha);
}
