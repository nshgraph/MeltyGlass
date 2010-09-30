/*
 *  GLFBO.cpp
 *  Scratch Video
 *
 *  Created by Nathan Holmberg on 16/05/07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */

#include "GLFBO.h"

#include <OpenGL/OpenGL.h>
#include <OpenGL/glu.h>

#include <stdio.h>

GLFBO::GLFBO(){
	valid = false;
	FBOId = 0;
	TexId0 = 0;
	TexId1 = 0;
	depthbuffer = 0;
	secondDrawBuffer = false;
}

GLFBO::GLFBO(const GLFBO& old){
	valid = old.valid;
	FBOId = old.FBOId;
	TexId0 = old.TexId0;
	TexId1 = old.TexId1;
	width  = old.width;
	height  = old.height;
	depthbuffer = old.depthbuffer;
}

void GLFBO::create(int width, int height, bool secondDrawBuffer){
	// if the previous fbo exists, destroy
	if(valid){
		destroy();
	}
	
	this->width = width;
	this->height = height;
	this->secondDrawBuffer = secondDrawBuffer;
	
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	
	// Create the fbo
	glGenFramebuffersEXT(1, (GLuint*)&FBOId);
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FBOId);
	
	// Create render buffer
	//	glGenRenderbuffersEXT(1, (GLuint*)&depthbuffer);
	//	glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, depthbuffer);
	//	glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, size, size);
	//	glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, depthbuffer);
	
	// Create the texture representing the results that will be written to
	glGenTextures(1, (GLuint*)&TexId0);
	glBindTexture(GL_TEXTURE_RECTANGLE_ARB, TexId0);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_RECTANGLE_ARB, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  width, height, 0, GL_RGB, GL_FLOAT, 0x0);
	glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_RECTANGLE_ARB, TexId0, 0);
	
	if(secondDrawBuffer)
	{
		glGenTextures(1, (GLuint*)&TexId1);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, TexId1);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  width, height, 0, GL_RGB, GL_FLOAT, 0x0);
		glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT1_EXT, GL_TEXTURE_RECTANGLE_ARB, TexId1, 0);
		
		glGenTextures(1, (GLuint*)&TexId2);
		glBindTexture(GL_TEXTURE_RECTANGLE_ARB, TexId2);
		glTexImage2D(GL_TEXTURE_RECTANGLE_ARB, 0, GL_RGB_FLOAT32_APPLE,  width, height, 0, GL_RGB, GL_FLOAT, 0x0);
		glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT2_EXT, GL_TEXTURE_RECTANGLE_ARB, TexId2, 0);
	}
 
	// Check the final status of this frame buffer
	int status = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
	if(status != GL_FRAMEBUFFER_COMPLETE_EXT){
		printf("ERROR: FBO %i not initialized correctly (attempted dim %i,%i)\n",FBOId,width,height);
		valid = false;
		float* test = 0;
		*test = 1;
	}
	else{
		printf("Created FBO %i successfully of dim %i,%i\n",FBOId,width,height);
		valid = true;
		
		// Do a clear so we are guaranteed a frsh slate
		glClear( GL_COLOR_BUFFER_BIT);
	}
	// Unbind FBO so we can continue as normal
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	
	
}

void GLFBO::destroy(){
	glDeleteFramebuffersEXT(1, (GLuint*)&FBOId);
	glDeleteTextures(1,(GLuint*)&TexId0);
	if(secondDrawBuffer)
		glDeleteTextures(1,(GLuint*)&TexId1);
	valid = false;
	glBindFramebufferEXT( GL_FRAMEBUFFER_EXT, 0 ); 
}

bool GLFBO::beginRender(){
	if(!valid) return false;
	glDisable(GL_TEXTURE_2D);
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FBOId);
	
	glPushAttrib(GL_VIEWPORT_BIT);
	glViewport(0,0, width, height);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	// Clear Screen And Depth Buffer	// OUCH!! Big performance hit
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	gluOrtho2D(0.0,width,0.0,height);
	glMatrixMode(GL_MODELVIEW);
	glPushMatrix();
//	glLoadIdentity();
	if(secondDrawBuffer)
	{
		GLenum dbuffers[] = {GL_COLOR_ATTACHMENT0_EXT, GL_COLOR_ATTACHMENT1_EXT, GL_COLOR_ATTACHMENT2_EXT};
		glDrawBuffers(3, dbuffers);
	}

	return true;
}

void GLFBO::endRender(){
	glPopAttrib();
	
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	glPopMatrix();
}

bool GLFBO::beginTexture(bool getSecondBuffer){
	glEnable(GL_TEXTURE_2D);
	if(getSecondBuffer)
	{
		glBindTexture(GL_TEXTURE_2D,TexId1);
	}
	else{
		glBindTexture(GL_TEXTURE_2D,TexId0);
	}
	return true;
}


unsigned int GLFBO::getTexRef(bool getSecondBuffer)
{
	if(getSecondBuffer)
		return TexId1;
	else
		 return TexId0;
}

void GLFBO::endTexture(){
	glDisable(GL_TEXTURE_2D);
}

bool GLFBO::copyTexture(char* buffer, int bufferSize){
	if(bufferSize < width*height*4)
		return false;
	bool result = true;
	
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, FBOId);
	
	glReadBuffer(GL_COLOR_ATTACHMENT0_EXT);
	glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	
	result = (glGetError() == GL_NO_ERROR);
	
	glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
	
	return result;
}

int GLFBO::getSize(){
	return width;
}


unsigned int GLFBO::getID()
{
	return FBOId;
}