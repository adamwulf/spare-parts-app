//
//  MMStick.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/23/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPoint.h"
#import "MMPhysicsObject.h"

@interface MMStick : MMPhysicsObject<NSCoding>{
    UIImage* image;
}

@property (nonatomic) CGFloat length;

-(id) initWithP0:(MMPoint*)_p0 andP1:(MMPoint*)_p1;

+(MMStick*) stickWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1;

// subclasses only please

-(CGFloat) calcLen;


@end
