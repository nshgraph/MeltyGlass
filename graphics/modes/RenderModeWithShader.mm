//
//  ViewModeWithShader.m
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RenderModeWithShader.h"
#import "Shader.h"

#import "CubeMap.h"

@implementation RenderModeWithShader

-(id) initWithPathToFragmentShader: (NSString*) fragmentPath andVertexShader:(NSString*) vertexPath
{
	self = [super init];
	
	fsPath = [[NSString alloc] initWithString:fragmentPath];
	[fsPath retain];
	vsPath = [[NSString alloc] initWithString:vertexPath];
	[vsPath retain];
	
	shader = NULL;
	shaderRequiresCompile = true;
	
	shader = new Shader();
	
	return self;
}

-(void) dealloc
{
	if(shader)
		delete shader;
	
	[cubeMap release];
	
	[fsPath release];
	[vsPath release];
	
	[super dealloc];
}

-(void) recompileShader
{
	shaderRequiresCompile = true;
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
	
	
	
	[cubeMap renderAsCube];
	[cubeMap beginCubeMapTexture];
	
//	glEnable(GL_CULL_FACE);
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	
	
	glColor4f(0.0,0.0,0.0,1.0);
	
	if(shader)
	{
		shader->enableShader();
	}
	
}

-(void)renderEnd
{
	[cubeMap endCubeMapTexture];
	
	if(shader)
		shader->disableShader();
	
	glDisable(GL_LIGHT0);
	glDisable(GL_LIGHTING);
}

-(void)setCubeMap:(CubeMap*)cubeTex
{
	[cubeMap release];
	cubeMap = cubeTex;
	[cubeMap retain];
}

@end
