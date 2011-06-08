//
//  Melt.mm
//  MeltyGlass
//
//  Created by nathanholmberg on 8/09/10.
//  Copyright 2010 Serato Audio Research. All rights reserved.
//

#import "Melt.h"

#import <OpenGL/OpenGL.h>
#import <OpenGL/glu.h>


@implementation Melt

-(id) init
{	
	// we need to pass the correct paths for the transparent (refractive) shader
	NSString* meltFSPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Feedback.FS"];
	NSString* meltVSPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Feedback.VS"];
	
	
	self = [super initWithPathToFragmentShader: meltFSPath  andVertexShader: meltVSPath ];
	

	infinity.x = 10000;
	infinity.y = 10000;
	
	return self;
	
}


-(void)renderWithDeltaTime:(float) delta
{
	[self renderWithDeltaTime: delta andAffectPoint: infinity];
}

-(void)renderWithDeltaTime:(float) delta andAffectPoint:(NSPoint) affect
{
	// these will be picked up again in the 'setup shader' method to be passed on to the particular shader variables
	currentAffectPoint = affect;
	currentDeltaTime = delta;
	[self render];
}

// overriden methods
-(void) getShaderLocations
{
	pointLocation = shader->getVariableLocation("affect");
	gravityLocation = shader->getVariableLocation("gravity");
	timeLocation = shader->getVariableLocation("deltaTime");
	colourLocation = shader->getVariableLocation("colourTex");
	vertexLocation = shader->getVariableLocation("vertexTex");
	normalLocation = shader->getVariableLocation("normalTex");
}

-(void)setupShader
{
	
	GLint viewport[4]; //var to hold the viewport info
	GLdouble projection[16];
	GLdouble modelview[16];                
	GLdouble farv[3]; //variables to hold screen x,y,z coordinates
	GLfloat winZ;

	glGetDoublev(GL_MODELVIEW_MATRIX, (GLdouble*)&modelview);
	glGetDoublev(GL_PROJECTION_MATRIX, (GLdouble*)&projection);   
	glGetIntegerv( GL_VIEWPORT, viewport ); //get the viewport info
	glReadPixels(currentAffectPoint.x, currentAffectPoint.y, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &winZ);
	
	if( winZ > 0.99 ) // i.e we missed
		winZ = 0.8; // a better approximation
	
	gluUnProject( currentAffectPoint.x, currentAffectPoint.y, winZ, modelview, projection, viewport, &farv[0], &farv[1], &farv[2]);
	
	float gravity[3];
	gravity[0] = modelview[1];
	gravity[1] = modelview[5];
	gravity[2] = modelview[9];
	
	if(shader)
	{
		shader->setFloat3Variable( pointLocation, farv[0], farv[1], farv[2] );
		shader->setFloat3Variable( gravityLocation, gravity[0],gravity[1],gravity[2] );
		shader->setFloatVariable( timeLocation, currentDeltaTime );
		shader->setIntVariable( colourLocation, 0);
		shader->setIntVariable( vertexLocation, 1);
		shader->setIntVariable( normalLocation, 2);
	}
}

@end
