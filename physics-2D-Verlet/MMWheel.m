//
//  MMWheel.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/26/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMWheel.h"
#import "MMPoint.h"
#import "Constants.h"

@implementation MMWheel{
    MMStick* spoke1;
    MMStick* spoke2;

    MMStick* spoke3;
    MMStick* spoke4;
    MMStick* crossBar1;
    MMStick* crossBar2;
    MMStick* crossBar3;
    MMStick* crossBar4;
    MMStick* crossBar5;
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
    _p0.x = _p0.x - _radius + kPointRadius;
    _p1.x = _p1.x + _radius - kPointRadius;
    [_p0 nullVelocity];
    [_p1 nullVelocity];

    if(self = [super initWithP0:_p0 andP1:_p1]){
        center = _center;
        spoke1 = [MMStick stickWithP0:_p0 andP1:center];
        spoke2 = [MMStick stickWithP0:center andP1:_p1];
        radius = _radius;
        
        // create other spokes
        p2 = [MMPoint pointWithCGPoint:_center.asCGPoint];
        p3 = [MMPoint pointWithCGPoint:_center.asCGPoint];
        p2.y = p2.y - _radius + kPointRadius;
        p3.y = p3.y + _radius - kPointRadius;
        [p2 nullVelocity];
        [p3 nullVelocity];

        spoke3 = [MMStick stickWithP0:p2 andP1:center];
        spoke4 = [MMStick stickWithP0:center andP1:p3];
        crossBar1 = [MMStick stickWithP0:p2 andP1:p3];

        crossBar2 = [MMStick stickWithP0:_p0 andP1:p2];
        crossBar3 = [MMStick stickWithP0:_p0 andP1:p3];
        crossBar4 = [MMStick stickWithP0:_p1 andP1:p2];
        crossBar5 = [MMStick stickWithP0:_p1 andP1:p3];
        
    }
    return self;
}

-(void) setRadius:(CGFloat)_radius{
    radius = _radius;
    self.length = 2*radius;
    crossBar1.length = 2*radius;
    CGFloat sqrttwo = sqrtf(2.0f);
    crossBar2.length = radius*sqrttwo;
    crossBar3.length = radius*sqrttwo;
    crossBar4.length = radius*sqrttwo;
    crossBar5.length = radius*sqrttwo;
    spoke1.length = radius;
    spoke2.length = radius;
    spoke3.length = radius;
    spoke4.length = radius;
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
    [crossBar4 tick];
    [crossBar5 tick];
}

-(void) constrainCollisionsWith:(NSArray*)sticks{
    // make sure the balloon isn't hitting other balloons
    for(MMStick* stick in sticks) {
        if(stick != self){
            if([stick isKindOfClass:[MMWheel class]]){
                MMWheel* otherW = (MMWheel*)stick;
                CGFloat dist = [otherW.center distanceFromPoint:self.center.asCGPoint];
                CGFloat movement = (otherW.radius + self.radius) - dist;
                if(movement > 0){
                    // collision!
                    
                    // fix their offset to be outside their
                    // combined radius
                    CGPoint distToMove = [otherW.center differenceFrom:self.center];
                    distToMove.x = (dist != 0) ? distToMove.x / dist : dist;
                    distToMove.y = (dist != 0) ? distToMove.y / dist : dist;
                    distToMove.x *= movement;
                    distToMove.y *= movement;
                    
                    self.center.x -= distToMove.x / 2;
                    self.center.y -= distToMove.y / 2;
                    otherW.center.x += distToMove.x / 2;
                    otherW.center.y += distToMove.y / 2;
                }
            }
        }
    }
}


-(void) constrain{
    [super constrain];
    [spoke1 constrain];
    [spoke2 constrain];
    [spoke3 constrain];
    [spoke4 constrain];
    [crossBar1 constrain];
    [crossBar2 constrain];
    [crossBar3 constrain];
    [crossBar4 constrain];
    [crossBar5 constrain];
}


-(void) render{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    UIBezierPath* wheel = [UIBezierPath bezierPathWithArcCenter:center.asCGPoint
                                                           radius:radius
                                                       startAngle:0
                                                         endAngle:2*M_PI
                                                        clockwise:YES];
    [wheel addClip];
    
    
    
    
    // translate
    CGContextTranslateCTM(context, center.x, center.y);
    // rotate
    CGFloat angle = atan2f(self.p1.x - self.center.x, self.p1.y - self.center.y);
    CGContextRotateCTM(context, -angle + M_PI/2);

    UIImage* wheelImage = [UIImage imageNamed:@"wheel.png"];
    
    [wheelImage drawInRect:CGRectMake(-radius, -radius, radius*2, radius*2)];
    
    [center renderAtZeroZero];
    
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -radius+kPointRadius, 0);
    [self.p0 renderAtZeroZero];
    CGContextRestoreGState(context);

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, radius-kPointRadius, 0);
    [self.p1 renderAtZeroZero];
    CGContextRestoreGState(context);

    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, -radius+kPointRadius);
    [self.p2 renderAtZeroZero];
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, radius-kPointRadius);
    [self.p3 renderAtZeroZero];
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);

    
//    [super render];
//    [spoke1 render];
//    [spoke2 render];
//    [spoke3 render];
//    [spoke4 render];
//    [crossBar1 render];
//    [crossBar2 render];
//    [crossBar3 render];
//    [crossBar4 render];
//    [crossBar5 render];
    
}

-(BOOL) replacePoint:(MMPoint*)p withPoint:(MMPoint*)newP{
    [super replacePoint:p withPoint:newP];
    [spoke1 replacePoint:p withPoint:newP];
    [spoke2 replacePoint:p withPoint:newP];
    [spoke3 replacePoint:p withPoint:newP];
    [spoke4 replacePoint:p withPoint:newP];
    [crossBar1 replacePoint:p withPoint:newP];
    [crossBar2 replacePoint:p withPoint:newP];
    [crossBar3 replacePoint:p withPoint:newP];
    [crossBar4 replacePoint:p withPoint:newP];
    [crossBar5 replacePoint:p withPoint:newP];
    if(p == center){
        center = newP;
    }
    if(p == p2){
        p2 = newP;
    }
    if(p == p3){
        p3 = newP;
    }
    return YES;
}


-(CGFloat) distanceFromPoint:(CGPoint)point{
    return MAX(0,[center distanceFromPoint:point] - radius);
}

-(MMStick*) cloneObject{
    return [MMWheel wheelWithCenter:[MMPoint pointWithCGPoint:center.asCGPoint]
                          andRadius:radius];
}

-(NSArray*) allPoints{
    return [[super allPoints] arrayByAddingObjectsFromArray:@[self.p2, self.p3, self.center]];
}

#pragma mark - NSCoding

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.center forKey:@"center"];
    [aCoder encodeObject:self.p2 forKey:@"p2"];
    [aCoder encodeObject:self.p3 forKey:@"p3"];
    [aCoder encodeObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    MMPoint* _center = [aDecoder decodeObjectForKey:@"center"];
    CGFloat _radius = [[aDecoder decodeObjectForKey:@"radius"] floatValue];
    if(self = [self initWithCenter:_center andRadius:_radius]){
        // noop
        [self replacePoint:self.p0 withPoint:[aDecoder decodeObjectForKey:@"p0"]];
        [self replacePoint:self.p1 withPoint:[aDecoder decodeObjectForKey:@"p1"]];
        [self replacePoint:self.p2 withPoint:[aDecoder decodeObjectForKey:@"p2"]];
        [self replacePoint:self.p3 withPoint:[aDecoder decodeObjectForKey:@"p3"]];
    }
    return self;
}

@end
