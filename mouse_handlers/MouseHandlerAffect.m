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
	NSRect  bounds = [glView bounds];
	affectPoint.x = 2.0*locationInView.x/(bounds.size.width) - 1.0;
	affectPoint.y = 2.0*locationInView.y/(bounds.size.height) - 1.0;
	if(affectPoint.x < -1.0)
		affectPoint.x = -1.0;
	if(affectPoint.x > 1.0)
		affectPoint.x = 1.0;
	if(affectPoint.y < -1.0)
		affectPoint.y = -1.0;
	if(affectPoint.y > 1.0)
		affectPoint.y = 1.0;
}

- (void) mouseDown:(NSEvent *)theEvent
{
	mouseIsDown = true;
	[self updateAffectPointWithLocation:[theEvent locationInWindow]];
	[glView setNeedsDisplay: YES];
}

- (void) mouseUp:(NSEvent *)theEvent
{
	mouseIsDown = false;
}

- (void) mouseDragged:(NSEvent *)theEvent
{
	[self updateAffectPointWithLocation:[theEvent locationInWindow]];
	[glView setNeedsDisplay: YES]; 
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
