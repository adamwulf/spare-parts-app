//
//  MMPiston.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/24/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStick.h"

@interface MMPiston : MMStick

+(MMStick*) pistonWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1;

-(void) tick;

@end
