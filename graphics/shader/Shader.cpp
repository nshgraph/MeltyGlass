/*
*  SSVShaderGLEW.cpp
*  glgooeytest
*
*  Created by Nathan Holmberg on 20/12/06.
*  Copyright 2006 __MyCompanyName__. All rights reserved.
*
*/

// This implementation requires OpenGL 2.0 support or greater to compile


#include <OpenGL/gl.h>
#include <OpenGL/glu.h>

#include "Shader.h"

#include <iostream>
#include <fstream>

// This is THE most basic vertex shader. Using this is equivalent to not having one at all...
const char* Shader::vertexStraightThrough = "void main(){gl_TexCoord[0] = gl_TextureMatrix[0] * gl_MultiTexCoord0;gl_Position = ftransform();}";

void printProgramInfoLog (int _handle)
{
	GLint infologLength = 0;
		glGetProgramiv (_handle, GL_INFO_LOG_LENGTH, &infologLength);

		// Print log if not empty
		if (infologLength > 1)
		{
			try
			{
				GLchar *infoLog = new GLchar[infologLength];
				glGetProgramInfoLog (_handle, infologLength, NULL, infoLog);
				// ...and print it
				std::cout << "Program InfoLog ("
					<< infologLength << "):" << std::endl;
				std::cout << infoLog << std::endl;

				delete [] infoLog;
			}
			catch (std::bad_alloc &err)
			{
				std::cout << "Error: memory allocation failed for "
					<< "shader program info log" << std::endl;
				std::cout << " Reason: " << err.what () << std::endl;
			}
		}
	// Last OpenGL error check (who said we are paranoiac?)
	// checkOpenGLErrors ("Shader::printInfoLog (end)");
}

void printShaderInfoLog (int _handle)
{
	GLint infologLength = 0;
		glGetShaderiv (_handle, GL_INFO_LOG_LENGTH, &infologLength);

		// Print log if not empty
		if (infologLength > 1)
		{
			try
			{
				GLchar *infoLog = new GLchar[infologLength];

				// Get the log...
				glGetShaderInfoLog (_handle, infologLength, NULL, infoLog);

				// ...and print it
				std::cout << "Shader InfoLog ("
					<< infologLength << "):" << std::endl;
				std::cout << infoLog << std::endl;

				delete [] infoLog;
			}
			catch (std::bad_alloc &err)
			{
				std::cerr << "Error: memory allocation failed for "
					<< "shader info log" << std::endl;
				std::cerr << " Reason: " << err.what () << std::endl;
			}
		}
	// Last OpenGL error check (who said we are paranoiac?)
	// checkOpenGLErrors ("Shader::printInfoLog (end)");
}


Shader::Shader(){
	_linked = GL_FALSE;
	_handle = 0 ;
	_vertexHandle = 0;
	_fragmentHandle = 0;
}

Shader::~Shader(){
/* Seems to be causing problems under windows
	Application::RenderLock()->Lock();
	if(GLEW_ARB_shading_language_100){
		if (glIsProgram (_handle))
			glDeleteObjectARB (_handle);
		if (glIsShader (_vertexHandle))
			glDeleteObjectARB (_vertexHandle);
		if (glIsShader (_fragmentHandle))
			glDeleteObjectARB (_fragmentHandle);
	}
	Application::RenderLock()->Unlock();
*/
}

int
Shader::loadShaderFile (const std::string &filename, std::string& dest)
{
	// Open the file
	std::ifstream ifs (filename.c_str (), std::ios::in | std::ios::binary);

	if (ifs.fail ())
		return -1;

	// Read whole file into string
	dest.assign (std::istreambuf_iterator<char>(ifs),
		std::istreambuf_iterator<char>());

	// Close file
	ifs.close ();
	return 0;
}

void Shader::setVertexStraightThrough(){
	_vertexCode = vertexStraightThrough;
}

int Shader::loadVertexShaderFromFile(std::string filename){
	return loadShaderFile (filename, _vertexCode);
}

int Shader::loadFragmentShaderFromFile(std::string filename){
	return loadShaderFile (filename, _fragmentCode);
}

void Shader::loadVertexShaderFromString(std::string code){
	_vertexCode = code;
}

void Shader::loadFragmentShaderFromString(std::string code){
	_fragmentCode = code;
}

