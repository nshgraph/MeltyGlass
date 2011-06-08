//
//  SurfaceOfRevolution.h
//  BezierParser
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ParametricSurface.h"

@class ParametricCurve;

@interface SurfaceOfRevolution : ParametricSurface {
	ParametricCurve* mPath;
}

-(id) initWithParametricCurve: (ParametricCurve*) path;

-(NSPoint3) pointOnSurfaceT:(double) t S:(double) s;

-(NSPoint3) normalOnSurfaceT:(double) t S:(double) s;

@end
