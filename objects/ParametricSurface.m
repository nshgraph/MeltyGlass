//
//  ParametricSurface.m
//  BezierParser
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ParametricSurface.h"
#import "RenderObject.h"

@implementation ParametricSurface


-(NSPoint3) pointOnSurfaceT:(double) t S:(double) s
{
	NSPoint3 point;
	point.x = 0; point.y = 0; point.z = 0;
	return point;
}

-(NSPoint3) normalOnSurfaceT:(double) t S:(double) s
{
	NSPoint3 point;
	point.x = 0; point.y = 0; point.z = 0;
	return point;
}


-(RenderObject*) createRenderObjectWithResT: (int) resT andResS: (int) resS
{
	
	float vertices_l[(resT+1)*resS*6];
	float normals_l[(resT+1)*resS*6];
	int vertexCount = (resT+1)*resS*2;
	
	memset(&vertices_l,0,sizeof(float)*vertexCount*3);
	memset(&normals_l,0,sizeof(float)*vertexCount*3);
	
	int index;
	NSPoint3 vertex, normal;
	for(int lt=0; lt <= resT; lt++)
	{
		for(int ls=0; ls < resS; ls++)
		{
			index = (lt*(resS) + ls)*6;
			
			vertex = [self pointOnSurfaceT: (lt+1)/(double)resT S: ls/(double)resS];
			normal = [self normalOnSurfaceT: (lt+1)/(double)resT S: ls/(double)resS];
												
			vertices_l[index + 0] = vertex.x;
			vertices_l[index + 1] = vertex.y;
			vertices_l[index + 2] = vertex.z;
			normals_l[index + 0] = normal.x;
			normals_l[index + 1] = normal.y;
			normals_l[index + 2] = normal.z;
			
			vertex = [self pointOnSurfaceT: (lt)/(double)resT S: ls/(double)resS];
			normal = [self normalOnSurfaceT: (lt)/(double)resT S: ls/(double)resS];
			
			vertices_l[index + 3] = vertex.x;
			vertices_l[index + 4] = vertex.y;
			vertices_l[index + 5] = vertex.z;
			normals_l[index + 3] = normal.x;
			normals_l[index + 4] = normal.y;
			normals_l[index + 5] = normal.z;
		}	
	}
	
	RenderObject* ret = [[RenderObject alloc] init];
	
	[ret createWithVertices: (float*)&vertices_l andNormals: (float*)&normals_l ofSize: vertexCount];
	
	return ret;
}

@end
