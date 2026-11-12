shader_type canvas_item;
uniform vec2 rider_uv=vec2(-1.);
void fragment(){
 vec4 color=texture(TEXTURE,UV);
 // The crown stays above the rider. A small local fade lets the rider remain
 // visible beneath it, without turning the whole tree into a floor.
 vec2 delta=(UV-rider_uv)*vec2(2800.,2394.);
 float reveal=1.-smoothstep(100.,210.,length(delta));
 float crown=1.-smoothstep(.70,.78,UV.y);
 color.a*=1.-reveal*crown*.82;
 COLOR=color;
}
