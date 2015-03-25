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

-(MMStick*) createStickWithP0:(MMPoint*)_p0 andP1:(MMPoint*)_p1{
    MMPiston* ret = (MMPiston*) [MMPiston pistonWithP0:_p0 andP1:_p1];
    ret.angle = angle;
    return ret;
}


@end
