//
//  MMBalloon.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPoint.h"
#import "MMStick.h"
#import "Renderable.h"

@interface MMBalloon : Renderable<NSCoding>

@property (readonly) MMPoint* center;
@property (readonly) MMPoint* tail;
@property (nonatomic) CGFloat radius;
@property (readonly) MMStick* stick;
@property (readonly) MMPoint* p0;
@property (readonly) MMPoint* p1;

+(MMBalloon*) balloonWithCGPoint:(CGPoint)p;

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP;

-(CGFloat) distanceFromPoint:(CGPoint)point;

-(void) constrain;

-(MMBalloon*) cloneObject;

-(NSArray*) allPoints;

@end
