//
//  WireframeViewMode.m
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RenderModeWireframe.h"


@implementation RenderModeWireframe

-(id)init
{
	[super init];
	
	[fsPath release];
	[vsPath release];
	
	
	fsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Wireframe.FS"];
	vsPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Wireframe.VS"];
	
	[fsPath retain];
	[vsPath retain];
	
	shaderRequiresCompile = true;
	return self;
}

-(void)renderStart
{
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	[super renderStart];
}

-(void)renderEnd
{
	[super renderEnd];
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
}

@end
