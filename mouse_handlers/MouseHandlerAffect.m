//
//  MouseHandlerAffect.m
//  OpenGLShader
//
//  Created by Serato on 2/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import "MouseHandlerAffect.h"

#import <OpenGL/OpenGL.h>


@implementation MouseHandlerAffect

-(id)initWithView:(NSOpenGLView*) view
{
	self = [super init];
	
	mouseIsDown = false;
	glView = view;
	
	return self;
}

-(void)updateAffectPointWithLocation:(NSPoint) location
{
	NSPoint locationInView = [glView convertPoint:location fromView:nil];
	affectPoint.x = locationInView.x;
	affectPoint.y = locationInView.y;
}

- (void)mouseDown:(NSEvent *)theEvent // trackball
{
    if ([theEvent modifierFlags] & NSControlKeyMask) // send to pan
		[self rightMouseDown:theEvent];
	else if ([theEvent modifierFlags] & NSAlternateKeyMask) // send to dolly
		[self otherMouseDown:theEvent];
}


- (void)mouseUp:(NSEvent *)theEvent // trackball
{
    if ([theEvent modifierFlags] & NSControlKeyMask) // send to pan
		[self rightMouseUp:theEvent];
	else if ([theEvent modifierFlags] & NSAlternateKeyMask) // send to dolly
		[self otherMouseUp:theEvent];
	
	mouseIsDown = false;
}

- (void) rightMouseDown:(NSEvent *)theEvent
{
	mouseIsDown = true;
	[self updateAffectPointWithLocation:[theEvent locationInWindow]];
	[glView setNeedsDisplay: YES];
}

- (void) rightMouseUp:(NSEvent *)theEvent
{
}

- (void) mouseDragged:(NSEvent *)theEvent
{
	if( mouseIsDown )
	{
		[self updateAffectPointWithLocation:[theEvent locationInWindow]];
		[glView setNeedsDisplay: YES]; 
	}
}

-(bool) isActive
{
	return mouseIsDown;
}

-(NSPoint) getPoint
{
	return affectPoint;
}

-(void) operate
{
	if(!mouseIsDown)
		return;
	
	glPushMatrix();
	glLoadIdentity();

	glColor3f(1.0,1.0,1.0);
	glPointSize(10.0);
	glBegin(GL_POINTS);
	glVertex3f(affectPoint.x/1.4,affectPoint.y/1.4,-2.0);
	glEnd();
	
	glPopMatrix();
}

@end
