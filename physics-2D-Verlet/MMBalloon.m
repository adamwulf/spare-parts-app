//
//  MMBalloon.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMBalloon.h"

@implementation MMBalloon

@synthesize center;
@synthesize radius;

-(id) init{
    if(self = [super init]){
        center = [[MMPoint alloc] init];
        center.gravityModifier = ^(CGFloat g){
            return -g;
        };
        radius = 25;
    }
    return self;
}

+(MMBalloon*) balloonWithCGPoint:(CGPoint)p{
    MMBalloon* ret = [[MMBalloon alloc] init];
    ret.center.x = p.x;
    ret.center.y = p.y;
    [ret.center nullVelocity];
    return ret;
}


#pragma mark - Update

-(void) updateWithGravity:(CGFloat)gravity andFriction:(CGFloat)friction{
    [center updateWithGravity:-gravity andFriction:friction];
}

-(void) render{
    [center render];
    
    UIBezierPath* balloon = [UIBezierPath bezierPathWithArcCenter:self.center.asCGPoint
                                                       radius:radius
                                                   startAngle:0
                                                     endAngle:2*M_PI
                                                    clockwise:YES];
    
    [[UIColor greenColor] setStroke];
    [balloon stroke];
}

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    if(p == center){
        center = newP;
        center.gravityModifier = ^(CGFloat g){
            return -g;
        };
    }
}

-(CGFloat) distanceFromPoint:(CGPoint)point{
    return [center distanceFromPoint:point];
}

-(MMBalloon*) cloneObject{
    return [MMBalloon balloonWithCGPoint:center.asCGPoint];
}

-(NSArray*) allPoints{
    return @[center];
}

@end
