//
//  MouseHandlerTrackball.h
//  OpenGLShader
//
//  Created by Serato on 1/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MouseHandler.h"


typedef struct {
	GLdouble x,y,z;
} recVec;

typedef struct MHCamera {
	recVec viewPos; // View position
	recVec viewDir; // View direction vector
	recVec viewUp; // View up direction
	recVec rotPoint; // Point to rotate about
	GLdouble aperture; // pContextInfo->camera aperture
	GLint viewWidth, viewHeight; // current window/screen height and width
	bool projectionNeedsUpdate;
} MHCamera;

@interface MouseHandlerTrackball : MouseHandler {
	MHCamera* camera;
	NSOpenGLView* glView;
	
	int smsType;
	bool verticalAlign;
	
	GLfloat worldRotation [4];
	GLfloat objectRotation [4];
	float ssmAxis[3];
	
	bool panEnabled;
}

-(id)initWithCamera:(MHCamera*) camera andView:(NSOpenGLView*) view;

-(void)mouseDolly: (NSPoint) location;

-(void)mousePan: (NSPoint) location;

-(void)addRotation:(float*) rotation;

-(void)operateWorldTransform;

-(void)operateObjectTransform;

-(void)getAxis:(float*) axis;

@end
