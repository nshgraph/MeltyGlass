//
//  MeltyGlassOpenGLView.h
//  MeltyGlass
//
//  Created by Nathan Holmberg on 16/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseOpenGLView.h"

@class ParametricSurface;

@interface MeltyGlassOpenGLView : BaseOpenGLView {
	ParametricSurface* mSurface;
}

// the big ones - should be overwritten
- (void) initializeView;
- (void) draw;

@end