void Shader::compileAndLink(){
	GLenum err = glGetError();
	if(err!=GL_NO_ERROR) 
		printf("glError: %s caught\n", (char *)gluErrorString(err));
	// Compile vertex shader
	const GLchar *code = _vertexCode.c_str ();
	// Create a shader object
	_vertexHandle = glCreateShader (GL_VERTEX_SHADER_ARB);
	err = glGetError();
	if(err!=GL_NO_ERROR) 
		printf("glError: %s caught\n", (char *)gluErrorString(err));
	// Upload shader code to OpenGL
	glShaderSource (_vertexHandle, 1, &code, NULL);
	err = glGetError();
	if(err!=GL_NO_ERROR) 
		printf("glError: %s caught\n", (char *)gluErrorString(err));
	
	// Compile shader
	glCompileShader (_vertexHandle);
	err = glGetError();
	if(err!=GL_NO_ERROR) 
		printf("glError: %s caught\n", (char *)gluErrorString(err));
	glGetShaderiv (_vertexHandle, GL_COMPILE_STATUS, &_linked);
	// Check for success
	if (_linked == GL_FALSE){
		printf("Vertex Code Error:");
		printShaderInfoLog(_vertexHandle);
		glDeleteShader (_vertexHandle);
		_vertexHandle = 0;
		return;
	}
	
	
	
	// Compile fragment shader
	code = _fragmentCode.c_str ();
	// Create a shader object
	_fragmentHandle = glCreateShader (GL_FRAGMENT_SHADER_ARB);
	// Upload shader code to OpenGL
	glShaderSource (_fragmentHandle, 1, &code, NULL);
	
	// Compile shader
	glCompileShader (_fragmentHandle);
	err = glGetError();
	if(err!=GL_NO_ERROR) 
		printf("glError: %s caught\n", (char *)gluErrorString(err));
	glGetShaderiv (_fragmentHandle, GL_COMPILE_STATUS, &_linked);
	// Check for success
	if (_linked == GL_FALSE){
		printf("Fragment Code Error:");
		printShaderInfoLog(_fragmentHandle);
		// Roll back
		glDeleteShader (_fragmentHandle);
		glDeleteShader (_vertexHandle);
		_fragmentHandle = 0;
		_vertexHandle = 0;
		return;
	}
	// Now link shaders into a program
	_handle = glCreateProgram ();
	glAttachShader (_handle, _vertexHandle);
	glAttachShader (_handle, _fragmentHandle);
	// Perform link stage
	glLinkProgram (_handle);
	err = glGetError();
	if(err!=GL_NO_ERROR) 
		printf("glError: %s caught\n", (char *)gluErrorString(err));
	glGetShaderiv (_handle, GL_LINK_STATUS, &_linked);
	// Validate program
	glValidateProgram (_handle);	// Check for success
	if (_linked == GL_FALSE){
		// Roll back
		printProgramInfoLog(_handle);
		glDeleteShader (_vertexHandle);
		glDeleteShader (_fragmentHandle);
		_fragmentHandle = 0;
		_vertexHandle = 0;
		glDeleteProgram(_handle);
		_handle = 0;
		return;
	}
	
}


void Shader::printShaderRequirements(){
	enableShader();
	GLint texture_image_units_e = -1;
	GLint vertex_instructions_e = -1;
	GLint fragment_instructions_e = -1;
	glGetProgramivARB(GL_FRAGMENT_PROGRAM_ARB,GL_PROGRAM_TEX_INSTRUCTIONS_ARB, &texture_image_units_e);
	glGetProgramivARB(GL_VERTEX_PROGRAM_ARB,GL_PROGRAM_NATIVE_INSTRUCTIONS_ARB, &vertex_instructions_e); 
	glGetProgramivARB(GL_FRAGMENT_PROGRAM_ARB,GL_PROGRAM_NATIVE_INSTRUCTIONS_ARB, &fragment_instructions_e); 
	printf("Texture Lookups: %i Vertex Instructions: %i Fragment Instructions: %i\n",texture_image_units_e,vertex_instructions_e,fragment_instructions_e);
	disableShader();
}


void Shader::enableShader() const{
	glUseProgram (_handle);
}

void Shader::disableShader() const{
	glUseProgram(0);
}


void Shader::setFloatVariable(GLint location, float value){
	glUseProgram (_handle);
	glUniform1f(location,value);
	glUseProgram (0);
}
void Shader::setFloat3Variable(GLint location, float x, float y, float z){
	glUseProgram (_handle);
	glUniform3f(location,x,y,z);
	glUseProgram (0);
}
void Shader::setIntVariable(GLint location, int value){
	glUseProgram(_handle);
	glUniform1i(location,value);
	glUseProgram(0);
}

int Shader::getVariableLocation(const char* varName){
	int toRet = -1;
	glUseProgram(_handle);
	toRet = glGetUniformLocation(_handle, varName);
	glUseProgram(0);
	return toRet;
}
