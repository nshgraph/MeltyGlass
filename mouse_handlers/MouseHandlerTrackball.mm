//
//  MouseHandlerTrackball.m
//  OpenGLShader
//
//  Created by Serato on 1/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import "MouseHandlerTrackball.h"

#import <OpenGL/OpenGL.h>
#import <OpenGL/glu.h>

#import "trackball.h"

#define crossProduct(a,b,c) \
(a)[0] = (b)[1] * (c)[2] - (c)[1] * (b)[2]; \
(a)[1] = (b)[2] * (c)[0] - (c)[2] * (b)[0]; \
(a)[2] = (b)[0] * (c)[1] - (c)[0] * (b)[1];


@implementation MouseHandlerTrackball


// single set of interaction flags and states
GLint gDollyPanStartPoint[2] = {0, 0};
GLfloat gTrackBallRotation [4] = {0.0f, 0.0f, 0.0f, 0.0f};
GLboolean gDolly = GL_FALSE;
GLboolean gPan = GL_FALSE;
GLboolean gTrackball = GL_FALSE;
MouseHandler * gTrackingViewInfo = NULL;

-(id)initWithCamera:(MHCamera*) cameraRef andView:(NSOpenGLView*) view;
{
	self = [super init];
	glView = view;
	camera = cameraRef;
	
	ssmAxis[0] = 0;
	ssmAxis[1] = 3.1415;
	ssmAxis[2] = 0;
	
	panEnabled = false;
	
	return self;
}


// ---------------------------------

- (void)mouseDown:(NSEvent *)theEvent // trackball
{
    if ([theEvent modifierFlags] & NSControlKeyMask) // send to pan
		[self rightMouseDown:theEvent];
	else if ([theEvent modifierFlags] & NSAlternateKeyMask) // send to dolly
		[self otherMouseDown:theEvent];
	else {
		NSPoint location = [glView convertPoint:[theEvent locationInWindow] fromView:nil];
		location.y = camera->viewHeight - location.y;
		gDolly = GL_FALSE; // no dolly
		gPan = GL_FALSE; // no pan
		gTrackball = GL_TRUE;
		startTrackball (location.x, location.y, 0, 0, camera->viewWidth, camera->viewHeight);
		gTrackingViewInfo = self;
	}
}

// ---------------------------------

