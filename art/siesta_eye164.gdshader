shader_type canvas_item;
uniform float aperture : hint_range(0.0,1.0) = 0.0;
uniform float softness = 0.045;
void fragment(){
 float opening=0.5*aperture*sin(UV.x*3.14159265)-softness*(1.0-aperture);
 float distance=abs(UV.y-0.5);
 float alpha=smoothstep(opening-softness,opening+softness,distance);
 if(aperture>=0.99999){alpha=0.0;}
 COLOR=vec4(0.0314,0.0510,0.0706,alpha);
}
