varying vec3 view;
varying vec3 normal;

uniform samplerCube tex;

void main()
{	

	const float eta = 1.00 / 1.20;
	const vec3 coefficients = vec3( 0.3, 0.6, 0.5 );
	
	float light = pow(max(dot(normal, gl_LightSource[0].halfVector.xyz),0.0),1000.0);
	
	vec3 reflect_v = normalize(reflect(view,-normal));
	vec3 colReflect = textureCube(tex,reflect_v).rgb;
	
	vec3 refract_v = normalize(refract(view,-normal,eta));
	vec3 colRefract = textureCube(tex,refract_v).rgb;
	
	gl_FragColor = vec4(coefficients.x * colReflect + coefficients.y * colRefract + coefficients.z * vec3(light,light,light) + gl_Color.rgb,1.0);
}