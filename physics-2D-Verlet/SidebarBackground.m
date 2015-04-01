//
//  SidebarBackground.m
//  spareparts
//
//  Created by Adam Wulf on 3/31/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "SidebarBackground.h"

@implementation SidebarBackground

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGFloat radius = 3600;
        UIBezierPath* curve = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, frame.size.height/2)
                                                             radius:radius
                                                         startAngle:0
                                                           endAngle:2*M_PI
                                                          clockwise:YES];
        CAShapeLayer* background = [CAShapeLayer layer];
        background.backgroundColor = [UIColor clearColor].CGColor;
        background.path = curve.CGPath;
        background.fillColor = [UIColor lightGrayColor].CGColor;
        background.strokeColor = [UIColor grayColor].CGColor;
        background.lineWidth = 4;
        
        [self.layer addSublayer:background];
        background.position = CGPointMake(radius - frame.size.width, 0);
    }
    return self;
}

@end
