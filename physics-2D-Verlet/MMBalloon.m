//
//  MMBalloon.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMBalloon.h"

@implementation MMBalloon

+(MMBalloon*) balloonWithCGPoint:(CGPoint)p{
    MMBalloon* ret = [[MMBalloon alloc] init];
    ret.x = p.x;
    ret.y = p.y;
    [ret nullVelocity];
    return ret;
}


#pragma mark - Update

-(void) updateWithGravity:(CGFloat)gravity andFriction:(CGFloat)friction{
    [super updateWithGravity:-gravity andFriction:friction];
}

-(void) render{
    [super render];
    
    UIBezierPath* balloon = [UIBezierPath bezierPathWithArcCenter:self.asCGPoint
                                                       radius:25
                                                   startAngle:0
                                                     endAngle:2*M_PI
                                                    clockwise:YES];
    
    [[UIColor greenColor] setStroke];
    [balloon stroke];

}

@end
