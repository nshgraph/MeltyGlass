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
	
	shaderRequiresCompile = true;
	
	shader = new Shader();
	
	currentRenderObject = NULL;
	
	fbo = new GLFBO();
	
	
	vertexTex = -1;
	colorTex = -1;
	normalTex = -1;
	
	renderWidth = 1;
	renderHeight = 1;
	renderOverrun = 0;
	
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

-(void) setRenderObject: (RenderObject*) object;
{
	if( object == currentRenderObject )
		return;
	
	if( object )
	{
		// ensure that the object has been compiled
		[object compile];
		
		int numberVerts = [object numberVerts];
		
		// to keep the size of 
		if( numberVerts < 4096 )
		{
			renderWidth = numberVerts;
			renderHeight = 1;
			renderOverrun = 0;
		}
		else {
			renderWidth = 4096;
			renderHeight = numberVerts / 4096 + 1;
			renderOverrun = 4096 * renderHeight - numberVerts;
		}
		
		vertexBufferRef = [object drawRef];
		normalBufferRef = [object normalRef];
		colourBufferRef = [object colorRef];
		
		fbo->create(renderWidth, renderHeight, 3);
	
		// create the vertex texture / render target
		if(vertexTex >= 0)
			glDeleteTextures(1, (GLuint*)&vertexTex);
		glGenTextures(1, (GLuint*)&vertexTex);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, vertexTex);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  renderWidth, renderHeight, 0, GL_RGB, GL_FLOAT, 0x0);
		
		// create the color texture / render target
		if(colorTex >= 0)
			glDeleteTextures(1, (GLuint*)&colorTex);
		glGenTextures(1, (GLuint*)&colorTex);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, colorTex);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  renderWidth, renderHeight, 0, GL_RGB, GL_FLOAT, 0x0);
		
		// create the normal texture / render target
		if(normalTex >= 0)
			glDeleteTextures(1, (GLuint*)&normalTex);
		glGenTextures(1, (GLuint*)&normalTex);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, normalTex);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  renderWidth, renderHeight, 0, GL_RGB, GL_FLOAT, 0x0);
	}
	
	currentRenderObject = object;

}

-(void)createShaders
{
	shader->loadVertexShaderFromFile([vsPath cStringUsingEncoding: NSUTF8StringEncoding]);
	shader->loadFragmentShaderFromFile([fsPath cStringUsingEncoding: NSUTF8StringEncoding]);
	shader->compileAndLink();
	[self getShaderLocations];
	shaderRequiresCompile = false;
}

-(void)setupShader
{
	// Does nothing in the basic form
}

-(void)getShaderLocations
{
	// Does nothing in the basic form
}

-(void)render
{
	
	if(shaderRequiresCompile)
		[self createShaders];
	
	
	[self setupShader];
	
	if(fbo->beginRender())
	{
		// start the shader
		if(shader)
		{
			shader->enableShader();
		}
		
		glPixelStorei(GL_UNPACK_ROW_LENGTH, renderWidth);
		
		// Set byte aligned unpacking (needed for 3 byte per pixel bitmaps).
		glPixelStorei (GL_UNPACK_ALIGNMENT, 1);
		// load the relevant buffers as textures (to be referenced from the shader)
		//  we use tex_rects for accurate traversal
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, vertexTex);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, vertexBufferRef);
		glTexSubImage2D( GL_TEXTURE_RECTANGLE_ARB,	0, 0, 0, renderWidth, renderHeight, GL_RGB, GL_FLOAT, NULL );
		
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, colorTex);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, colourBufferRef);
		glTexSubImage2D( GL_TEXTURE_RECTANGLE_ARB,	0, 0, 0, renderWidth, renderHeight, GL_RGB, GL_FLOAT, NULL );
		
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, normalTex);
		glBindBuffer(GL_PIXEL_UNPACK_BUFFER, normalBufferRef);
		glTexSubImage2D( GL_TEXTURE_RECTANGLE_ARB,	0, 0, 0, renderWidth, renderHeight, GL_RGB, GL_FLOAT, NULL );
		
		glBindBuffer( GL_PIXEL_UNPACK_BUFFER, 0 );
		
		// enable all these textures
		glEnable(GL_TEXTURE_RECTANGLE_ARB);
		glActiveTextureARB( GL_TEXTURE0_ARB );
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB,colorTex);
		glActiveTextureARB( GL_TEXTURE1_ARB );
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB,vertexTex);
		glActiveTextureARB( GL_TEXTURE2_ARB );
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB,normalTex);
		
		
		glDisable(GL_DEPTH_TEST);
		// immediate mode? this needs to go 
		glBegin(GL_QUADS);
		glMultiTexCoord2f(GL_TEXTURE0, 0,0); 
		glVertex2f(0, 0);
		glMultiTexCoord2f(GL_TEXTURE0, renderWidth,0); 
		glVertex2f(renderWidth, 0);
		glMultiTexCoord2f(GL_TEXTURE0, renderWidth,renderHeight); 
		glVertex2f(renderWidth, renderHeight);
		glMultiTexCoord2f(GL_TEXTURE0, 0,renderHeight); 
		glVertex2f(0, renderHeight);
		glEnd();
		glEnable(GL_DEPTH_TEST);
	
		// end the shader
		if(shader)
			shader->disableShader();
	
		fbo->endRender();
	
		// bind to the FBO so we are referencing its render targets
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo->getID());
		
		// pull the output of each render target back into the buffers provided
		glReadBuffer(GL_COLOR_ATTACHMENT0_EXT);
		glBindBuffer(GL_PIXEL_PACK_BUFFER,vertexBufferRef);
		glReadPixels(0, 0, renderWidth, renderHeight, GL_RGB, GL_FLOAT, 0);
		
		glReadBuffer(GL_COLOR_ATTACHMENT1_EXT);
		glBindBuffer(GL_PIXEL_PACK_BUFFER,colourBufferRef);
		glReadPixels(0, 0, renderWidth, renderHeight, GL_RGB, GL_FLOAT, 0);
		
		glReadBuffer(GL_COLOR_ATTACHMENT2_EXT);
		glBindBuffer(GL_PIXEL_PACK_BUFFER,normalBufferRef);
		glReadPixels(0, 0, renderWidth, renderHeight, GL_RGB, GL_FLOAT, 0);
	
		glReadBuffer(GL_NONE);
		glBindBuffer(GL_PIXEL_PACK_BUFFER_ARB, 0 );
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
		glDisable(GL_TEXTURE_RECTANGLE_ARB);
		glFinish();
	}
	

}


@end
