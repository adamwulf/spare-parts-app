//
//  MMPhysicsView.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/22/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPhysicsView.h"

@implementation MMPhysicsView{
    CGPoint p1;
    CGPoint p2;
}

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:self.bounds];
        lbl.text = @"2D Physics with sticks and lines!";
        [self addSubview:lbl];

        
        p1 = CGPointMake(100, 100);
        p2 = CGPointMake(200, 200);
        
        CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkPresentRenderBuffer:)];
        displayLink.frameInterval = 2;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void) updatePoints{
    p1.x += rand() % 3 - 1;
    p1.y += rand() % 3 - 1;

    p2.x += rand() % 3 - 1;
    p2.y += rand() % 3 - 1;
}


-(void) displayLinkPresentRenderBuffer:(CADisplayLink*)link{
    
    [self updatePoints];
    
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
    
    CGContextRestoreGState(context);
}

@end
