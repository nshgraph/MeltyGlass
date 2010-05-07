//
//  CubeMap.h
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <OpenGL/gl.h>

#include "RenderObject.h"


@interface CubeMap : NSObject {
	NSString* imgDir;
	bool initialized;
	GLint textures[6];
	GLint frontTex;
	
	float axis[3];
	
	GLint rotationAxisVariable;
}

-(id)initWithPath:(NSString*)path;

-(void)dealloc;

-(void)create;

-(void)renderAsCube;

-(void)beginCubeMapTexture;
-(void)endCubeMapTexture;

@end
