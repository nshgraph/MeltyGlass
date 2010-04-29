//
//  ParametricSurface.h
//  BezierParser
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct _NSPoint3 {
	CGFloat x;
	CGFloat y;
	CGFloat z;
} NSPoint3;


@interface ParametricSurface : NSObject {

}


-(NSPoint3) pointOnSurfaceT:(double) t S:(double) s;

@end
