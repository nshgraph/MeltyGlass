//
//  MeltyGlassOpenGLView.h
//  MeltyGlass
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseOpenGLView.h"

@class RenderObject;
@class RenderMode;
@class Melt;
@class MouseHandlerAffect;

@interface MeltyGlassOpenGLView : BaseOpenGLView {
	enum{
		MODE_WIREFRAME,
		MODE_LIGHTING,
		MODE_TRANSPARENT,
		MODE_NUM_MODES
	};
	
	enum {
		OBJ_GLASS1,
		OBJ_GLASS2,
		OBJ_SPHERE,
		OBJ_NUM_OBJECTS
	};
	
	RenderObject* mObjects[3];
	int mObjectIndex;
	
	RenderMode* mModes[MODE_NUM_MODES];
	int mModeIndex;
	
	Melt* mMeltShader;
	
	MouseHandlerAffect* mAffectMouseHandler;
}
-(void)dealloc;


// the big ones - should be overwritten
- (void) initializeView;
- (void) draw;

//Custom ones
- (void) setMode: (int) mode;

- (void) setObject: (int) obj;

- (void) reloadShader;


// mouse related events
- (void) mouseDown:(NSEvent *)theEvent;
- (void) rightMouseDown:(NSEvent *)theEvent;
- (void) otherMouseDown:(NSEvent *)theEvent;
- (void) mouseUp:(NSEvent *)theEvent;
- (void) rightMouseUp:(NSEvent *)theEvent;
- (void) otherMouseUp:(NSEvent *)theEvent;
- (void) mouseDragged:(NSEvent *)theEvent;
- (void) scrollWheel:(NSEvent *)theEvent;
- (void) rightMouseDragged:(NSEvent *)theEvent;
- (void) otherMouseDragged:(NSEvent *)theEvent;

@end
