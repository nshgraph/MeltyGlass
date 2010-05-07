//
//  WireframeViewMode.m
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RenderModeWireframe.h"
#import "Shader.h"


@implementation RenderModeWireframe
Shader* shaderWire;

NSString* vsWireString = @" \
void main() { \n\
gl_Position = ftransform(); \n\
gl_FrontColor = gl_Color; \n\
} \n\
";

NSString* fsWireString = @" \
void main() { \n\
gl_FragColor = vec4(gl_Color.rgb + vec3(0.3,0.3,0.3),1.0); \n\
} \n\
";

-(id)init
{
	[super init];
	shaderWire = new Shader();
	shaderRequiresCompile = true;
	return self;
}

-(void)renderStart
{
	if(shaderRequiresCompile)
	{
		shaderWire->loadVertexShaderFromString([vsWireString cStringUsingEncoding: NSUTF8StringEncoding]);
		shaderWire->loadFragmentShaderFromString([fsWireString cStringUsingEncoding: NSUTF8StringEncoding]);
		shaderWire->compileAndLink();
		shaderRequiresCompile = false;
	}
	
//	glDisable(GL_CULL_FACE);
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	
	glColor3f(1.0,1.0,1.0);
	
	if(shaderWire)
	{
		shaderWire->enableShader();
	}
}

-(void)renderEnd
{
	
	if(shaderWire)
	{
		shaderWire->disableShader();
	}
	
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
}

@end
