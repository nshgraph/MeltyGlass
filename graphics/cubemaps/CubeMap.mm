//
//  CubeMap.m
//  OpenGLShader
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CubeMap.h"

#import "Shader.h"

NSString* vertexCubeMapShaderString = @" \n\
uniform vec3 vect; \n\
varying vec3 view; \n\
const float PI = 3.1415; \n\
void main() { \n\
vec3 up = vec3(sin(vect.x),cos(vect.x),0.0); \n\
vec3 dir = vec3(0.0,sin(vect.y),cos(vect.y)); \n\
gl_Position = ftransform(); \n\
vec3 f = normalize(dir); \n\
vec3 s = normalize(cross(f,up)); \n\
vec3 t = normalize(cross(s,f)); \n\
view = vec3( dot( gl_Position.xyz, s ), dot( gl_Position.xyz, t ), dot( gl_Position.xyz, -f ) ); \n\
view = normalize(view); \n\
}";
NSString* fragmentCubeMapShaderString = @" \n\
varying vec3 view; \n\
uniform samplerCube tex; \n\
void main()	{ \n\
//gl_FragColor = vec4(0.0,0.0,1.0,1.0); \n\
gl_FragColor = vec4( textureCube(tex,view).rgb, 1.0 ); \n\
}";


@implementation CubeMap

static Shader *cubeMapShader = nil;  // Points to the shared object

-(GLint) loadTextureFromImage:(NSImage*) image forTarget:(GLint) target
{
	GLint texName = -1;
	if(!image)
		return texName;
	
	NSBitmapImageRep* bitmap = [NSBitmapImageRep alloc];
    int samplesPerPixel = 0;
    NSSize imgSize = [image size];
	
	[image lockFocus];
    [bitmap initWithFocusedViewRect:
	 NSMakeRect(0.0, 0.0, imgSize.width, imgSize.height)];
    [image unlockFocus];
	// Set proper unpacking row length for bitmap.
    glPixelStorei(GL_UNPACK_ROW_LENGTH, [bitmap pixelsWide]);
	
    // Set byte aligned unpacking (needed for 3 byte per pixel bitmaps).
    glPixelStorei (GL_UNPACK_ALIGNMENT, 1);
	
    // Generate a new texture name if one was not provided.
//	glGenTextures (1, &texName);
  //  glBindTexture (target, texName);
	
    // Non-mipmap filtering (redundant for texture_rectangle).
    glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER,  GL_LINEAR);
    samplesPerPixel = [bitmap samplesPerPixel];
	
    // Nonplanar, RGB 24 bit bitmap, or RGBA 32 bit bitmap.
    if(![bitmap isPlanar] && (samplesPerPixel == 3 || samplesPerPixel == 4))
    {
		glTexImage2D(target, 0, samplesPerPixel == 4 ? GL_RGBA8 : GL_RGB8, [bitmap pixelsWide], [bitmap pixelsHigh],
					 0, samplesPerPixel == 4 ? GL_RGBA : GL_RGB, GL_UNSIGNED_BYTE, [bitmap bitmapData]);
	}
	else
	{
//		texName = -1;
//		glDeleteTextures(1, &texName);
	}
	
    // Clean up.
    [bitmap release];
	
	return texName;
}

-(id)initWithPath:(NSString*)path
{
	self = [super init];
	
	initialized = false;
	frontTex = -1;
	imgDir = [[NSString alloc] initWithString:path];
	[imgDir retain];
	
//	cubeObject = [[RenderObjectCube alloc] init];
	
	return self;
}

-(void)dealloc
{
	[imgDir release];
	[super dealloc];
}

