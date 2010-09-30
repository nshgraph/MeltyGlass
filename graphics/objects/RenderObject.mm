//
//  RenderObject.m
//  OpenGLShader
//
//  Created by Serato on 21/06/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>

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
	
	float drawRefArray[ numberVerts * 3] ;
	for(int i=0;i<numberVerts;i++)
	{
		drawRefArray[i*3+0] = vertices[i*3+0];
		drawRefArray[i*3+1] = vertices[i*3+1];
		drawRefArray[i*3+2] = vertices[i*3+2];
	}
	
	glGenBuffers(1,&drawRef);
	glBindBuffer(GL_ARRAY_BUFFER, drawRef);
	glBufferData(GL_ARRAY_BUFFER, numberVerts * 3 * sizeof(float), &drawRefArray, GL_STATIC_DRAW);
	
	for(int i=0;i<numberVerts;i++)
	{
		drawRefArray[i*3+0] = 1.0;
		drawRefArray[i*3+1] = 1.0;
		drawRefArray[i*3+2] = 1.0;
	}
	
	glGenBuffers(1,&colorRef);
	glBindBuffer(GL_ARRAY_BUFFER, colorRef);
	memset( drawRefArray, 0, numberVerts * 3 * sizeof(float) );
	glBufferData(GL_ARRAY_BUFFER, numberVerts * 3 * sizeof(float), &drawRefArray, GL_STATIC_DRAW);
	
	glGenBuffers(1,&normalRef);
	glBindBuffer(GL_ARRAY_BUFFER, normalRef);
	glBufferData(GL_ARRAY_BUFFER, numberVerts * 3 * sizeof(float), normals, GL_STATIC_DRAW);
	
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
