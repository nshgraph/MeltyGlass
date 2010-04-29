//
//  Path.h
//  BezierParser
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ParametricCurve.h"


@interface Path : ParametricCurve {
	NSMutableArray* mCurves;
}

-(id) init;

-(void) addCurveToPath:(ParametricCurve*) curve;

-(NSPoint) pointOnCurve:(double) t;


@end
