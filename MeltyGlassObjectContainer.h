//
//  MeltyGlassObjectContainer.h
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MeltyGlassOpenGLView;

@interface MeltyGlassObjectContainer : NSObjectController {
	IBOutlet MeltyGlassOpenGLView* glView;
}

- (IBAction)ChangeViewMode:(id)sender;
- (IBAction)ChangeViewObject:(id)sender;

@end
