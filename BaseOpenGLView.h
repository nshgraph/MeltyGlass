//
//  BaseOpenGLView.mm.h
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@class MouseHandler;
struct MHCamera;

@interface BaseOpenGLView : NSOpenGLView {
	// Timer related   
	CVDisplayLinkRef displayLink; //display link for managing rendering thread

	MHCamera* camera;
	MouseHandler* mouseHandler;
}

// the big ones - should be overwritten
- (void) initializeView;

- (void) resizeGL;
- (void) updateProjection;
- (void) updateModelView;

- (void) draw;

// overrides to handle fitting in NSView
- (void) drawRect: (NSRect) bounds; 
- (void)setFrameSize:(NSSize)newSize;
- (void)setFrame:(NSRect)frameRect;

// mouse related events
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent;
- (void) mouseDown:(NSEvent *)theEvent;
- (void) rightMouseDown:(NSEvent *)theEvent;
- (void) otherMouseDown:(NSEvent *)theEvent;
- (void) mouseUp:(NSEvent *)theEvent;
- (void) rightMouseUp:(NSEvent *)theEvent;
- (void) otherMouseUp:(NSEvent *)theEvent;
- (void) mouseDragged:(NSEvent *)theEvent;
- (void) scrollWheel:(NSEvent *)theEvent;
- (void) rightMouseDragged:(NSEvent *)theEvent;
- (void) otherMouseDragged:(NSEvent *)theEvent;

- (void) resetCamera;


// timer related
- (void)prepareTimer;
- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime;

@end
