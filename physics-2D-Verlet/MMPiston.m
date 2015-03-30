//
//  MMPiston.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/24/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPiston.h"
#import "Constants.h"

@implementation MMPiston{
    CGFloat angle;
}

-(void) setAngle:(CGFloat)_angle{
    angle = _angle;
}

+(MMStick*) pistonWithP0:(MMPoint*)p0 andP1:(MMPoint*)p1{
    return [[MMPiston alloc] initWithP0:p0 andP1:p1];
}

-(CGFloat) length{
    return [super length] * .8 +
    [super length]*.2*cosf(angle);
}

-(void) tick{
    angle += .1;
    [super tick];
}


-(void) render{
    
    UIImage* baseImage = [UIImage imageNamed:@"piston-base.png"];
    UIImage* headImage = [UIImage imageNamed:@"piston-head.png"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // translate
    CGContextTranslateCTM(context, self.p0.x, self.p0.y);
    // rotate
    CGFloat rot = atan2f(self.p1.x - self.p0.x, self.p1.y - self.p0.y);
    CGContextRotateCTM(context, -rot + M_PI/2);
    

    // draw our board image
    [headImage drawInRect:CGRectMake(.6*[super length] - 2*kPointRadius,
                                     -kStickWidth/2 + 2,
                                     [self length] - .6*[super length] + kStickWidth/2 + 2*kPointRadius,
                                     kStickWidth - 4)];
    
    // draw our board image
    [baseImage drawInRect:CGRectMake(-kStickWidth/2, -kStickWidth/2, .6*[super length] + kStickWidth - 2*kPointRadius, kStickWidth)];
    
    
    // render our nails / screws
    [self.p0 renderAtZeroZero];
    CGContextTranslateCTM(context, [self calcLen], 0);
    [self.p1 renderAtZeroZero];
    
    CGContextRestoreGState(context);
}


@end
