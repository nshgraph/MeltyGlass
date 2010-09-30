//
//  Melt.mm
//  MeltyGlass
//
//  Created by nathanholmberg on 8/09/10.
//  Copyright 2010 Serato Audio Research. All rights reserved.
//

#import "Melt.h"


@implementation Melt

-(id) init
{	
	// we need to pass the correct paths for the transparent (refractive) shader
	NSString* meltFSPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Refractive.FS"];
	NSString* meltVSPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString: @"/Shaders/Refractive.VS"];
	
	
	self = [super initWithPathToFragmentShader: meltFSPath ];
	

infinity.x = 10000;
infinity.y = 10000;
	
}


-(void) getShaderLocations
{
pointLocation = shader->getVariableLocation("affect");
gravityLocation = shader->getVariableLocation("gravity");
timeLocation = shader->getVariableLocation("deltaTime");
colourLocation = shader->getVariableLocation("colourTex");
vertexLocation = shader->getVariableLocation("vertexTex");
normalLocation = shader->getVariableLocation("normalTex");
}


-(void)renderWithObject:(RenderObject*)renderObject withDeltaTime:(float) delta andAffectPoint:(NSPoint) affect;

@end
