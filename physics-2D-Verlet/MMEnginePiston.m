//
//  MMEnginePiston.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMEnginePiston.h"
#import "MMEngine.h"

@implementation MMEnginePiston{
    CGFloat angle;
    MMEngine* engine;
}

@synthesize engine;

-(id) initForEngine:(MMEngine *)_engine{
    MMPoint* p2OfEngine = [MMPoint pointWithX:_engine.p1.x andY:_engine.p1.y];
    if(self = [super initWithP0:_engine.p0 andP1:p2OfEngine]){
        engine = _engine;
        angle = 0;
    }
    return self;
}

-(void) setAngle:(CGFloat)_angle{
    angle = _angle;
}

-(CGFloat) length{
    return [engine length]*((cosf(angle) + 1)/2);
}

-(void) tick{
    angle += .1;
    [super tick];
}

@end
