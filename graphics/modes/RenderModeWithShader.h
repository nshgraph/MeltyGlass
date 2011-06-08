//
//  ViewModeWithShader.h
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RenderMode.h"

class Shader;
@class CubeMap;


@interface RenderModeWithShader : RenderMode {
	CubeMap* cubeMap;
}
-(id) initWithPathToFragmentShader: (NSString*) fragmentPath andVertexShader:(NSString*) vertexPath;

-(void) dealloc;

-(void)renderStart;

-(void)renderEnd;

-(void)setCubeMap:(CubeMap*)cubeTex;

@end
