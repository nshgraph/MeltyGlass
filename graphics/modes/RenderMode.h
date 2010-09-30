//
//  RenderMode.h
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RenderMode : NSObject {
	bool shaderRequiresCompile;
}

-(id)init;

-(id)reload;

-(void)renderStart;

-(void)renderEnd;

@end
