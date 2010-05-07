//
//  MeltyGlassObjectContainer.m
//
//  Created by Nathan Holmberg on 5/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MeltyGlassObjectContainer.h"

@implementation MeltyGlassObjectContainer

- (IBAction)ChangeViewMode:(id)sender
{
	int which = [sender selectedRow];
	[glView setMode: which];
}

- (IBAction)ChangeViewObject:(id)sender
{
	int which = [sender selectedRow];
	[glView setObject: which];
}

@end
