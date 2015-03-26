//
//  MMPiston.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/24/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPiston.h"

@implementation MMPiston{
    CGFloat angle;
}

-(void) setAngle:(CGFloat)_angle{
    angle = _angle;
}

+(MMStick*) pistonWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1{
    return [[MMPiston alloc] initWithP0:p0 andP1:p1];
}

-(CGFloat) length{
    return [super length] * .8 +
    [super length]*.2*cosf(angle);
}

-(void) tick{
    angle += .1;
    [super tick];
}


@end
