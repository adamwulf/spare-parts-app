//
//  MMWheel.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMWheel.h"
#import "MMPoint.h"

@implementation MMWheel{
    MMStick* spoke1;
    MMStick* spoke2;

    MMStick* spoke3;
    MMStick* spoke4;
    MMStick* crossBar1;
    MMStick* crossBar2;
    MMStick* crossBar3;
}

@synthesize radius;
@synthesize center;
@synthesize p2;
@synthesize p3;

+(MMWheel*) wheelWithCenter:(MMPoint *)center andRadius:(CGFloat)radius{
    return [[MMWheel alloc] initWithCenter:center andRadius:radius];
}


-(id) initWithCenter:(MMPoint *)_center andRadius:(CGFloat)_radius{
    // initial crossbar
    MMPoint* _p0 = [MMPoint pointWithCGPoint:_center.asCGPoint];
    MMPoint* _p1 = [MMPoint pointWithCGPoint:_center.asCGPoint];
    _p0.x -= _radius;
    _p1.x += _radius;
    [_p0 nullVelocity];
    [_p1 nullVelocity];

    if(self = [super initWithP0:_p0 andP1:_p1]){
        center = _center;
        spoke1 = [MMStick stickWithP0:_p0 andP1:center];
        spoke2 = [MMStick stickWithP0:center andP1:_p1];
        radius = [center distanceFromPoint:_p1.asCGPoint];
        
        // create other spokes
        p2 = [MMPoint pointWithCGPoint:_center.asCGPoint];
        p3 = [MMPoint pointWithCGPoint:_center.asCGPoint];
        p2.y -= _radius;
        p3.y += _radius;
        [p2 nullVelocity];
        [p3 nullVelocity];

        spoke3 = [MMStick stickWithP0:p2 andP1:center];
        spoke4 = [MMStick stickWithP0:center andP1:p3];
        crossBar1 = [MMStick stickWithP0:p2 andP1:p3];

        crossBar2 = [MMStick stickWithP0:_p0 andP1:p2];
        crossBar3 = [MMStick stickWithP0:_p1 andP1:p3];
        
    }
    return self;
}


-(void) tick{
    [super tick];
    [spoke1 tick];
    [spoke2 tick];
    [spoke3 tick];
    [spoke4 tick];
    [crossBar1 tick];
    [crossBar2 tick];
    [crossBar3 tick];
}

-(void) constrain{
    [super constrain];
    [spoke1 constrain];
    [spoke2 constrain];
    [spoke3 constrain];
    [spoke4 constrain];
    for (int i=0; i<5; i++) {
        [crossBar1 constrain];
        [crossBar2 constrain];
        [crossBar3 constrain];
    }
}


-(void) render{
    [super render];
    [spoke1 render];
    [spoke2 render];
    [spoke3 render];
    [spoke4 render];
    [crossBar1 render];
    [crossBar2 render];
    [crossBar3 render];

    UIBezierPath* balloon = [UIBezierPath bezierPathWithArcCenter:center.asCGPoint
                                                           radius:radius
                                                       startAngle:0
                                                         endAngle:2*M_PI
                                                        clockwise:YES];
    
    [[UIColor blueColor] setStroke];
    [balloon stroke];
}

-(void) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    [super replacePoint:p withPoint:newP];
    [spoke1 replacePoint:p withPoint:newP];
    [spoke2 replacePoint:p withPoint:newP];
    [spoke3 replacePoint:p withPoint:newP];
    [spoke4 replacePoint:p withPoint:newP];
    [crossBar1 replacePoint:p withPoint:newP];
    [crossBar2 replacePoint:p withPoint:newP];
    [crossBar3 replacePoint:p withPoint:newP];
}
@end
