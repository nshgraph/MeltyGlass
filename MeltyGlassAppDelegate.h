//
//  MeltyGlassAppDelegate.h
//  BaseGL
//
//  Created by Nathan Holmberg on 14/02/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MeltyGlassAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
