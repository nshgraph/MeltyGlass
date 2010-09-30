//
//  MeltyGlassOpenGLView.m
//  MeltyGlass
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MeltyGlassOpenGLView.h"
#import "Path.h"
#import "BezierCurve.h"
#import "HalfCircle.h"
#import "SurfaceOfRevolution.h"

#import "RenderObject.h"

#import "RenderMode.h"
#import "RenderModeWireframe.h"
#import "RenderModeWithShader.h"

#import "CubeMap.h"

#import "GlassProfileCurve.h"

@implementation MeltyGlassOpenGLView


- (void) initializeView
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	Path* path = [[[Path alloc] init] autorelease];
	// add all the curves
	NSPoint points[20];
	int count = 0;
	for( int i = 0; i < 14; i++ ){
		points[0].x = glass_profile_curve[i][0];
		points[0].y = glass_profile_curve[i][1];
		points[1].x = glass_profile_curve[i][2];
		points[1].y = glass_profile_curve[i][3];
		points[2].x = glass_profile_curve[i][4];
		points[2].y = glass_profile_curve[i][5];
		points[3].x = glass_profile_curve[i][6];
		points[3].y = glass_profile_curve[i][7];
		
		count = 4;
		BezierCurve* curve = [[[BezierCurve alloc] initWithControlPoints:points withCount:count] autorelease];
		[path addCurveToPath: curve];
	}
	// Create the surface we wish to draw
	ParametricSurface* surface = [[SurfaceOfRevolution alloc] initWithPathObj:path];
	// and the render object (which has the actual vertices in it
	mObjects[OBJ_GLASS1] = [surface createRenderObjectWithResT: 256 andResS: 64];
	[mObjects[OBJ_GLASS1] retain];
	[surface release];
	
	Path* path2 = [[[Path alloc] init] autorelease];
	// add all the curves
	count = 0;
	for( int i = 0; i < 8; i++ ){
		points[0].x = glass_profile_curve_2[i][0];
		points[0].y = glass_profile_curve_2[i][1];
		points[1].x = glass_profile_curve_2[i][2];
		points[1].y = glass_profile_curve_2[i][3];
		points[2].x = glass_profile_curve_2[i][4];
		points[2].y = glass_profile_curve_2[i][5];
		points[3].x = glass_profile_curve_2[i][6];
		points[3].y = glass_profile_curve_2[i][7];
		
		count = 4;
		BezierCurve* curve = [[[BezierCurve alloc] initWithControlPoints:points withCount:count] autorelease];
		[path2 addCurveToPath: curve];
	}
	
	// Create the surface we wish to draw
	surface = [[SurfaceOfRevolution alloc] initWithPathObj:path2];
	// and the render object (which has the actual vertices in it
	mObjects[OBJ_GLASS2] = [surface createRenderObjectWithResT: 256 andResS: 64];
	[mObjects[OBJ_GLASS2] retain];
	[surface release];
	
	
	HalfCircle* circle = [[[HalfCircle alloc] initWithRadius: 0.5] autorelease];
	surface = [[SurfaceOfRevolution alloc] initWithPathObj:circle];
	// and the render object (which has the actual vertices in it
	mObjects[OBJ_SPHERE] = [surface createRenderObjectWithResT: 256 andResS: 64];
	[mObjects[OBJ_SPHERE] retain];
	[surface release];
	
	
	// create each render mode
	mModes[MODE_WIREFRAME] = [[RenderModeWireframe alloc] init];
	mModes[MODE_LIGHTING] = [[RenderMode alloc] init];
	// we need to pass the correct paths for the transparent (refractive) shader
	NSString* refractiveFSPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Refractive.FS"];
	NSString* refractiveVSPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Refractive.VS"];
	
	mModes[MODE_TRANSPARENT] = [[RenderModeWithShader alloc] initWithPathToFragmentShader:refractiveFSPath andVertexShader:refractiveVSPath];
	
	NSString* palacePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/CubeMaps/SwedishRoyalCastle/"];
	CubeMap* palaceCubeMap = [[CubeMap alloc] initWithPath: palacePath];
	[((RenderModeWithShader*)mModes[MODE_TRANSPARENT]) setCubeMap: palaceCubeMap];
	
	mModeIndex = MODE_WIREFRAME;
	mObjectIndex = OBJ_GLASS1;
	
	glEnable(GL_DEPTH_TEST);
	
	glShadeModel(GL_SMOOTH);    
//	glEnable(GL_CULL_FACE);
	glFrontFace(GL_CW);
	glPolygonOffset (1.0f, 1.0f);
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	[pool release];
}

-(void)dealloc
{
	[mObjects[OBJ_GLASS1] release];
	[mObjects[OBJ_GLASS2] release];
	[mObjects[OBJ_SPHERE] release];
	
	[mModes[MODE_WIREFRAME] release];
	[mModes[MODE_LIGHTING] release];
	[mModes[MODE_TRANSPARENT] release];
	
	
	[super dealloc];
}

- (void) draw
{
	glColor3f(0.8,0.8,0.8);
	
	glTranslatef( 0.0 , 0.0, -0.50 );
	int mode_index = mModeIndex;
	int obj_index = mObjectIndex;
	[mModes[mode_index] renderStart];
	[mObjects[obj_index] renderWithColor];
	[mModes[mode_index] renderEnd];
}


- (void) setMode: (int) mode
{
	if( mode >= 0 && mode < MODE_NUM_MODES )
		mModeIndex = mode;
}

- (void) setObject: (int) obj
{
	if( obj >= 0 && obj < OBJ_NUM_OBJECTS )
		mObjectIndex = obj;
}

- (void) reloadShader
{
	// reloads the shader objects so that we can debug on the fly
	[mModes[MODE_LIGHTING] reload];
	[mModes[MODE_TRANSPARENT] reload];
}

@end
