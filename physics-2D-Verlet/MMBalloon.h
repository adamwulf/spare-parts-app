//
//  MMBalloon.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPoint.h"

@interface MMBalloon : MMPoint

+(MMBalloon*) balloonWithCGPoint:(CGPoint)p;

@end
