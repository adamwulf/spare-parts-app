//
//  Renderable.m
//  spareparts
//
//  Created by Adam Wulf on 4/4/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "Renderable.h"
#import <UIKit/UIKit.h>
#import "Constants.h"

@implementation Renderable

-(void) renderWithHighlight{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeZero, kShadowWidth, [[UIColor whiteColor] colorWithAlphaComponent:kShadowOpacity].CGColor);
    [self render];
    CGContextRestoreGState(context);
}

-(void) render{
    
}

-(void) renderAtZeroZero{
    
}

@end
