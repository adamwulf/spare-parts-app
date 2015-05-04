//
//  MMPhysicsObject.h
//  spareparts
//
//  Created by Adam Wulf on 5/4/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "Renderable.h"
#import "MMPoint.h"

@interface MMPhysicsObject : Renderable{
    MMPoint* p0;
    MMPoint* p1;
    CGFloat stress;
}

@property (readonly) MMPoint* p0;
@property (readonly) MMPoint* p1;
@property (readonly) CGFloat stress;

-(CGFloat) distanceFromPoint:(CGPoint)point;

-(void) translateBy:(CGPoint)trans;

-(void) rotateBy:(CGFloat)rads;

-(MMPhysicsObject*) cloneObject;

-(NSArray*) allPoints;

-(BOOL) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP;

-(void) tick;

-(void) constrain;

@end
