/*
 *  GLFBO.h
 *  Scratch Video
 *
 *  Created by Nathan Holmberg on 16/05/07.
 *  Copyright 2007 __MyCompanyName__. All rights reserved.
 *
 */


#ifndef OPENGL_FRAME_BUFFER_OBJECT_WRAPPER_H_
#define OPENGL_FRAME_BUFFER_OBJECT_WRAPPER_H_

class GLFBO{
public:
	GLFBO();
	GLFBO(const GLFBO&);
	
	void create(int width,int height, bool secondDrawBuffer);
	void destroy();
	
	unsigned int getID();
	
	bool beginRender();
	void endRender();
	
	bool beginTexture(bool getSecondBuffer = false);
	void endTexture();
	bool copyTexture(char* buffer, int bufferSize);
	
	unsigned int getTexRef(bool getSecondBuffer = false);
	int getSize();
	
protected:
	
	unsigned int FBOId;
	unsigned int TexId0;
	unsigned int TexId1;
	unsigned int TexId2;
	unsigned int depthbuffer;
	bool valid;
	int width;
	int height;
	bool secondDrawBuffer;
};


#endif