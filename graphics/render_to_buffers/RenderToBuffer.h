//
//  RenderToBuffer.h
//  OpenGLShader
//
//  Created by Serato on 4/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include "Shader.h"

@class RenderObject;

@interface RenderToBuffer : NSObject {
	NSString* fsPath;
	NSString* vsPath;
	Shader* shader;
	bool shaderRequiresCompile;
	
	RenderObject* currentRenderObject;
	
	unsigned int numVertices;
	unsigned int vertexBufferRef;
	unsigned int normalBufferRef;
	unsigned int colourBufferRef;
	
	int vertexTex;
	int colorTex;
	int normalTex;
	
	int renderWidth;
	int renderHeight;
	int renderOverrun;
}

-(id) initWithPathToFragmentShader: (NSString*) fragmentPath andVertexShader:(NSString*) vertexPath;
-(void) dealloc;

-(void) recompileShader;

-(void) setRenderObject: (RenderObject*) object;

// protected
// override this to get shader locations needed for the particular shader used
-(void)getShaderLocations;

// performs the actual render. call after other setup has been completed
-(void)render;

//  override to set particular shader variables
-(void)setupShader;

// private
-(void)createShaders;



@end
