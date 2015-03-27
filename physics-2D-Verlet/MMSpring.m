//
//  MMSpring.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/27/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMSpring.h"


@implementation MMSpring{
    CGFloat springyness;
}

-(id) initWithP0:(MMPoint *)_p0 andP1:(MMPoint *)_p1{
    if(self = [super initWithP0:_p0 andP1:_p1]){
        springyness = .05;
    }
    return self;
}

+(MMStick*) springWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1{
    return [[MMSpring alloc] initWithP0:p0 andP1:p1];
}

-(void) constrain{
    CGFloat dx = self.p1.x - self.p0.x;
    CGFloat dy = self.p1.y - self.p0.y;
    
    CGFloat distance = sqrtf(dx * dx + dy * dy);
    CGFloat difference = (self.length - distance) * springyness;
    CGFloat percent = difference / distance / 2;
    if(isnan(percent) || !isfinite(percent)){
        percent = 0;
    }
    CGFloat offsetX = dx * percent;
    CGFloat offsetY = dy * percent;
    
    if(!self.p0.immovable){
        self.p0.x -= offsetX;
        self.p0.y -= offsetY;
    }
    if(!self.p1.immovable){
        self.p1.x += offsetX;
        self.p1.y += offsetY;
    }
    
    
    // calculate stress
    CGFloat idealLenth = [self length];
    CGFloat currLength = [self calcLen];
    CGFloat percDiff = ABS(currLength - idealLenth) / [self length];
    
    // .0 => blue
    // .1 => red
    stress = MIN(.1, percDiff) * 2;
}


@end
