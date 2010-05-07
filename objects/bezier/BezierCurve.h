//
//  BezierCurve.h
//  BezierParser
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ParametricCurve.h"
#import "Path.h"


@interface BezierCurve : ParametricCurve {
	NSMutableArray* mControlPoints;
}

-(id) initWithControlPoints:(NSPoint*) points withCount:(int) num_points;

-(NSPoint) pointOnCurve:(double) t;

-(NSPoint) tangentOnCurve:(double) t;

+(Path*) parseBezierPath:(NSURL*)url_to_path;

@end
