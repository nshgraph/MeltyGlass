//
//  MouseHandler.h
//  OpenGLShader
//
//  Created by Serato on 1/07/08.
//  Copyright 2008 Serato Audio Research. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MouseHandler : NSObject {

}

-(void) operate;

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
