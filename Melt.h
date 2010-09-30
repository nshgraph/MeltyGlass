//
//  Melt.h
//  MeltyGlass
//
//  Created by nathanholmberg on 8/09/10.
//  Copyright 2010 Serato Audio Research. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RenderToBuffer.h"

@interface Melt : RenderToBuffer {
	
	int pointLocation;
	int gravityLocation;
	int timeLocation;
	int colourLocation;
	int vertexLocation;
	int normalLocation;
	
	NSPoint infinity;
}

-(id) init;

-(void)renderWithObject:(RenderObject*)renderObject withDeltaTime:(float) delta andAffectPoint:(NSPoint) affect;


-(void) getShaderLocations;

@end
