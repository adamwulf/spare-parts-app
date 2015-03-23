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

+(MMPoint*) point;

+(MMPoint*) pointWithX:(CGFloat)x andY:(CGFloat)y;

-(CGPoint) asCGPoint;

-(CGFloat) distanceFromPoint:(CGPoint)p;

-(void) bumpBy:(CGPoint)diff;

-(void) render;

@end
