//
//  MMEngine.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/25/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMEngine.h"

@implementation MMEngine{
    CGFloat angle;
}

@synthesize p2;

-(id) initWithP0:(MMPoint*)_p0 andP1:(MMPoint*)_p1{
    if(self = [super initWithP0:_p0 andP1:_p1]){
        p2 = [MMPoint pointWithX:(_p0.x + _p1.x)/2
                            andY:(_p0.y + _p1.y)/2];
        [self setAngle:M_PI/4];
    }
    return self;
}

-(void) setAngle:(CGFloat)_angle{
    angle = _angle;
}

+(MMStick*) engineWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1{
    return [[MMEngine alloc] initWithP0:p0 andP1:p1];
}

-(void) tick{
    angle += .1;
    [super tick];
}

-(MMStick*) createStickWithP0:(MMPoint*)_p0 andP1:(MMPoint*)_p1{
    MMEngine* ret = (MMEngine*) [MMEngine engineWithP0:_p0 andP1:_p1];
    ret.angle = angle;
    return ret;
}

-(void) constrain{
    [super constrain];

    CGFloat perc =(cosf(angle) + 1.0) / 2.0;
    
    CGFloat idealX = self.p0.x + perc*(self.p1.x - self.p0.x);
    CGFloat idealY = self.p0.y + perc*(self.p1.y - self.p0.y);
    MMPoint* idealP2 = [MMPoint pointWithX:idealX andY:idealY];
    
    p2.x = idealP2.x;
    p2.y = idealP2.y;
}


-(void) render{
    [super render];
    [p2 render];
}

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    [super replacePoint:p withPoint:newP];
    if(p == p2){
        p2 = newP;
    }
}
@end
