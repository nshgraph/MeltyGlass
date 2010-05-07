//
//  BezierCurve.m
//  BezierParser
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
// From: http://www.google.com/codesearch/p?hl=en#JpXf-jMBcgs/nurbs/programs/chap2all.tar.gz|hfAGKpuWZa8/bezier.c&q=bezier
//

#import "BezierCurve.h"

int factorial(int n)
{
	for(int i = n-1; i>1; i--)
		n *= i;
	return n;
}

int coefficient(int i, int n)
{
	if( i==0 || i == n )
		return 1;
	return factorial(n) / (double)(factorial(i)*factorial(n-i));
}
	
double Basis(int n,int i,float t)
{ 
	return coefficient(i, n) * pow(t,i) * pow(1.0 - t, n-i);
}

double Basis_Derv(int n,int i,float t)
{ 
	switch( i )
	{
		case 0:
			return -3*(1-t)*(1-t);
		case 1:
			return -6*t*(1-t) + 3*(1-t)*(1-t);
		case 2:
			return -3*t*t + 6*t*(1-t);
		case 3:
			return 3*t*t;
	}
	return 0;
}




@implementation BezierCurve




-(id) initWithControlPoints:(NSPoint*) points withCount:(int) num_points
{
	self = [super init];
	if( self )
	{
		mControlPoints = [[NSMutableArray alloc] initWithCapacity: num_points];
		for(int i=0; i < num_points; i++)
		{
			[mControlPoints addObject: [NSValue valueWithPoint:points[i]]];
		}
	}
	return self;
}

-(void) dealloc
{
	[mControlPoints release];
	
	[super dealloc];
}

-(NSPoint) pointOnCurve:(double) t
{
	NSPoint ret = NSMakePoint(0,0);
	double bern;
	for( int i=0; i < [mControlPoints count]; i++ )
	{
		bern = Basis([mControlPoints count]-1, i, t);
		ret.x += [[mControlPoints objectAtIndex: i] pointValue].x * bern;
		ret.y += [[mControlPoints objectAtIndex: i] pointValue].y * bern;
	}
	return ret;
}

// This method should bo overridden by sub-classes
-(NSPoint) tangentOnCurve:(double) t
{
	NSPoint ret = NSMakePoint(0,0);
	double bern;
	for( int i=0; i < [mControlPoints count]; i++ )
	{
		bern = Basis_Derv([mControlPoints count], i, t);
		ret.x += [[mControlPoints objectAtIndex: i] pointValue].x * bern;
		ret.y -= [[mControlPoints objectAtIndex: i] pointValue].y * bern;
	}
	return ret;
}


+(Path*) parseBezierPath:(NSURL*)url_to_path
{
	Path* path = [[Path alloc] init];
	return path;
}


@end
