//
//  MMEngineShaft.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMEngineShaft.h"
#import "MMEngine.h"

@implementation MMEngineShaft{
    MMEnginePiston* piston;
}

-(id) initWithEnginePiston:(MMEnginePiston*)_piston{
    if(self = [super initWithP0:_piston.p1 andP1:_piston.engine.p1]){
        piston = _piston;
    }
    return self;
}


-(CGFloat) length{
    return [piston.engine length] - [piston length];
}

@end
