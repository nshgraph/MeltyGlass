//
//  SurfaceOfRevolution.m
//  BezierParser
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "SurfaceOfRevolution.h"
#import "Path.h"

@implementation SurfaceOfRevolution

-(id) initWithPathObj: (Path*) path
{
	self = [super init];
	if( self )
	{
		mPath = path;
		[mPath retain];
	}
	return self;
}

-(void)dealloc
{
	[mPath release];
	[super dealloc];
}

-(NSPoint3) pointOnSurfaceT:(double) t S:(double) s
{
	NSPoint3 ret;
	ret.x = 0;
	ret.y = 0;
	ret.z = 0;
	if( mPath )
	{
		NSPoint onPath = [mPath pointOnCurve: t];
		ret.x = onPath.x / 500;
		ret.y = onPath.y * cos( 2 * pi * s ) / 500;
		ret.z = onPath.y * sin( 2 * pi * s ) / 500;
	}
	return ret;
}

@end
