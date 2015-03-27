//
//  MMPoint.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/23/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat oldx;
@property (nonatomic) CGFloat oldy;
@property (nonatomic) BOOL immovable;
@property (nonatomic) CGFloat(^gravityModifier)(CGFloat);

+(MMPoint*) point;

+(MMPoint*) pointWithCGPoint:(CGPoint)p;

+(MMPoint*) pointWithX:(CGFloat)x andY:(CGFloat)y;

-(CGPoint) asCGPoint;

-(CGFloat) distanceFromPoint:(CGPoint)p;

-(CGPoint) differenceFrom:(MMPoint*)p;

-(void) bump;

-(CGPoint) velocityForFriction:(CGFloat)friction;


-(void) bumpBy:(CGPoint)diff;

-(void) render;

-(void) nullVelocity;

-(void) updateWithGravity:(CGFloat)gravity andFriction:(CGFloat)friction;

@end
