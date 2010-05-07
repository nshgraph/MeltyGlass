uniform sampler2DRect colourTex; 
uniform sampler2DRect vertexTex;
uniform sampler2DRect normalTex;
uniform vec3 gravity;
uniform float deltaTime;

uniform vec3 affect;
varying vec3 affectInv;

const float MAX_INTENSITY = 1.0;
const float COOL_PERCENT = 0.1; //per second
const float MAX_MELT = 0.02;

void main(void)
{
  vec3 vertex = texture2DRect(vertexTex,gl_TexCoord[0].st).xyz;
  vec4 color  = texture2DRect(colourTex,gl_TexCoord[0].st);
  vec3 normal = texture2DRect(normalTex,gl_TexCoord[0].st).xyz ;
  
  vec3 diff = abs(vertex - affectInv);
  float addInt = MAX_INTENSITY / (diff.x*diff.x + diff.y*diff.y + diff.z*diff.z) * deltaTime; // max/d^2
  float remInt = (color.r + color.g + color.b) * deltaTime * COOL_PERCENT;
  float intensity = (color.r + color.g + color.b) + addInt - remInt;
  vec3 transform = -(intensity*gravity*deltaTime*MAX_MELT);
  
  // project tranform onto normal. normal transform is the remaining portion
  normal = normalize(normal);
  vec3 normalTransform = transform - dot(normal,transform)*normal;
  
  gl_FragData[0] =  vec4(vertex + transform,1.0); // vertex
  gl_FragData[1] = clamp(vec4(intensity,intensity-1.0,intensity-2.0,1.0),0.0,1.0); // colour
  gl_FragData[2] = vec4(normal + 2.0*normalTransform,1.0); // normal
}