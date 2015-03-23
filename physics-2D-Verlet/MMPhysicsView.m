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
    
    UIPanGestureRecognizer* grabPointGesture;
    UIPanGestureRecognizer* createStickGesture;
    
    UISwitch* animationOnOffSwitch;
    
    
    MMStick* currentEditedStick;
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
        
        
        grabPointGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePointGesture:)];
        [self addGestureRecognizer:grabPointGesture];
        
        createStickGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(createStickGesture:)];
        createStickGesture.enabled = NO;
        [self addGestureRecognizer:createStickGesture];
        
        
        
        
        animationOnOffSwitch = [[UISwitch alloc] init];
        animationOnOffSwitch.on = YES;
        animationOnOffSwitch.center = CGPointMake(self.bounds.size.width - 80, 40);
        
        UILabel* onOff = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, animationOnOffSwitch.bounds.size.height)];
        onOff.text = @"on/off";
        onOff.textAlignment = NSTextAlignmentRight;
        onOff.center = CGPointMake(animationOnOffSwitch.center.x - onOff.bounds.size.width, animationOnOffSwitch.center.y);
        [self addSubview:onOff];

        
        
        UISwitch* createModeSwitch = [[UISwitch alloc] init];
        createModeSwitch.on = YES;
        createModeSwitch.center = CGPointMake(self.bounds.size.width - 80, 80);
        [createModeSwitch addTarget:self  action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
        onOff = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, createModeSwitch.bounds.size.height)];
        onOff.text = @"make / move";
        onOff.textAlignment = NSTextAlignmentRight;
        onOff.center = CGPointMake(createModeSwitch.center.x - onOff.bounds.size.width, createModeSwitch.center.y);
        [self addSubview:onOff];
        
        [self addSubview:createModeSwitch];
        [self addSubview:animationOnOffSwitch];
        
        
        UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
        [clearButton sizeToFit];
        [clearButton addTarget:self action:@selector(clearObjects) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearButton];
        clearButton.center = CGPointMake(self.bounds.size.width - 50, 200);
        
    }
    return self;
}

#pragma mark - Gesture

-(void) clearObjects{
    [points removeAllObjects];
    [sticks removeAllObjects];
}

-(void) modeChanged:(UISwitch*)modeSwitch{
    grabPointGesture.enabled = modeSwitch.on;
    createStickGesture.enabled = !modeSwitch.on;
}

-(void) createStickGesture:(UIPanGestureRecognizer*)panGester{
    CGPoint currLoc = [panGester locationInView:self];
    if(panGester.state == UIGestureRecognizerStateBegan){

        MMPoint* startPoint = [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject distanceFromPoint:currLoc] < 30;
        }]] firstObject];
        
        if(!startPoint){
            startPoint = [MMPoint pointWithCGPoint:currLoc];
        }

        currentEditedStick = [MMStick stickWithP0:startPoint
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }else if(panGester.state == UIGestureRecognizerStateEnded ||
             panGester.state == UIGestureRecognizerStateFailed ||
             panGester.state == UIGestureRecognizerStateCancelled){
        
        MMPoint* startPoint = currentEditedStick.p0;
        MMPoint* endPoint = [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject distanceFromPoint:currLoc] < 30;
        }]] firstObject];
        if(!endPoint){
            endPoint = currentEditedStick.p1;
        }
        if(![points containsObject:startPoint]){
            [points addObject:startPoint];
        }
        if(![points containsObject:endPoint]){
            [points addObject:endPoint];
        }
        currentEditedStick = nil;

        [sticks addObject:[MMStick stickWithP0:startPoint andP1:endPoint]];
    }else if(currentEditedStick){
        currentEditedStick = [MMStick stickWithP0:currentEditedStick.p0
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }
}

-(void) movePointGesture:(UIPanGestureRecognizer*)panGester{
    CGPoint currLoc = [panGester locationInView:self];
    if(panGester.state == UIGestureRecognizerStateBegan){
        // find the point to grab
        grabbedPoint = [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject distanceFromPoint:currLoc] < 20;
        }]] firstObject];
    }
    
    if(panGester.state == UIGestureRecognizerStateEnded){
        MMPoint* pointToReplace = [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return evaluatedObject != grabbedPoint && [evaluatedObject distanceFromPoint:grabbedPoint.asCGPoint] < 20;
        }]] firstObject];
        if(pointToReplace){
            for(int i=0;i<[sticks count];i++){
                MMStick* stick = [sticks objectAtIndex:i];
                if(stick.p0 == pointToReplace){
                    stick = [MMStick stickWithP0:grabbedPoint andP1:stick.p1];
                }else if(stick.p1 == pointToReplace){
                    stick = [MMStick stickWithP0:stick.p0 andP1:grabbedPoint];
                }
                [sticks replaceObjectAtIndex:i withObject:stick];
            }
            [points removeObject:pointToReplace];
        }
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
    

    if(animationOnOffSwitch.on){
        // gravity + velocity etc
        [self updatePoints];
    }
    
    [self enforceGesture];

    // constrain everything
    for(int i = 0; i < 5; i++) {
        [self updateSticks];
        [self constrainPoints];
    }
    
    // render everything
    [self renderSticks];
    
    // render edit
    [currentEditedStick render];


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
        if(grabPointGesture.state == UIGestureRecognizerStateBegan ||
           grabPointGesture.state == UIGestureRecognizerStateChanged){
            grabbedPoint.x = [grabPointGesture locationInView:self].x;
            grabbedPoint.y = [grabPointGesture locationInView:self].y;
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
