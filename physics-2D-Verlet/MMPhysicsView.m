//
//  MMPhysicsView.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/22/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPhysicsView.h"
#import "MMPoint.h"
#import "MMStick.h"

@implementation MMPhysicsView{
    CGFloat bounce;
    CGFloat gravity;
    CGFloat friction;
    
    NSMutableArray* points;
    NSMutableArray* sticks;
    
    MMPoint* grabbedPoint;
    
    UIPanGestureRecognizer* panGesture;
}

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        bounce = 0.9;
        gravity = 0.5;
        friction = 0.999;
        
        points = [NSMutableArray array];
        sticks = [NSMutableArray array];
        
        [self initializeData];
        
        CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkPresentRenderBuffer:)];
        displayLink.frameInterval = 2;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:panGesture];
        
    }
    return self;
}

#pragma mark - Gesture

-(void) panGesture:(UIPanGestureRecognizer*)panGester{
    CGPoint currLoc = [panGester locationInView:self];
    if(panGester.state == UIGestureRecognizerStateBegan){
        // find the point to grab
        grabbedPoint = [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject distanceFromPoint:currLoc] < 20;
        }]] firstObject];
    }
}


#pragma mark - Data

-(void) initializeData{
    [points addObject:[MMPoint pointWithX:100 andY:100]];
    [points addObject:[MMPoint pointWithX:200 andY:100]];
    [points addObject:[MMPoint pointWithX:200 andY:200]];
    [points addObject:[MMPoint pointWithX:100 andY:200]];
    
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:0]
                                     andP1:[points objectAtIndex:1]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:1]
                                     andP1:[points objectAtIndex:2]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:2]
                                     andP1:[points objectAtIndex:3]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:3]
                                     andP1:[points objectAtIndex:0]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:0]
                                     andP1:[points objectAtIndex:2]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:1]
                                     andP1:[points objectAtIndex:3]]];
    

}


-(void) displayLinkPresentRenderBuffer:(CADisplayLink*)link{
    [self setNeedsDisplay];
}

#pragma mark - Animation Loop

-(void) drawRect:(CGRect)rect{
    // draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // clear
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    

    // gravity + velocity etc
    [self updatePoints];
    
    [self enforceGesture];

    // constrain everything
    for(int i = 0; i < 5; i++) {
        [self updateSticks];
        [self constrainPoints];
    }
    
    // render everything
    [self renderSticks];


    CGContextRestoreGState(context);
}


#pragma mark - Update Methods

-(void) renderSticks{
    for(MMStick* stick in sticks){
        [stick render];
    }
}

-(void) enforceGesture{
    if(grabbedPoint){
        if(panGesture.state == UIGestureRecognizerStateBegan ||
           panGesture.state == UIGestureRecognizerStateChanged){
            grabbedPoint.x = [panGesture locationInView:self].x;
            grabbedPoint.y = [panGesture locationInView:self].y;
        }
    }
}

-(void) updatePoints{
    for(int i = 0; i < [points count]; i++) {
        MMPoint* p = [points objectAtIndex:i];
        CGFloat vx = (p.x - p.oldx) * friction;
        CGFloat vy = (p.y - p.oldy) * friction;
        
        p.oldx = p.x;
        p.oldy = p.y;
        p.x += vx;
        p.y += vy;
        p.y += gravity;
    }
}

-(void) updateSticks{
    for(int i = 0; i < [sticks count]; i++) {
        MMStick* s = [sticks objectAtIndex:i];
        CGFloat dx = s.p1.x - s.p0.x;
        CGFloat dy = s.p1.y - s.p0.y;
        CGFloat distance = sqrtf(dx * dx + dy * dy);
        CGFloat difference = s.length - distance;
        CGFloat percent = difference / distance / 2;
        if(isnan(percent)){
            percent = 0;
        }
        CGFloat offsetX = dx * percent;
        CGFloat offsetY = dy * percent;
        
        s.p0.x -= offsetX;
        s.p0.y -= offsetY;
        s.p1.x += offsetX;
        s.p1.y += offsetY;
    }
}

-(void) constrainPoints{
    for(int i = 0; i < [points count]; i++) {
        MMPoint* p = [points objectAtIndex:i];
        CGFloat vx = (p.x - p.oldx) * friction;
        CGFloat vy = (p.y - p.oldy) * friction;
        
        if(p.x > self.bounds.size.width) {
            p.x = self.bounds.size.width;
            p.oldx = p.x + vx * bounce;
        }
        else if(p.x < 0) {
            p.x = 0;
            p.oldx = p.x + vx * bounce;
        }
        if(p.y > self.bounds.size.height) {
            p.y = self.bounds.size.height;
            p.oldy = p.y + vy * bounce;
        }
        else if(p.y < 0) {
            p.y = 0;
            p.oldy = p.y + vy * bounce;
        }
    }
}


@end
