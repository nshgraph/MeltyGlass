//
//  ParametricCurve.m
//  BezierParser
//
//  Created by Nathan Holmberg on 15/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ParametricCurve.h"


@implementation ParametricCurve

// This method should bo overridden by sub-classes 
-(NSPoint) pointOnCurve:(double) t
{
	NSPoint ret = NSMakePoint(0,0);
	return ret;
}

// This method should bo overridden by sub-classes
-(NSPoint) tangentOnCurve:(double) t
{
	NSPoint ret = NSMakePoint(0,0);
	return ret;
}

@end
