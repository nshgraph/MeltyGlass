//
//  ViewModeWithShader.m
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RenderModeWithShader.h"

#import "CubeMap.h"

@implementation RenderModeWithShader

-(id) initWithPathToFragmentShader: (NSString*) fragmentPath andVertexShader:(NSString*) vertexPath
{
	self = [super init];
	
	[fsPath release];
	fsPath = [[NSString alloc] initWithString:fragmentPath];
	[fsPath retain];
	[vsPath release];
	vsPath = [[NSString alloc] initWithString:vertexPath];
	[vsPath retain];
	
	return self;
}

-(void) dealloc
{	
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
	
	[cubeMap renderAsCube];
	[cubeMap beginCubeMapTexture];
	
	[super renderStart];	
}

-(void)renderEnd
{
	
	[super renderEnd];
	
	[cubeMap endCubeMapTexture];
}

-(void)setCubeMap:(CubeMap*)cubeTex
{
	[cubeMap release];
	cubeMap = cubeTex;
	[cubeMap retain];
}

@end
