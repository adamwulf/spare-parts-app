//
//  MMBalloon.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPoint.h"
#import "MMPoint.h"

@interface MMBalloon : NSObject

@property (readonly) MMPoint* center;
@property (readonly) CGFloat radius;

+(MMBalloon*) balloonWithCGPoint:(CGPoint)p;

-(void) render;

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP;

@end