-(void)create
{
	
	if(cubeMapShader == nil) {
		cubeMapShader = new Shader();
		cubeMapShader->loadVertexShaderFromString([vertexCubeMapShaderString cStringUsingEncoding: NSUTF8StringEncoding]);
		cubeMapShader->loadFragmentShaderFromString([fragmentCubeMapShaderString cStringUsingEncoding: NSUTF8StringEncoding]);
		cubeMapShader->compileAndLink();
		rotationAxisVariable = cubeMapShader->getVariableLocation("vect");
	}
	
	
	NSString* pathToImage = [imgDir stringByAppendingString: @"/posz.jpg"];
	
	NSImage* image = [[NSImage alloc] initWithContentsOfFile:pathToImage];
	textures[0] = [self loadTextureFromImage: image forTarget: GL_TEXTURE_CUBE_MAP_POSITIVE_Z];
	[image release];
	
	pathToImage = [imgDir stringByAppendingString: @"/negx.jpg"];
	image = [[NSImage alloc] initWithContentsOfFile:pathToImage];
	textures[1] = [self loadTextureFromImage: image forTarget: GL_TEXTURE_CUBE_MAP_NEGATIVE_X];
	[image release];
	
	pathToImage = [imgDir stringByAppendingString: @"/posx.jpg"];
	image = [[NSImage alloc] initWithContentsOfFile:pathToImage];
	textures[2] = [self loadTextureFromImage: image forTarget: GL_TEXTURE_CUBE_MAP_POSITIVE_X];
	[image release];
	
	pathToImage = [imgDir stringByAppendingString: @"/negy.jpg"];
	image = [[NSImage alloc] initWithContentsOfFile:pathToImage];
	textures[3] = [self loadTextureFromImage: image forTarget: GL_TEXTURE_CUBE_MAP_NEGATIVE_Y];
	[image release];
	
	pathToImage = [imgDir stringByAppendingString: @"/posy.jpg"];
	image = [[NSImage alloc] initWithContentsOfFile:pathToImage];
	textures[4] = [self loadTextureFromImage: image forTarget: GL_TEXTURE_CUBE_MAP_POSITIVE_Y];
	[image release];
	
	pathToImage = [imgDir stringByAppendingString: @"/negz.jpg"];
	image = [[NSImage alloc] initWithContentsOfFile:pathToImage];
	textures[5] = [self loadTextureFromImage: image forTarget: GL_TEXTURE_CUBE_MAP_NEGATIVE_Z];
	[image release];
	
	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_CUBE_MAP, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	
	glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, GL_REFLECTION_MAP);
	glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, GL_REFLECTION_MAP);
	glTexGeni(GL_R, GL_TEXTURE_GEN_MODE, GL_REFLECTION_MAP);
	
	initialized = true;
}

-(void)renderAsCube
{
	if(!initialized)
		[self create];
	if(!initialized)
		return;
	
	axis[0] = 0;
	axis[1] = 3.145;
	axis[2] = 0;
	
	glMatrixMode( GL_PROJECTION );
	glPushMatrix();
	glLoadIdentity();
	
	double radians = 0.0174532925 * 20; // half aperture degrees to radians 
	double wd2 = tan(radians);
	glFrustum (-wd2, wd2, -wd2, wd2, 1.0, 100);
	
	glMatrixMode( GL_MODELVIEW );
	glPushMatrix();
	glLoadIdentity();
	
	glPushAttrib(GL_LIGHTING);
	glDisable(GL_LIGHTING);
	
	
	[self beginCubeMapTexture];
	
	
	
	glColor4f(1.0,1.0,1.0,1.0);

	glTranslatef(0,0,-30.0);
	
	if(cubeMapShader)
	{
		cubeMapShader->setFloat3Variable( rotationAxisVariable, axis[0], axis[1], axis[2] );
		cubeMapShader->enableShader();
	}
	
	glBegin(GL_TRIANGLE_STRIP);
	glNormal3f(  0.0,  0.0, -1.0);
	glVertex3f(-20.0,-20.0,0.0);
	glVertex3f(-20.0, 20.0,0.0);
	glVertex3f( 20.0,-20.0,0.0);
	glVertex3f( 20.0, 20.0,0.0);
	glEnd();
	
	if(cubeMapShader)
		cubeMapShader->disableShader();
	
	glMatrixMode( GL_PROJECTION );
	glPopMatrix();
	
	glMatrixMode( GL_MODELVIEW );
	glPopMatrix();
	
	glPopAttrib();
	
	[self endCubeMapTexture];
}

-(void)beginCubeMapTexture
{
	glEnable(GL_TEXTURE_CUBE_MAP);
	glEnable(GL_TEXTURE_GEN_S);
	glEnable(GL_TEXTURE_GEN_T);
	glEnable(GL_TEXTURE_GEN_R);
}
-(void)endCubeMapTexture
{
	glDisable(GL_TEXTURE_CUBE_MAP);
	glDisable(GL_TEXTURE_GEN_S);
	glDisable(GL_TEXTURE_GEN_T);
	glDisable(GL_TEXTURE_GEN_R);
}

-(void)getAxis:(float*) axisOut
{
	axisOut[0] = axis[0];
	axisOut[1] = axis[1];
	axisOut[2] = axis[2];
}

@end