- (void)rightMouseDown:(NSEvent *)theEvent // pan
{
	if( !panEnabled )
		return;
	NSPoint location = [glView convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = camera->viewHeight - location.y;
	if (gTrackball) { // if we are currently tracking, end trackball
		if (gTrackBallRotation[0] != 0.0)
			addToRotationTrackball (gTrackBallRotation, worldRotation);
		gTrackBallRotation [0] = gTrackBallRotation [1] = gTrackBallRotation [2] = gTrackBallRotation [3] = 0.0f;
	}
	gDolly = GL_FALSE; // no dolly
	gPan = GL_TRUE; 
	gTrackball = GL_FALSE; // no trackball
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
	gTrackingViewInfo = self;
}

// ---------------------------------

- (void)otherMouseDown:(NSEvent *)theEvent //dolly
{
	NSPoint location = [glView convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = camera->viewHeight - location.y;
	if (gTrackball) { // if we are currently tracking, end trackball
		if (gTrackBallRotation[0] != 0.0)
			addToRotationTrackball (gTrackBallRotation, worldRotation);
		gTrackBallRotation [0] = gTrackBallRotation [1] = gTrackBallRotation [2] = gTrackBallRotation [3] = 0.0f;
	}
	gDolly = GL_TRUE;
	gPan = GL_FALSE; // no pan
	gTrackball = GL_FALSE; // no trackball
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
	gTrackingViewInfo = self;
}

// ---------------------------------

- (void)mouseUp:(NSEvent *)theEvent
{
	if (gDolly) { // end dolly
		gDolly = GL_FALSE;
	} else if (gPan) { // end pan
		gPan = GL_FALSE;
	} else if (gTrackball) { // end trackball
		gTrackball = GL_FALSE;
		if (gTrackBallRotation[0] != 0.0)
			addToRotationTrackball (gTrackBallRotation, worldRotation);
		gTrackBallRotation [0] = gTrackBallRotation [1] = gTrackBallRotation [2] = gTrackBallRotation [3] = 0.0f;
	} 
	gTrackingViewInfo = NULL;
}

// ---------------------------------

- (void)rightMouseUp:(NSEvent *)theEvent
{
	[self mouseUp:theEvent];
}

// ---------------------------------

- (void)otherMouseUp:(NSEvent *)theEvent
{
	[self mouseUp:theEvent];
}

// ---------------------------------

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint location = [glView convertPoint:[theEvent locationInWindow] fromView:nil];
	location.y = camera->viewHeight - location.y;
	if (gTrackball) {
		rollToTrackball (location.x, location.y, gTrackBallRotation);
		[glView setNeedsDisplay: YES];
	} else if (gDolly) {
		[self mouseDolly: location];
		camera->projectionNeedsUpdate = true;
		[glView setNeedsDisplay: YES];
	} else if (gPan) {
		[self mousePan: location];
		[glView setNeedsDisplay: YES];
	}
}

// ---------------------------------

- (void)scrollWheel:(NSEvent *)theEvent
{
	float wheelDelta = [theEvent deltaX] +[theEvent deltaY] + [theEvent deltaZ];
	if (wheelDelta)
	{
		GLfloat deltaAperture = wheelDelta * -camera->aperture / 200.0f;
		camera->aperture += deltaAperture;
		if (camera->aperture < 0.1) // do not let aperture <= 0.1
			camera->aperture = 0.1;
		if (camera->aperture > 179.9) // do not let aperture >= 180
			camera->aperture = 179.9;
		camera->projectionNeedsUpdate = true;
		[glView setNeedsDisplay: YES];
	}
}

// ---------------------------------

- (void)rightMouseDragged:(NSEvent *)theEvent
{
	[self mouseDragged: theEvent];
}

// ---------------------------------

- (void)otherMouseDragged:(NSEvent *)theEvent
{
	[self mouseDragged: theEvent];
}


// move camera in z axis
-(void)mouseDolly: (NSPoint) location
{
	GLfloat dolly = (gDollyPanStartPoint[1] -location.y) * -camera->viewPos.z / 300.0f;
	camera->viewPos.z += dolly;
	if (camera->viewPos.z == 0.0) // do not let z = 0.0
		camera->viewPos.z = 0.0001;
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
}

// ---------------------------------

// move camera in x/y plane
- (void)mousePan: (NSPoint) location
{
	GLfloat panX = (gDollyPanStartPoint[0] - location.x) / (900.0f / -camera->viewPos.z);
	GLfloat panY = (gDollyPanStartPoint[1] - location.y) / (900.0f / -camera->viewPos.z);
	camera->viewPos.x -= panX;
	camera->viewPos.y -= panY;
	gDollyPanStartPoint[0] = location.x;
	gDollyPanStartPoint[1] = location.y;
}

-(void)addRotation:(float*) rotation
{
	addToRotationTrackball(rotation,objectRotation);
}

-(void)operateWorldTransform
{	
	if((gTrackingViewInfo == self) && gTrackBallRotation[0] != 0.0f)
		glRotatef (gTrackBallRotation[0], gTrackBallRotation[1], gTrackBallRotation[2], gTrackBallRotation[3]);
	
	// accumlated world rotation via trackball
	glRotatef (worldRotation[0], worldRotation[1], worldRotation[2], worldRotation[3]);
	// object itself rotating applied after camera rotation
	glRotatef (objectRotation[0], objectRotation[1], objectRotation[2], objectRotation[3]);
}

-(void)operateObjectTransform
{
	
	if((gTrackingViewInfo == self) && gTrackBallRotation[0] != 0.0f)
		glRotatef (gTrackBallRotation[0], gTrackBallRotation[1], gTrackBallRotation[2], gTrackBallRotation[3]);
	
	// accumlated world rotation via trackball
	glRotatef (worldRotation[0], worldRotation[1], worldRotation[2], worldRotation[3]);
	// object itself rotating applied after camera rotation
	glRotatef (objectRotation[0], objectRotation[1], objectRotation[2], objectRotation[3]);
}

-(void) operate
{
	[self operateWorldTransform];
}

-(void)getAxis:(float*) axis
{
	axis[0] = ssmAxis[0];
	axis[1] = ssmAxis[1];
	axis[2] = ssmAxis[2];
}

// ---------------------------------

@end
