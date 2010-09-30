//
//  MouseHandlerAffect.h
//  OpenGLShader
//
//  Created by Serato on 2/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MouseHandler.h"


@interface MouseHandlerAffect : MouseHandler {
	bool mouseIsDown;
	NSOpenGLView* glView;
	NSPoint affectPoint;
}

-(id)initWithView:(NSOpenGLView*) view;

-(NSPoint) getPoint;

-(bool) isActive;

@end
