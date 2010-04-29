// Trackball.h: interface for the CTrackball class.
// Copyright: (c) Burkhard Wuensche, 2002
// Originally published in SIGGRAPH (1996?)
// This file contains a C++ implementation of a modification of the original algorithm 
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_TRACKBALL2_H__D9D7AFA2_744F_11D2_B4F5_0000E8D74310__INCLUDED_)
#define AFX_TRACKBALL2_H__D9D7AFA2_744F_11D2_B4F5_0000E8D74310__INCLUDED_

#if _MSC_VER >= 1000
#pragma once
#endif // _MSC_VER >= 1000

#include <OpenGL/OpenGL.h>
#include <GLUT/GLUT.h>

class CTrackball
{
public:
	CTrackball();
	virtual ~CTrackball();
	void tbInit(GLuint button);
	void tbMatrix();
	void tbReshape(int width, int height);
	void tbMouse(int button, int state, int x, int y, unsigned int time);
	void tbMotion(int x, int y, unsigned int time);
private:
	GLuint    tb_lasttime;
	GLfloat   tb_lastposition[3];
	
	GLfloat   tb_angle;
	GLfloat   tb_axis[3];
	GLfloat   tb_transform[4][4];

	GLuint    tb_width;
	GLuint    tb_height;

	GLint     tb_button;
	GLboolean tb_tracking;

	void _tbPointToVector(int x, int y, int width, int height, float v[3]);
	void _tbStartMotion(int x, int y, int button, int time);
	void _tbStopMotion(int button, unsigned time);
};

#endif // !defined(AFX_TRACKBALL2_H__D9D7AFA2_744F_11D2_B4F5_0000E8D74310__INCLUDED_)
