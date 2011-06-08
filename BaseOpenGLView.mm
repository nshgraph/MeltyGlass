//
//  BaseOpenGLView.mm.m
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseOpenGLView.h"

#include <OpenGL/gl.h> 
#include <OpenGL/glu.h> 

#import "MouseHandlerTrackball.h"

@implementation BaseOpenGLView
- (void) awakeFromNib
{
	[super awakeFromNib]; 
	
	// set up trackball
	camera = new MHCamera;
	[self resetCamera];
	mouseHandler = [[MouseHandlerTrackball alloc] initWithCamera:camera andView: self];
	
	frameDelta = 0.0;
	
		
	//set up display link
	[self prepareTimer];
	[self initializeView];
} 

// sets the camera data to initial conditions
- (void) resetCamera
{
	camera->aperture = 20;
	camera->rotPoint.x = 0.0;
	camera->rotPoint.y = 0.0;
	camera->rotPoint.z = 0.0;
	
	camera->viewPos.x = 0.0;
	camera->viewPos.y = 0.0;
	camera->viewPos.z = -5.0;
	camera->viewDir.x = -camera->viewPos.x; 
	camera->viewDir.y = -camera->viewPos.y; 
	camera->viewDir.z = -camera->viewPos.z;
	
	camera->viewUp.x = 0;  
	camera->viewUp.y = -1;
	camera->viewUp.z = 0;
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
	
	frameDelta = (timeStamp->videoTime - framePreviousTime) / (double)timeStamp->videoTimeScale;
	framePreviousTime = timeStamp->videoTime;
	
	
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


- (void) initializeView
{
	glEnable(GL_DEPTH_TEST);
	
	glShadeModel(GL_SMOOTH);
	glPolygonOffset (1.0f, 1.0f);
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

// a window dimension update, reseting of viewport and an update of the projection matrix
- (void) resizeGL
{
	NSRect rectView = [self bounds];
	
	// ensure camera knows size changed
	if ((camera->viewHeight != rectView.size.height) ||
	    (camera->viewWidth != rectView.size.width)) {
		camera->viewHeight = rectView.size.height;
		camera->viewWidth = rectView.size.width;
		
		glViewport (0, 0, camera->viewWidth, camera->viewHeight);
	}
}

- (void) updateProjection
{
	glMatrixMode( GL_PROJECTION );
	glLoadIdentity();
	
	GLdouble ratio, radians, wd2;
	GLdouble near, far, top, bottom, left, right;
	near = 0.00001;
	far = 100;
	near = 1.0;
	
	radians = 0.0174532925 * camera->aperture / 2; // half aperture degrees to radians 
	wd2 = near * tan(radians);
	ratio = camera->viewWidth / (float) camera->viewHeight;
	if (ratio >= 1.0) {
		left  = -ratio * wd2;
		right = ratio * wd2;
		top = wd2;
		bottom = -wd2;	
	} else {
		left  = -wd2;
		right = wd2;
		top = wd2 / ratio;
		bottom = -wd2 / ratio;	
	}
	glFrustum (left, right, bottom, top, near, far);
}
	

- (void) updateModelView
{
	glMatrixMode( GL_MODELVIEW );
	glLoadIdentity(); 
	gluLookAt (camera->viewPos.x, camera->viewPos.y, camera->viewPos.z,
			   camera->viewPos.x + camera->viewDir.x,
			   camera->viewPos.y + camera->viewDir.y,
			   camera->viewPos.z + camera->viewDir.z,
			   camera->viewUp.x, camera->viewUp.y ,camera->viewUp.z);
	
	if (mouseHandler)
		[mouseHandler operateWorldTransform];
}

- (void) draw
{
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	glColor3f(1.0f, 0.85f, 0.35f); glBegin(GL_TRIANGLES); { glVertex3f( 0.0, 0.6, 0.0); glVertex3f( -0.2, -0.3, 0.0); glVertex3f( 0.2, -0.3 ,0.0); } glEnd(); 
}


-(void) drawRect: (NSRect) bounds 
{
    // Add your drawing codes here
	
	NSOpenGLContext	*currentContext = [self openGLContext];
	[currentContext makeCurrentContext];
	
	// remember to lock the context before we touch it since display link is threaded
	CGLLockContext((CGLContextObj)[currentContext CGLContextObj]);
	
	
	[self resizeGL];
	[self updateProjection];
	[self updateModelView];
	
	glEnable( GL_DEPTH_TEST );
	
	[self draw];
	
	[currentContext flushBuffer];
	
	CGLUnlockContext((CGLContextObj)[currentContext CGLContextObj]);
} 


- (void)setFrameSize:(NSSize)newSize
{
	[super setFrameSize: newSize];
}

- (void)setFrame:(NSRect)frameRect
{
	[super setFrame: frameRect];
}

// ---------------------------------

- (void)mouseDown:(NSEvent *)theEvent // trackball
{
	if(mouseHandler)
		[mouseHandler mouseDown:theEvent];
}

// ---------------------------------

- (void)rightMouseDown:(NSEvent *)theEvent // pan
{
	if(mouseHandler)
		[mouseHandler rightMouseDown:theEvent];
}

// ---------------------------------

- (void)otherMouseDown:(NSEvent *)theEvent //dolly
{
	if(mouseHandler)
		[mouseHandler otherMouseDown:theEvent];
}

// ---------------------------------

- (void)mouseUp:(NSEvent *)theEvent
{
	if(mouseHandler)
		[mouseHandler mouseUp:theEvent];
}

// ---------------------------------

- (void)rightMouseUp:(NSEvent *)theEvent
{
	if(mouseHandler)
		[mouseHandler rightMouseUp:theEvent];
}

// ---------------------------------

- (void)otherMouseUp:(NSEvent *)theEvent
{
	if(mouseHandler)
		[mouseHandler otherMouseUp:theEvent];
}

// ---------------------------------

- (void)mouseDragged:(NSEvent *)theEvent
{
	if(mouseHandler)
		[mouseHandler mouseDragged:theEvent];
}

// ---------------------------------

- (void)scrollWheel:(NSEvent *)theEvent
{
	if(mouseHandler)
		[mouseHandler scrollWheel:theEvent];
}

// ---------------------------------

- (void)rightMouseDragged:(NSEvent *)theEvent
{
	if(mouseHandler)
		[mouseHandler rightMouseDragged:theEvent];
}

// ---------------------------------

- (void)otherMouseDragged:(NSEvent *)theEvent
{
	if(mouseHandler)
		[mouseHandler otherMouseDragged:theEvent];
}

@end
