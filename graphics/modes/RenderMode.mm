//
//  RenderMode.m
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RenderMode.h"
#import "Shader.h"


@implementation RenderMode
Shader* shaderNormal;

NSString* vsShadeString = @" \
varying vec3 normal; \n\
varying vec3 eyeDir; \n\
varying vec3 lightDir; \n\
void main() { \n\
normal = normalize(gl_NormalMatrix * gl_Normal); \n\
vec3 vertex = vec3(gl_ModelViewMatrix * gl_Vertex); \n\
lightDir = normalize(gl_LightSource[0].position.xyz - vertex); \n\
eyeDir = normalize(-vertex); \n\
gl_FrontColor = gl_Color; \n\
gl_Position = ftransform(); \n\
} \n\
";

NSString* fsShadeString = @" \
varying vec3 normal; \n\
varying vec3 eyeDir; \n\
varying vec3 lightDir; \n\
void main() { \n\
vec3 lightCol = vec3(0.8,0.8,0.8)*( max(dot(normal,lightDir), 0.0) + pow(max(dot(normal,normalize(lightDir+eyeDir)),0.0),30.0)) + vec3(0.2,0.2,0.2); \n\
gl_FragColor = vec4( lightCol,1.0); \n\
} \n\
";

-(id)init
{
	[super init];
	shaderNormal = new Shader();
	shaderRequiresCompile = true;
	return self;
}

-(id)reload
{
	// by default this method does nothing
}

-(void)renderStart
{
	if(shaderRequiresCompile)
	{
		shaderNormal->loadVertexShaderFromString([vsShadeString cStringUsingEncoding: NSUTF8StringEncoding]);
		shaderNormal->loadFragmentShaderFromString([fsShadeString cStringUsingEncoding: NSUTF8StringEncoding]);
		shaderNormal->compileAndLink();
		shaderRequiresCompile = false;
	}
	
	if(shaderNormal)
	{
		shaderNormal->enableShader();
	}
	
//	glEnable(GL_CULL_FACE);
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	
	glColor4f(0.5,0.5,0.5,1.0);
}

-(void)renderEnd
{
	
	if(shaderNormal)
	{
		shaderNormal->disableShader();
	}
	
	glDisable(GL_LIGHT0);
	glDisable(GL_LIGHTING);
}

@end
