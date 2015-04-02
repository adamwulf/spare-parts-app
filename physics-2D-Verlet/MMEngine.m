//
//  MMEngine.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/25/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMEngine.h"
#import "Constants.h"

@implementation MMEngine

@synthesize piston;
@synthesize shaft;

-(id) initWithP0:(MMPoint*)_p0 andP1:(MMPoint*)_p1{
    if(self = [super initWithP0:_p0 andP1:_p1]){
        piston = [[MMEnginePiston alloc] initForEngine:self];
        shaft = [[MMEngineShaft alloc] initWithEnginePiston:piston];
    }
    return self;
}

-(MMPoint*) p2{
    return piston.p1;
}

+(MMStick*) engineWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1{
    return [[MMEngine alloc] initWithP0:p0 andP1:p1];
}

-(void) tick{
    [super tick];
    [piston tick];
    [shaft tick];
}

-(void) constrain{
    [super constrain];
    [piston constrain];
    [shaft constrain];
}


-(void) render{
    
    
    UIImage* engineBack = [UIImage imageNamed:@"engine-back.png"];
    UIImage* engineEnd = [UIImage imageNamed:@"engine-end.png"];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // translate
    CGContextTranslateCTM(context, self.p0.x, self.p0.y);
    // rotate
    CGFloat angle = atan2f(self.p1.x - self.p0.x, self.p1.y - self.p0.y);
    CGContextRotateCTM(context, -angle + M_PI/2);
    
    // draw our board image
    [engineBack drawInRect:CGRectMake(-kStickWidth/2, -kStickWidth/2, [self calcLen] + kStickWidth, kStickWidth)];
    
    [engineEnd drawInRect:CGRectMake(-kStickWidth/2, -kStickWidth/2, kStickWidth, kStickWidth)];
    
    // render our nails / screws
    [self.p0 renderAtZeroZero];
    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, [self calcLen], 0);
    [engineEnd drawInRect:CGRectMake(-kStickWidth/2, -kStickWidth/2, kStickWidth, kStickWidth)];
    [self.p1 renderAtZeroZero];
    CGContextRestoreGState(context);
    
    CGContextTranslateCTM(context, [piston length], 0);
    [engineEnd drawInRect:CGRectMake(-kStickWidth/2, -kStickWidth/2, kStickWidth, kStickWidth)];
    [self.p2 renderAtZeroZero];

    
    
    CGContextRestoreGState(context);
}

-(BOOL) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    if([[self allPoints] containsObject:p] &&
       [[self allPoints] containsObject:newP]){
        // skip replacing, we would be replacing
        // points within ourself
        return NO;
    }
    [super replacePoint:p withPoint:newP];
    [piston replacePoint:p withPoint:newP];
    [shaft replacePoint:p withPoint:newP];
    return YES;
}

-(MMStick*) cloneObject{
    return [MMEngine engineWithP0:[MMPoint pointWithCGPoint:self.p0.asCGPoint]
                            andP1:[MMPoint pointWithCGPoint:self.p1.asCGPoint]];
}

-(NSArray*) allPoints{
    return [[super allPoints] arrayByAddingObject:self.p2];
}

@end
