
uniform vec3 affect;

void main()
{
	gl_Position = gl_ProjectionMatrix*gl_Vertex;
	gl_TexCoord[0] = gl_MultiTexCoord0;
}