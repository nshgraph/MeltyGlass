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
		ret.x = onPath.y * cos( 2 * pi * s );
		ret.y = onPath.y * sin( 2 * pi * s );
		ret.z = onPath.x;
	}
	return ret;
}


-(NSPoint3) normalOnSurfaceT:(double) t S:(double) s
{
	NSPoint3 ret;
	ret.x = 0;
	ret.y = 1;
	ret.z = 0;
	double sx = cos(2*pi*(s));
	double sy = sin(2*pi*(s));
	if( mPath )
	{
		NSPoint onPath = [mPath tangentOnCurve: t];
		
		ret.x = onPath.x * sx;
		ret.y = onPath.x * sy;
		ret.z = onPath.y;
		
	}
	
	double len = sqrt( ret.x*ret.x + ret.y*ret.y + ret.z*ret.z );
	ret.x /= len;
	ret.y /= len;
	ret.z /= len;
	
	return ret;
}

@end
