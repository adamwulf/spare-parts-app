//
//  MMStick.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/23/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStick.h"

@implementation MMStick

@synthesize p0;
@synthesize p1;
@synthesize length;

-(id) init{
    if(self = [super init]){
        p0 = [MMPoint point];
        p1 = [MMPoint point];
        length = [self calcLen];
    }
    return self;
}

-(id) initWithP0:(MMPoint*)_p0 andP1:(MMPoint*)_p1{
    if(self = [super init]){
        p0 = _p0;
        p1 = _p1;
        length = [self calcLen];
    }
    return self;
}

+(MMStick*) stickWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1{
    return [[MMStick alloc] initWithP0:p0 andP1:p1];
}

-(CGFloat) calcLen{
    CGFloat dx = p1.x - p0.x,
    dy = p1.y - p0.y;
    return sqrtf(dx * dx + dy * dy);
}

-(void) render{
    [p0 render];
    [p1 render];
    
    UIBezierPath* line = [UIBezierPath bezierPath];
    [line moveToPoint:p0.asCGPoint];
    [line addLineToPoint:p1.asCGPoint];
    line.lineWidth = 2;
    
    [[UIColor blueColor] setStroke];
    [line stroke];
}

@end
