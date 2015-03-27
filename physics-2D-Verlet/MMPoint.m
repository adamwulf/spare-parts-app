//
//  MMPoint.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/23/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPoint.h"

@implementation MMPoint{
    CGFloat(^gravityModifier)(CGFloat);
}

@synthesize x;
@synthesize y;
@synthesize oldx;
@synthesize oldy;
@synthesize immovable;

-(void) setGravityModifier:(CGFloat (^)(CGFloat))_gravityModifier{
    gravityModifier = _gravityModifier;
}

-(CGFloat(^)(CGFloat))gravityModifier{
    return gravityModifier;
}

+(MMPoint*) point{
    return [[MMPoint alloc] init];
}

+(MMPoint*) pointWithCGPoint:(CGPoint)p{
    MMPoint* ret = [MMPoint point];
    ret.x = p.x;
    ret.y = p.y;
    ret.oldx = ret.x;
    ret.oldy = ret.y;
    return ret;
}

+(MMPoint*) pointWithX:(CGFloat)x andY:(CGFloat)y{
    MMPoint* ret = [MMPoint point];
    ret.x = x;
    ret.y = y;
    ret.oldx = ret.x;
    ret.oldy = ret.y;
    return ret;
}

-(CGPoint) velocityForFriction:(CGFloat)friction{
    CGPoint ret;
    ret.x = (self.x - self.oldx) * friction;
    ret.y = (self.y - self.oldy) * friction;
    return ret;
}

-(void) bump{
    self.oldx = x + (rand() % 10 - 5);
    self.oldy = y + (rand() % 10 - 5);
}

-(void) bumpBy:(CGPoint)diff{
    x += diff.x;
    y += diff.y;
}

-(CGFloat) distanceFromPoint:(CGPoint)p{
    return [self distance:self.asCGPoint and:p];
}

-(void) setX:(CGFloat)_x{
    if(isnan(_x) || !isfinite(_x)){
        @throw [NSException exceptionWithName:@"NaNException" reason:@"nan" userInfo:nil];
    }
    x = _x;
}
-(void) setY:(CGFloat)_y{
    if(isnan(_y) || !isfinite(_y)){
        @throw [NSException exceptionWithName:@"NaNException" reason:@"nan" userInfo:nil];
    }
    y = _y;
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

-(void) nullVelocity{
    oldx = x;
    oldy = y;
}

#pragma mark - Update

-(void) updateWithGravity:(CGFloat)gravity andFriction:(CGFloat)friction{
    if(gravityModifier){
        gravity = gravityModifier(gravity);
    }
    if(!self.immovable){
        CGFloat vx = (self.x - self.oldx) * friction;
        CGFloat vy = (self.y - self.oldy) * friction;
        
        self.oldx = self.x;
        self.oldy = self.y;
        self.x += vx;
        self.y += vy;
        self.y += gravity;
    }
}

-(CGPoint) differenceFrom:(MMPoint*)p{
    return CGPointMake(self.asCGPoint.x - p.asCGPoint.x,
                       self.asCGPoint.y - p.asCGPoint.y);
}


#pragma mark - Helper

-(CGFloat) distance:(CGPoint)p0 and:(CGPoint)p1{
    CGFloat dx = p1.x - p0.x,
    dy = p1.y - p0.y;
    return sqrtf(dx * dx + dy * dy);
}

@end
