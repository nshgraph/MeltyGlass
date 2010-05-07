//
//  Path.m
//  BezierParser
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Path.h"


@implementation Path

-(id) init
{
	self = [super init];
	if( self )
	{
		mCurves = [[NSMutableArray alloc] initWithCapacity: 5];
	}
	return self;
}

-(void) dealloc
{
	[mCurves release];
	
	[super dealloc];
}


-(void) addCurveToPath:(ParametricCurve*) curve
{
	[mCurves addObject: curve];
}

-(NSPoint) pointOnCurve:(double) t
{
	int curve = t * [mCurves count];
	// for rounding errors
	if( curve >= [mCurves count] )
		curve = [mCurves count] - 1;
	
	double newT = (t * [mCurves count] - curve);
	
	ParametricCurve* pCurve = (ParametricCurve*)[mCurves objectAtIndex: curve];
	NSPoint ret = [pCurve pointOnCurve: newT];
	return ret;
}

-(NSPoint) tangentOnCurve:(double) t
{
	int curve = t * [mCurves count];
	// for rounding errors
	if( curve >= [mCurves count] )
		curve = [mCurves count] - 1;
	
	double newT = (t * [mCurves count] - curve);
	
	ParametricCurve* pCurve = (ParametricCurve*)[mCurves objectAtIndex: curve];
	NSPoint ret = [pCurve tangentOnCurve: newT];
	return ret;
}

@end
