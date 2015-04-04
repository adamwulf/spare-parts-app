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
        
        self.opaque = NO;
        
        CGFloat radius = 3600;
        UIBezierPath* curve = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, frame.size.height/2)
                                                             radius:radius
                                                         startAngle:0
                                                           endAngle:2*M_PI
                                                          clockwise:YES];
        CAShapeLayer* background = [CAShapeLayer layer];
        background.backgroundColor = [UIColor clearColor].CGColor;
        background.path = curve.CGPath;
        background.fillColor = [UIColor clearColor].CGColor;
        background.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:.5].CGColor;
        background.lineWidth = 4;
        
        [self.layer addSublayer:background];
        background.position = CGPointMake(radius, 0);
        
        // mask
        CAShapeLayer* mask = [CAShapeLayer layer];
        mask.backgroundColor = [UIColor clearColor].CGColor;
        mask.path = curve.CGPath;
        mask.fillColor = [UIColor whiteColor].CGColor;
        mask.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:.5].CGColor;
        mask.lineWidth = 4;
        mask.position = CGPointMake(radius, 0);
        
        self.layer.mask = mask;
        

        UIView* bitsOfWhite = [[UIView alloc] initWithFrame:self.bounds];
        bitsOfWhite.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        beView.frame = self.bounds;
        [beView.contentView addSubview:bitsOfWhite];
        [self insertSubview:beView atIndex:0];
    }
    return self;
}

@end
