//
//  MMBalloon.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPoint.h"
#import "MMStick.h"

@interface MMBalloon : NSObject<NSCoding>

@property (readonly) MMPoint* center;
@property (readonly) MMPoint* tail;
@property (readonly) CGFloat radius;
@property (readonly) MMStick* stick;
@property (readonly) MMPoint* p0;
@property (readonly) MMPoint* p1;

+(MMBalloon*) balloonWithCGPoint:(CGPoint)p;

-(void) renderWithHighlight;

-(void) render;

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP;

-(CGFloat) distanceFromPoint:(CGPoint)point;

-(void) constrain;

-(MMBalloon*) cloneObject;

-(NSArray*) allPoints;

@end
