
varying vec3 normal;
varying vec3 eyeDir;
varying vec3 lightDir;
void main() {
	vec3 lightCol = vec3(0.8,0.8,0.8)*( max(dot(normal,lightDir), 0.0) + pow(max(dot(normal,normalize(lightDir+eyeDir)),0.0),30.0)) + vec3(0.2,0.2,0.2);
	gl_FragColor = vec4( lightCol,1.0);
}