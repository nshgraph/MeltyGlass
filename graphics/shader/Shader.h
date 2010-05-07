/*
 *  SSVShaderNative.h
 *  glgooeytest
 *
 *  Created by Nathan Holmberg on 20/12/06.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef SSV_SHADER_H_
#define SSV_SHADER_H_

#include <string>

class Shader {
	public:
		Shader();
		~Shader();
	
		int loadVertexShaderFromFile(std::string filename);
		void loadVertexShaderFromString(std::string code);
		int loadFragmentShaderFromFile(std::string filename);
		void loadFragmentShaderFromString(std::string code);
		void compileAndLink();
		void enableShader() const;
		void disableShader() const;
		void setFloatVariable(GLint location, float value);
		void setFloat3Variable(GLint location, float x, float y, float z);
		void setIntVariable(GLint location, int value);
		int getVariableLocation(const char* varName);
		void setVertexStraightThrough();
		void printShaderRequirements();
		
		GLuint getHandle () const { return _handle; };
		bool compileFailed () const { return (_linked == GL_FALSE); };
	private:
		static const char* vertexStraightThrough;
		int loadShaderFile (const std::string &filename, std::string& dest);
		std::string _vertexCode;
		std::string _fragmentCode;
		GLuint _handle;
		GLuint _vertexHandle;
		GLuint _fragmentHandle;
		GLint _linked;

};





#endif