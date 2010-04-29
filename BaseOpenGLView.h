//
//  BaseOpenGLView.mm.h
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

class CTrackball;

@interface BaseOpenGLView : NSOpenGLView {
	// Timer related   
	CVDisplayLinkRef displayLink; //display link for managing rendering thread

	
	// Trackball
	bool mbUseTrackball;
	CTrackball* mTrackball;
}
// the big ones - should be overwritten
- (void) initializeView;
- (void) draw;

// overrides to handle fitting in NSView
- (void) drawRect: (NSRect) bounds; 
- (void)setFrameSize:(NSSize)newSize;
- (void)setFrame:(NSRect)frameRect;

// mouse related events
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

// timer related
- (void)prepareTimer;
- (CVReturn)getFrameForTime:(const CVTimeStamp*)outputTime;

@end
