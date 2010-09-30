//
//  HalfCircle.m
//  MeltyGlass
//
//  Created by nathanholmberg on 6/09/10.
//  Copyright 2010 Serato Audio Research. All rights reserved.
//

#import "HalfCircle.h"


@implementation HalfCircle


-(id) initWithRadius: (double) radius
{
	self = [super init];
	if( self )
	{
		mRadius = radius;
	}
	return self;
}

-(NSPoint) pointOnCurve:(double) t
{
	NSPoint ret = NSMakePoint(0,0);
	
	ret.x = mRadius * cos( pi * t ) + mRadius;
	ret.y = mRadius * sin( pi * t );
	
	return ret;
}

-(NSPoint) tangentOnCurve:(double) t
{
	NSPoint ret = NSMakePoint(0,0);
	
	ret.y = cos( pi * t );
	ret.x= sin( pi * t );
	
	return ret;
}

@end
