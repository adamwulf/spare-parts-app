//
//  MMEngineShaft.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStick.h"
#import "MMEnginePiston.h"

@interface MMEngineShaft : MMStick

-(id) initWithEnginePiston:(MMEnginePiston*)piston;

@end
