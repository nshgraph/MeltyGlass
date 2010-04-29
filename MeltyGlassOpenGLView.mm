//
//  MeltyGlassOpenGLView.m
//  MeltyGlass
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MeltyGlassOpenGLView.h"
#import "Path.h"
#import "BezierCurve.h"
#import "SurfaceOfRevolution.h"

#import "GlassProfileCurve.h"

@implementation MeltyGlassOpenGLView


- (void) initializeView
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	Path* path = [[[Path alloc] init] autorelease];
	// add all the curves
	NSPoint points[20];
	int count = 0;
	for( int i = 0; i < 14; i++ ){
		points[0].x = glass_profile_curve[i][0];
		points[0].y = 160 - glass_profile_curve[i][1];
		points[1].x = glass_profile_curve[i][2];
		points[1].y = 160 - glass_profile_curve[i][3];
		points[2].x = glass_profile_curve[i][4];
		points[2].y = 160 - glass_profile_curve[i][5];
		points[3].x = glass_profile_curve[i][6];
		points[3].y = 160 - glass_profile_curve[i][7];
		
		count = 4;
		BezierCurve* curve = [[[BezierCurve alloc] initWithControlPoints:points withCount:count] autorelease];
		[path addCurveToPath: curve];
	}
	
	mSurface = [[SurfaceOfRevolution alloc] initWithPathObj:path];
	[mSurface retain];
	[pool release];
}


- (void) draw
{
	glTranslatef( -0.75 , 0.0, 0.0 );
	int resx = 256;
	int resy = 64;
	glColor3f(0.8,0.8,0.8);
	for(int i=0; i <= resx; i++ )
	{
		glBegin( GL_POINTS );
		for( int j = 0; j <= resy; j++ )
		{
			NSPoint3 point = [mSurface pointOnSurfaceT: i/(double)resx S: j/(double)resy];
			glVertex3f( point.x, point.y, point.z );
		}
		glEnd();
	}
	
}

@end
