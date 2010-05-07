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
		OBJ_NUM_OBJECTS
	};
	
	RenderObject* mObjects[2];
	int mObjectIndex;
	
	RenderMode* mModes[MODE_NUM_MODES];
	int mModeIndex;
}
-(void)dealloc;


// the big ones - should be overwritten
- (void) initializeView;
- (void) draw;

//Custom ones
- (void) setMode: (int) mode;

- (void) setObject: (int) obj;

@end
