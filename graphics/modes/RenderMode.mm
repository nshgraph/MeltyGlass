//
//  RenderMode.m
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RenderMode.h"

@implementation RenderMode

-(id)init
{
	[super init];
	shader = new Shader();
	
	
	fsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Default.FS"];
	vsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Default.VS"];
	
	[fsPath retain];
	[vsPath retain];
	
	shaderRequiresCompile = true;
	return self;
}

-(void)dealloc
{
	[fsPath release];
	[vsPath release];
	
	[super dealloc];
}

-(void)reload
{
	// by default this method does nothing
	shader->loadVertexShaderFromFile([vsPath cStringUsingEncoding: NSUTF8StringEncoding]);
	shader->loadFragmentShaderFromFile([fsPath cStringUsingEncoding: NSUTF8StringEncoding]);
	shader->compileAndLink();
	shaderRequiresCompile = false;
}

-(void)renderStart
{
	if(shaderRequiresCompile)
	{
		shader->loadVertexShaderFromFile([vsPath cStringUsingEncoding: NSUTF8StringEncoding]);
		shader->loadFragmentShaderFromFile([fsPath cStringUsingEncoding: NSUTF8StringEncoding]);
		shader->compileAndLink();
		shaderRequiresCompile = false;
	}
	
	if(shader)
	{
		shader->enableShader();
	}
	
//	glEnable(GL_CULL_FACE);
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	
	glColor4f(0.5,0.5,0.5,1.0);
}

-(void)renderEnd
{
	
	if(shader)
	{
		shader->disableShader();
	}
	
	glDisable(GL_LIGHT0);
	glDisable(GL_LIGHTING);
}

@end
