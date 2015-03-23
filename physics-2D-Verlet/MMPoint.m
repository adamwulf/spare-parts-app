//
//  MMPoint.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/23/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPoint.h"

@implementation MMPoint

@synthesize x;
@synthesize y;
@synthesize oldx;
@synthesize oldy;

+(MMPoint*) point{
    return [[MMPoint alloc] init];
}

+(MMPoint*) pointWithX:(CGFloat)x andY:(CGFloat)y{
    MMPoint* ret = [MMPoint point];
    ret.x = x;
    ret.y = y;
    ret.oldx = x + (rand() % 10 - 5);
    ret.oldy = y + (rand() % 10 - 5);
    return ret;
}

-(void) setX:(CGFloat)_x{
    if(isnan(_x)){
        @throw [NSException exceptionWithName:@"NaNException" reason:@"nan" userInfo:nil];
    }
    x = _x;
}

-(CGPoint) asCGPoint{
    return CGPointMake(x, y);
}

-(void) render{
    UIBezierPath* dot = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y)
                                                       radius:3
                                                   startAngle:0
                                                     endAngle:2*M_PI
                                                    clockwise:YES];
    [[UIColor redColor] setFill];
    [dot fill];
}

@end
