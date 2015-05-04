//
//  MMPhysicsObject.m
//  spareparts
//
//  Created by Adam Wulf on 5/4/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPhysicsObject.h"
#import "Constants.h"

@implementation MMPhysicsObject

@synthesize p0;
@synthesize p1;
@synthesize stress;

-(CGFloat) distanceFromPoint:(CGPoint)point{
    @throw kAbstractMethodException;
}

-(void) translateBy:(CGPoint)trans{
    @throw kAbstractMethodException;
}

-(void) rotateBy:(CGFloat)rads{
    @throw kAbstractMethodException;
}

-(NSArray*) allPoints{
    @throw kAbstractMethodException;
}

-(MMPhysicsObject*) cloneObject{
    @throw kAbstractMethodException;
}

-(BOOL) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    @throw kAbstractMethodException;
}

-(void) tick{
    @throw kAbstractMethodException;
}

-(void) constrain{
    @throw kAbstractMethodException;
}

@end
