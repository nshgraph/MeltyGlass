
varying vec3 normal;
varying vec3 eyeDir;
varying vec3 lightDir;
void main() {
	normal = normalize( gl_NormalMatrix * gl_Normal );
	vec3 vertex = vec3( gl_ModelViewMatrix * gl_Vertex );
	lightDir = normalize( gl_LightSource[0].position.xyz - vertex );
	eyeDir = normalize( -vertex );
	gl_FrontColor = gl_Color;
	gl_Position = ftransform();
}