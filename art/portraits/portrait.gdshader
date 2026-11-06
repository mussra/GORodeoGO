shader_type canvas_item;
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
void fragment(){
 vec4 src=texture(TEXTURE,UV);vec3 m=texture(region_mask,UV).rgb;vec3 col=src.rgb;
 float shade=clamp(max(src.r,max(src.g,src.b))/0.83,.16,1.2);
 if(!original_horse){
  vec3 c=coat_color.rgb;
  vec2 p=UV*vec2(800.,840.)+vec2(240.,0.);
  bool mark=(pattern==1 && (distance(p,vec2(465.,550.))<45. || distance(p,vec2(850.,570.))<42.)) || (pattern==2 && fract(p.x/65.)<.35 && fract(p.y/70.)<.35) || (pattern==3 && p.x<520. && p.y>410.) || (pattern==4 && p.y>655.);
  if(mark)c=vec3(.96,.93,.85);
  col=mix(col,c*shade,m.r);
  vec3 mane=rainbow?soft_rainbow(p.x<540.?(p.y-300.)/340.:(p.y-80.)/275.):mane_color.rgb;
  col=mix(col,mane*shade,m.g);
 }
 if(!original_hat)col=mix(col,hat_color.rgb*shade,m.b);
 COLOR=vec4(col,src.a);
}
