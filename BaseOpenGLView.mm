//
//  BaseOpenGLView.mm.m
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseOpenGLView.h"

#include <OpenGL/gl.h> 

#include "Trackball.h"

@implementation BaseOpenGLView
- (void) awakeFromNib
{
	[super awakeFromNib]; 
	
	// set up trackball
	mTrackball = new CTrackball();
	mTrackball->tbInit(0);
	
	mTrackball->tbReshape( [self frame].size.width, [self frame].size.height );
	mbUseTrackball = true;
		
	//set up display link
	[self prepareTimer];
	[self initializeView];
} 


// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(BaseOpenGLView*)displayLinkContext getFrameForTime:outputTime];
    return result;
}


- (void)prepareTimer
{ 
	// Synchronize buffer swaps with vertical refresh rate
    GLint swapInt = 1;
    [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval]; 
	
    // Create a display link capable of being used with all active displays
    CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	
    // Set the renderer output callback function
    CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, self);
	
    // Set the display link for the current renderer
    CGLContextObj cglContext = (CGLContextObj)[[self openGLContext] CGLContextObj];
    CGLPixelFormatObj cglPixelFormat = (CGLPixelFormatObj)[[self pixelFormat] CGLPixelFormatObj];
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
	
    // Activate the display link
    CVDisplayLinkStart(displayLink);
	
}

- (CVReturn)getFrameForTime:(const CVTimeStamp*)timeStamp
{
	CVReturn rv = kCVReturnError;
	
    NSAutoreleasePool *pool;
	
	
	
    pool = [[NSAutoreleasePool alloc] init];
	
	[self drawRect:NSZeroRect];
		
	rv = kCVReturnSuccess;
	
    [pool release];
	
    return rv;
	
}

- (void)dealloc
{
    // Release the display link
    CVDisplayLinkRelease(displayLink);
	
    [super dealloc];
}


- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}
		
- (void)mouseDown:(NSEvent *)theEvent
{     
	NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSTimeInterval mouseTime = [theEvent timestamp];

	if( mTrackball )
		mTrackball->tbMouse(0, GLUT_DOWN, mouseLoc.x, mouseLoc.y, mouseTime * 1000 );
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSTimeInterval mouseTime = [theEvent timestamp];
	
	if( mTrackball )
		mTrackball->tbMotion( mouseLoc.x, mouseLoc.y, mouseTime * 1000 );
}

- (void)mouseUp:(NSEvent *)theEvent
{
	NSPoint mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	NSTimeInterval mouseTime = [theEvent timestamp];
	
	if( mTrackball )
		mTrackball->tbMouse(0, GLUT_UP, mouseLoc.x, mouseLoc.y, mouseTime * 1000 );
}


- (void) initializeView
{
	glEnable(GL_DEPTH_TEST);
	
	glShadeModel(GL_SMOOTH);
	glPolygonOffset (1.0f, 1.0f);
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void) draw
{
	glColor3f(1.0f, 0.85f, 0.35f); glBegin(GL_TRIANGLES); { glVertex3f( 0.0, 0.6, 0.0); glVertex3f( -0.2, -0.3, 0.0); glVertex3f( 0.2, -0.3 ,0.0); } glEnd(); 
}


-(void) drawRect: (NSRect) bounds 
{
    // Add your drawing codes here
	
	NSOpenGLContext	*currentContext = [self openGLContext];
	[currentContext makeCurrentContext];
	
	// remember to lock the context before we touch it since display link is threaded
	CGLLockContext((CGLContextObj)[currentContext CGLContextObj]);
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	


	
	glMatrixMode( GL_PROJECTION );
	glLoadIdentity();
	GLfloat radians, wd2;
	radians = 0.0174532925 * 50 / 2; // half aperture degrees to radians 
	wd2 = tan(radians);
	glFrustum (-wd2, wd2, -wd2, wd2, 1.0, 100.0);	

	glMatrixMode( GL_MODELVIEW );
	glLoadIdentity(); 
	gluLookAt( 0,0,3, 0,0,0,0,1,0);
	
	if( mbUseTrackball && mTrackball )
		mTrackball->tbMatrix();
	
	glEnable(GL_DEPTH_TEST);
	
	[self draw];
	
	[currentContext flushBuffer];
	
	CGLUnlockContext((CGLContextObj)[currentContext CGLContextObj]);
} 


- (void)setFrameSize:(NSSize)newSize
{
	if( mTrackball )
		mTrackball->tbReshape( newSize.width, newSize.height );
	[super setFrameSize: newSize];
}

- (void)setFrame:(NSRect)frameRect
{
	if( mTrackball )
		mTrackball->tbReshape( frameRect.size.width, frameRect.size.height );
	[super setFrame: frameRect];
}

@end
