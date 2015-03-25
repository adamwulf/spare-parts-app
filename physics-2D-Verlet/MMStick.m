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
@synthesize stress;

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

-(void) tick{
    // noop
}

-(void) constrain{
    CGFloat dx = self.p1.x - self.p0.x;
    CGFloat dy = self.p1.y - self.p0.y;
    CGFloat distance = sqrtf(dx * dx + dy * dy);
    CGFloat difference = self.length - distance;
    CGFloat percent = difference / distance / 2;
    if(isnan(percent)){
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
    stress = MIN(.1, percDiff) * 10;
}

-(void) render{
    [p0 render];
    [p1 render];
    
    UIBezierPath* line = [UIBezierPath bezierPath];
    [line moveToPoint:p0.asCGPoint];
    [line addLineToPoint:p1.asCGPoint];
    line.lineWidth = 2;
    
    UIColor* renderColor = [UIColor colorWithRed:1.0*stress
                                           green:0
                                            blue:1.0*(1.0-stress)
                                           alpha:1];
    
    [renderColor setStroke];
    [line stroke];
}


#pragma mark - create stick that matches our type

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    if(p == p0){
        p0 = newP;
    }
    if(p == p1){
        p1 = newP;
    }
}

@end
