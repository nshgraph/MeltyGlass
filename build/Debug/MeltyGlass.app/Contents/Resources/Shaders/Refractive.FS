varying vec3 view;
varying vec3 normal;

uniform samplerCube tex;

varying float LightIntensity;

void main()
{
	const float index_external = 1.00;
	const float index_internal = 1.20;
	float eta = index_external/index_internal;
	vec3 reflection = normalize(reflect(view,-normal));
	vec4 colRefract = textureCube(tex,normalize(refract(view,-normal,eta)));
	vec4 colReflect = textureCube(tex,reflection);
	
	float light = pow(max(dot(normal, gl_LightSource[0].halfVector.xyz),0.0),1000.0);
	
	gl_FragColor = vec4(colReflect.rgb * 0.3 + colRefract.rgb * 0.6 + vec3(light,light,light)*0.3 + gl_Color.rgb,1.0);
	//gl_FragColor = vec4(normal,1.0);
}