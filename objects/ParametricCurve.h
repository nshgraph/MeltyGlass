//
//  ParametricCurve.h
//  BezierParser
//
//  Created by Nathan Holmberg on 15/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ParametricCurve : NSObject {

}

-(NSPoint) pointOnCurve:(double) t;

-(NSPoint) tangentOnCurve:(double) t;

@end
