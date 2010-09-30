
varying vec3 view;
varying vec3 normal;

varying float LightIntensity;


const float PI = 3.1415;
const vec3 vect = vec3(0.0,3.14,0.0);

void main()
{
	const vec3 LightPos = vec3(0.0,0.0,-1.0);
	gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	
	gl_Position = ftransform();
	
	vec3 up = vec3(sin(vect.x),cos(vect.x),0.0);
	vec3 dir = vec3(0.0,sin(vect.y),cos(vect.y));
	vec3 f = normalize(dir);
	vec3 s = normalize(cross(f,up));
	vec3 t = normalize(cross(s,f));
	view = vec3( dot( gl_Position.xyz, s ), dot( gl_Position.xyz, t ), dot( gl_Position.xyz, -f ) );
	view = normalize(view);

    normal = normalize(gl_NormalMatrix * normalize(gl_Normal));
	normal = gl_Normal;
    LightIntensity = max(dot(normalize(LightPos - view), normal), 0.0);
}