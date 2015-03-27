//
//  MMSpring.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/27/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStick.h"

@interface MMSpring : MMStick

+(MMStick*) springWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1;

@end
