//
//  MMEngine.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/25/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMEngine.h"

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
    [super render];
    [piston render];
    [shaft render];
}

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    [super replacePoint:p withPoint:newP];
    [piston replacePoint:p withPoint:newP];
    [shaft replacePoint:p withPoint:newP];
}

@end
