//
//  RenderToBuffer.m
//  OpenGLShader
//
//  Created by Serato on 4/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import "RenderToBuffer.h"
#import "Shader.h"
#import "RenderObject.h"

#import "GLFBO.h"


@implementation RenderToBuffer

Shader* shader;
GLFBO* fbo;


-(id) initWithPathToFragmentShader: (NSString*) fragmentPath andVertexShader:(NSString*) vertexPath
{
	self = [super init];
	
	fsPath = [[NSString alloc] initWithString:fragmentPath];
	[fsPath retain];
	vsPath = [[NSString alloc] initWithString:vertexPath];
	[vsPath retain];
	
	shader = NULL;
	shaderRequiresCompile = true;
	
	shader = new Shader();
	
	fbo = new GLFBO();
	
	
	vertexTex = -1;
	colorTex = -1;
	normalTex = -1;
	
	object = NULL;
	
	return self;
}

-(void) dealloc
{
	if(shader)
		delete shader;
	
	if(fbo)
		delete fbo;
	
	[fsPath release];
	[vsPath release];
	
	[super dealloc];
}

-(void) recompileShader
{
	shaderRequiresCompile = true;
}

-(void) setBuffersOfSize: (unsigned int) numberOfElements WithVertices: (unsigned int) verticesRef andNormals: (unsigned int) normalsRef andColour: (unsigned int) colourRef
{
	numVertices = numberOfElements;
	vertexBufferRef = verticesRef;
	normalBufferRef = normalsRef;
	colourBufferRef = colourRef;
}


-(void)createFBO
{
	if(object)
	{
		int numVerts = [object numberVerts];
		fbo->create(numVerts, 1, true);
	
		if(vertexTex >= 0)
			glDeleteTextures(1, (GLuint*)&vertexTex);
		glGenTextures(1, (GLuint*)&vertexTex);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, vertexTex);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  numVerts, 1, 0, GL_RGB, GL_FLOAT, 0x0);
	
		if(colorTex >= 0)
			glDeleteTextures(1, (GLuint*)&colorTex);
		glGenTextures(1, (GLuint*)&colorTex);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, colorTex);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  numVerts, 1, 0, GL_RGB, GL_FLOAT, 0x0);

		if(normalTex >= 0)
			glDeleteTextures(1, (GLuint*)&normalTex);
		glGenTextures(1, (GLuint*)&normalTex);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, normalTex);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  numVerts, 1, 0, GL_RGB, GL_FLOAT, 0x0);
		
		
	}
	
}

-(void)createShaders
{
	shader->loadVertexShaderFromFile([vsPath cStringUsingEncoding: NSUTF8StringEncoding]);
	shader->loadFragmentShaderFromFile([fsPath cStringUsingEncoding: NSUTF8StringEncoding]);
	shader->compileAndLink();
	[self getShaderLocations];
	shaderRequiresCompile = false;
}

-(void) getShaderLocations
{
}

-(void)setupShader
{
	float projection[16];
	glGetFloatv(GL_PROJECTION_MATRIX, (float*)&projection);
	float modelview[16];
	glGetFloatv(GL_MODELVIEW_MATRIX, (float*)&modelview);
	float gravity[3];
	gravity[0] = modelview[1];
	gravity[1] = modelview[5];
	gravity[2] = modelview[9];
	
	float affectTransformed[4];
	float zPos = -2;
	affectTransformed[0] = ( projection[0] * affectPoint.x + projection[1] * affectPoint.y + projection[2] * zPos + projection[3]);
	affectTransformed[1] = ( projection[4] * affectPoint.x + projection[5] * affectPoint.y + projection[6] * zPos + projection[7]);
	affectTransformed[2] = ( projection[8] * affectPoint.x + projection[9] * affectPoint.y + projection[10] * zPos + projection[11]);
	
	
	if(shader)
	{
		shader->setFloat3Variable( pointLocation, affectTransformed[0],affectTransformed[1],affectTransformed[2] );
		shader->setFloat3Variable( gravityLocation, gravity[0],gravity[1],gravity[2] );
		shader->setFloatVariable( timeLocation, delta );
		shader->setIntVariable( colourLocation, 0);
		shader->setIntVariable( vertexLocation, 1);
		shader->setIntVariable( normalLocation, 2);
	}
}

-(void)renderWithObject:(RenderObject*)renderObject withDeltaTime:(float) delta andAffectPoint:(NSPoint) affectPoint
{
	
	if(shaderRequiresCompile)
		[self createShaders];
	
	
	if(fbo->beginRender())
	{
		if(shader)
		{
			[self setupShader];
			shader->enableShader();
		}
		
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, vertexTex);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, vertexBufferRef);
		glTexSubImage2D( GL_TEXTURE_RECTANGLE_ARB,	0, 0, 0, numVertices, 1, GL_RGB, GL_FLOAT, NULL );
		
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, colorTex);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, colourBufferRef);
		glTexSubImage2D( GL_TEXTURE_RECTANGLE_ARB,	0, 0, 0, numVertices, 1, GL_RGB, GL_FLOAT, NULL );
		
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, normalTex);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, normalBufferRef);
		glTexSubImage2D( GL_TEXTURE_RECTANGLE_ARB,	0, 0, 0, numVertices, 1, GL_RGB, GL_FLOAT, NULL );
		
		glBindBuffer( GL_PIXEL_UNPACK_BUFFER, 0 );
		
		
		glEnable(GL_TEXTURE_RECTANGLE_ARB);
		glActiveTextureARB( GL_TEXTURE0_ARB );
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB,colorTex);
		glActiveTextureARB( GL_TEXTURE1_ARB );
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB,vertexTex);
		glActiveTextureARB( GL_TEXTURE2_ARB );
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB,normalTex);
		
		glDisable(GL_DEPTH_TEST);
		glBegin(GL_QUADS);
		glMultiTexCoord2f(GL_TEXTURE0, 0,0); glVertex2f(0, 0);
		glMultiTexCoord2f(GL_TEXTURE0, numVertices,0); glVertex2f(numVertices, 0);
		glMultiTexCoord2f(GL_TEXTURE0, numVertices,1); glVertex2f(numVertices, 1);
		glMultiTexCoord2f(GL_TEXTURE0, 0,1); glVertex2f(0, 1);
		glEnd();
		glEnable(GL_DEPTH_TEST);
	
		if(shader)
			shader->disableShader();
	
		fbo->endRender();
	
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo->getID());
		
		glReadBuffer(GL_COLOR_ATTACHMENT0_EXT);
		glBindBuffer(GL_PIXEL_PACK_BUFFER,vertexBufferRef);
		glReadPixels(0, 0, numVertices, 1, GL_RGB, GL_FLOAT, NULL);
		
		glReadBuffer(GL_COLOR_ATTACHMENT1_EXT);
		glBindBuffer(GL_PIXEL_PACK_BUFFER,colourBufferRef);
		glReadPixels(0, 0, numVertices, 1, GL_RGB, GL_FLOAT, 0);
		
		glReadBuffer(GL_COLOR_ATTACHMENT2_EXT);
		glBindBuffer(GL_PIXEL_PACK_BUFFER,normalBufferRef);
		glReadPixels(0, 0, numVertices, 1, GL_RGB, GL_FLOAT, 0);
	
		glReadBuffer(GL_NONE);
		glBindBuffer(GL_PIXEL_PACK_BUFFER_ARB, 0 );
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
		glDisable(GL_TEXTURE_RECTANGLE_ARB);
		glFinish();
	}
	

}


@end
