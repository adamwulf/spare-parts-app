//
//  MMEngine.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/25/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStick.h"
#import "MMEnginePiston.h"
#import "MMEngineShaft.h"

@interface MMEngine : MMStick

@property (readonly) MMPoint* p2;
@property (readonly) MMEnginePiston* piston;
@property (readonly) MMEngineShaft* shaft;

+(MMStick*) engineWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1;

@end
