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
	
	void create(int width,int height, int num_draw_buffers);
	void destroy();
	
	unsigned int getID();
	
	bool beginRender();
	void endRender();
	
	bool beginTexture( int buffer_to_start = 0 );
	void endTexture();
	bool copyTexture(char* buffer, int bufferSize);
	
	unsigned int getTexRef( int buffer_to_get = 0 );
	int getSize();
	
protected:
	
	unsigned int FBOId;
	unsigned int TexId[3];
	int numTexId;
	unsigned int depthbuffer;
	bool valid;
	int width;
	int height;
};


#endif