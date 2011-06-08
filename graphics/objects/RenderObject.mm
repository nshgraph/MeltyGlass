//
//  RenderObject.m
//  OpenGLShader
//
//  Created by Serato on 21/06/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import <OpenGL/GL.h>

#import "RenderObject.h"


@implementation RenderObject

- (id)init
{
	self = [super init];
	vertices = NULL;
	normals = NULL;
	isValid = false;
	isCompiled = false;
	return self;
}

-(void)compile
{
	if(!isValid)
		return;
	if(isCompiled)
		[self destroy];
	
	// need to provide a multiple of 4096 vertices (max_tex_size)
	int num_verts_4096 = ((int)(numberVerts / 4096) + 1) * 4096;
	
	float drawRefArray[ num_verts_4096 * 3];
	
	
	glGenBuffers(1,&drawRef);
	glBindBuffer(GL_ARRAY_BUFFER, drawRef);
	memcpy(drawRefArray,vertices,numberVerts*3*sizeof(float));
	glBufferData(GL_ARRAY_BUFFER, num_verts_4096 * 3 * sizeof(float), &drawRefArray, GL_STREAM_DRAW);
	
	glGenBuffers(1,&colorRef);
	glBindBuffer(GL_ARRAY_BUFFER, colorRef);
	memset( drawRefArray, 0, numberVerts * 3 * sizeof(float) );
	glBufferData(GL_ARRAY_BUFFER, num_verts_4096 * 3 * sizeof(float), &drawRefArray, GL_STREAM_DRAW);
	
	glGenBuffers(1,&normalRef);
	glBindBuffer(GL_ARRAY_BUFFER, normalRef);
	memcpy( drawRefArray, normals, numberVerts * 3 * sizeof(float) );
	glBufferData(GL_ARRAY_BUFFER, num_verts_4096 * 3 * sizeof(float), &drawRefArray, GL_STREAM_DRAW);
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	
	isCompiled = true;
}

-(void)createWithVertices:(float*)vertexArray andNormals:(float*) normalArray ofSize:(int)vertexCount;
{
	vertices = new float[vertexCount*3];
	memcpy(vertices,vertexArray,vertexCount*3*sizeof(float));
	
	normals = new float[vertexCount*3];
	memcpy(normals,normalArray,vertexCount*3*sizeof(float));
	
	numberVerts = vertexCount;
	
	hasTexCoords = false;
	
	isValid = true;
	
	isCompiled = false;
}

-(void)drawCommand
{
	glDrawArrays(GL_TRIANGLE_STRIP, 0, numberVerts);
}


-(void)ensureInitialized
{
	if(!isCompiled)
		[self compile];
}

-(void)render
{	
	[self ensureInitialized];
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	
	glBindBuffer(GL_ARRAY_BUFFER, drawRef);
	glVertexPointer(3, GL_FLOAT, 0, 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, normalRef);
	glNormalPointer(GL_FLOAT, 0, 0);
	
	[self drawCommand];
	
	glDisableClientState(GL_VERTEX_ARRAY); 
	glDisableClientState(GL_NORMAL_ARRAY);
}

-(void)renderWithColor
{	
	[self ensureInitialized];
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_NORMAL_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	
	glBindBuffer(GL_ARRAY_BUFFER, drawRef);
	glVertexPointer(3, GL_FLOAT, 0, 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, colorRef);
	glColorPointer(3, GL_FLOAT, 0, 0);
	
	glBindBuffer(GL_ARRAY_BUFFER, normalRef);
	glNormalPointer(GL_FLOAT, 0, 0);
	
	[self drawCommand];
	
	glDisableClientState(GL_VERTEX_ARRAY); 
	glDisableClientState(GL_NORMAL_ARRAY); 
	glDisableClientState(GL_COLOR_ARRAY);
}

-(void)destroy
{
	if(isCompiled)
	{
		isCompiled = false;
		glDeleteBuffers(1, &drawRef);
		glDeleteBuffers(1, &colorRef);
		glDeleteBuffers(1, &normalRef);
	}
}

-(void)dealloc
{
	if(isValid)
	{
		if( isCompiled )
			[self destroy];
		
		if(vertices)
			delete[] vertices;
		if(normals)
			delete[] normals;
	}
	[super dealloc];
}


-(void) invalidate
{
	isValid = false;
}

-(bool) isValid
{
	return isValid;
}
-(bool) isCompiled
{
	return isCompiled;
}
-(int) numberVerts
{
	return numberVerts;
}
-(unsigned int) drawRef
{
	return drawRef;
}
-(unsigned int) normalRef
{
	return normalRef;
}
-(unsigned int) colorRef
{
	return colorRef;
}


@end
