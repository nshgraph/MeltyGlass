uniform vec3 affect;
varying vec3 affectInv;
void main()
{
	gl_Position = gl_ProjectionMatrix*gl_Vertex;
	vec4 temp =  gl_ModelViewMatrixInverse*vec4(affect,0.0);
	affectInv = temp.xyz;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}