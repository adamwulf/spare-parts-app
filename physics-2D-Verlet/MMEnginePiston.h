//
//  MMEnginePiston.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStick.h"

@class MMEngine;

@interface MMEnginePiston : MMStick

@property (readonly) MMEngine* engine;

-(id) initForEngine:(MMEngine*)engine;

@end
