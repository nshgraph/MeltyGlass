//
//  RenderToBuffer.h
//  OpenGLShader
//
//  Created by Serato on 4/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RenderObject.h"

@class RenderObject;

@interface RenderToBuffer : NSObject {
	NSString* fsPath;
	NSString* vsPath;
	bool shaderRequiresCompile;
	
	unsigned int numVertices;
	unsigned int vertexBufferRef;
	unsigned int normalBufferRef;
	unsigned int colourBufferRef;
	
	int vertexTex;
	int colorTex;
	int normalTex;
}

-(id) initWithPathToFragmentShader: (NSString*) fragmentPath andVertexShader:(NSString*) vertexPath;
-(void) dealloc;

-(void) setBuffersOfSize: (unsigned int) numberOfElements WithVertices: (unsigned int) verticesRef andNormals: (unsigned int) normalsRef andColour: (unsigned int) colourRef;

-(void) recompileShader;

-(void)render;


// private
-(void)setupShader;
-(void)createFBO;
-(void)createShaders;
-(void) getShaderLocations;

@end
