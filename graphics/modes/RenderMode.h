//
//  RenderMode.h
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Shader.h"

@interface RenderMode : NSObject {
	Shader* shader;
	NSString* fsPath;
	NSString* vsPath;
	
	bool shaderRequiresCompile;
}

-(id)init;

-(void)dealloc;

-(void)reload;

-(void)renderStart;

-(void)renderEnd;

@end
