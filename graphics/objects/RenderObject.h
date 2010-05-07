//
//  RenderObject.h
//  BezierParser
//
//  Created by Nathan Holmberg on 2/05/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RenderObject : NSObject {
	bool isValid;
	bool isCompiled;
	
	bool hasTexCoords;
	unsigned int drawRef;
	unsigned int colorRef;
	unsigned int normalRef;
	
	int numberVerts;
	float* vertices;
	float* normals;
}

-(bool) isValid;
-(bool) isCompiled;
-(int) numberVerts;
-(unsigned int) drawRef;
-(unsigned int) normalRef;
-(unsigned int) colorRef;

-(void) invalidate;

- (id)init;

-(void)createWithVertices:(float*)vertexArray andNormals:(float*) normalArray ofSize:(int)vertexCount;

-(void)compile;

-(void)drawCommand;

-(void)ensureInitialized;

-(void)render;

-(void)renderWithColor;

-(void)destroy;

@end
