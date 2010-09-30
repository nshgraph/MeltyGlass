//
//  HalfCircle.h
//  MeltyGlass
//
//  Created by nathanholmberg on 6/09/10.
//  Copyright 2010 Serato Audio Research. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ParametricCurve.h"

@interface HalfCircle : ParametricCurve {
	double mRadius;
}

-(id) initWithRadius: (double) radius;

-(NSPoint) pointOnCurve:(double) t;

-(NSPoint) tangentOnCurve:(double) t;

@end
