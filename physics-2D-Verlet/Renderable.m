//
//  Renderable.m
//  spareparts
//
//  Created by Adam Wulf on 4/4/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "Renderable.h"
#import "Constants.h"

@implementation Renderable

-(id) init{
    if(self = [super init]){
        shadowOpacity = kShadowOpacity;
        shadowSize = kShadowWidth;
    }
    return self;
}

@synthesize shadowOpacity;
@synthesize shadowSize;

-(void) renderWithHighlight{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeZero, self.shadowSize, [[UIColor whiteColor] colorWithAlphaComponent:self.shadowOpacity].CGColor);
    [self render];
    CGContextRestoreGState(context);
}

-(void) render{
    
}

-(void) renderAtZeroZero{
    
}

@end
