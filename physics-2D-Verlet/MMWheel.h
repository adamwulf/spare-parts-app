//
//  MMWheel.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStick.h"

@interface MMWheel : MMStick

@property (readonly) CGFloat radius;
@property (readonly) MMPoint* center;
@property (readonly) MMPoint* p2;
@property (readonly) MMPoint* p3;

+(MMWheel*) wheelWithCenter:(MMPoint*)center andRadius:(CGFloat)radius;

@end
