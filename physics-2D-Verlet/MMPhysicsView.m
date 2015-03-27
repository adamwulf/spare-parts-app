//
//  MMPhysicsView.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/22/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPhysicsView.h"
#import "InstantPanGestureRecognizer.h"
#import "MMPointPropsView.h"
#import "MMPoint.h"
#import "MMStick.h"
#import "MMPiston.h"
#import "MMEngine.h"
#import "MMSpring.h"
#import "MMBalloon.h"
#import "MMWheel.h"

#define kMaxStress 0.5

@implementation MMPhysicsView{
    CGFloat bounce;
    CGFloat gravity;
    CGFloat friction;
    
    NSMutableArray* points;
    NSMutableArray* sticks;
    NSMutableArray* balloons;
    
    MMPoint* grabbedPoint;
    
    UIPanGestureRecognizer* grabPointGesture;
    InstantPanGestureRecognizer* createStickGesture;
    InstantPanGestureRecognizer* createPistonGesture;
    InstantPanGestureRecognizer* createSpringGesture;
    InstantPanGestureRecognizer* createEngineGesture;
    UITapGestureRecognizer* createBalloonGesture;
    UITapGestureRecognizer* createWheelGesture;
    UITapGestureRecognizer* selectPointGesture;
    
    UISwitch* animationOnOffSwitch;
    
    
    MMStick* currentEditedStick;
    
    
    MMPointPropsView* propertiesView;
    MMPoint* selectedPoint;
    
    
    NSMutableSet* processedPoints;
}

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        
        bounce = 0.9;
        gravity = 0.5;
        friction = 0.999;
        
        processedPoints = [NSMutableSet set];
        
        points = [NSMutableArray array];
        sticks = [NSMutableArray array];
        balloons = [NSMutableArray array];
        
        propertiesView = [[MMPointPropsView alloc] initWithFrame:CGRectMake(20, 20, 200, 250)];
        [self addSubview:propertiesView];
        
        [self initializeData];
        
        CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkPresentRenderBuffer:)];
        displayLink.frameInterval = 2;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        
        grabPointGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePointGesture:)];
        createStickGesture.enabled = NO;
        [self addGestureRecognizer:grabPointGesture];
        
        createStickGesture = [[InstantPanGestureRecognizer alloc] initWithTarget:self action:@selector(createStickGesture:)];
        [self addGestureRecognizer:createStickGesture];
        
        createPistonGesture = [[InstantPanGestureRecognizer alloc] initWithTarget:self action:@selector(createPistonGesture:)];
        createPistonGesture.enabled = NO;
        [self addGestureRecognizer:createPistonGesture];
        
        createSpringGesture = [[InstantPanGestureRecognizer alloc] initWithTarget:self action:@selector(createSpringGesture:)];
        createSpringGesture.enabled = NO;
        [self addGestureRecognizer:createSpringGesture];
        
        createEngineGesture = [[InstantPanGestureRecognizer alloc] initWithTarget:self action:@selector(createEngineGesture:)];
        createEngineGesture.enabled = NO;
        [self addGestureRecognizer:createEngineGesture];
        
        
        selectPointGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
        [self addGestureRecognizer:selectPointGesture];
        
        
        createBalloonGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createBalloonGesture:)];
        createBalloonGesture.enabled = NO;
        [self addGestureRecognizer:createBalloonGesture];
        
        createWheelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createWheelGesture:)];
        createWheelGesture.enabled = NO;
        [self addGestureRecognizer:createWheelGesture];
        
        
        
        animationOnOffSwitch = [[UISwitch alloc] init];
        animationOnOffSwitch.on = YES;
        animationOnOffSwitch.center = CGPointMake(self.bounds.size.width - 80, 40);
        
        UILabel* onOff = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, animationOnOffSwitch.bounds.size.height)];
        onOff.text = @"on/off";
        onOff.textAlignment = NSTextAlignmentRight;
        onOff.center = CGPointMake(animationOnOffSwitch.center.x - onOff.bounds.size.width, animationOnOffSwitch.center.y);
        [self addSubview:onOff];

        
        UISegmentedControl* createMode = [[UISegmentedControl alloc] initWithItems:@[@"make stick",@"make piston",@"make spring",@"make engine",@"make balloon",@"make wheel",@"move point"]];
        createMode.selectedSegmentIndex = 0;
        createMode.center = CGPointMake(self.bounds.size.width - 350, 80);
        [createMode addTarget:self  action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:createMode];
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


-(void) screenTapped:(UITapGestureRecognizer*)tapGesture{
    selectedPoint = [self getPointNear:[tapGesture locationInView:self]];
    [propertiesView showPointProperties:selectedPoint];
    
}

-(void) clearObjects{
    [points removeAllObjects];
    [sticks removeAllObjects];
    [balloons removeAllObjects];
}

-(void) modeChanged:(UISegmentedControl*)modeSegmentControl{
    createStickGesture.enabled = modeSegmentControl.selectedSegmentIndex == 0;
    createPistonGesture.enabled = modeSegmentControl.selectedSegmentIndex == 1;
    createSpringGesture.enabled = modeSegmentControl.selectedSegmentIndex == 2;
    createEngineGesture.enabled = modeSegmentControl.selectedSegmentIndex == 3;
    createBalloonGesture.enabled = modeSegmentControl.selectedSegmentIndex == 4;
    createWheelGesture.enabled = modeSegmentControl.selectedSegmentIndex == 5;
    grabPointGesture.enabled = modeSegmentControl.selectedSegmentIndex == 6;
    selectPointGesture.enabled = !createWheelGesture.enabled &&
                                 !createBalloonGesture.enabled;
}

-(void) createStickGesture:(InstantPanGestureRecognizer*)panGesture{
    CGPoint currLoc = [panGesture locationInView:self];
    if(panGesture.state == UIGestureRecognizerStateBegan){
        currLoc = panGesture.initialLocationInWindow;

        MMPoint* startPoint = [self getPointNear:currLoc];
        
        if(!startPoint){
            startPoint = [MMPoint pointWithCGPoint:currLoc];
        }

        currentEditedStick = [MMStick stickWithP0:startPoint
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }else if(panGesture.state == UIGestureRecognizerStateEnded ||
             panGesture.state == UIGestureRecognizerStateFailed ||
             panGesture.state == UIGestureRecognizerStateCancelled){
        
        MMPoint* startPoint = currentEditedStick.p0;
        MMPoint* endPoint = [self getPointNear:currLoc];
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


-(void) createPistonGesture:(InstantPanGestureRecognizer*)panGesture{
    CGPoint currLoc = [panGesture locationInView:self];
    if(panGesture.state == UIGestureRecognizerStateBegan){
        currLoc = panGesture.initialLocationInWindow;

        MMPoint* startPoint = [self getPointNear:currLoc];
        
        if(!startPoint){
            startPoint = [MMPoint pointWithCGPoint:currLoc];
        }
        
        currentEditedStick = [MMStick stickWithP0:startPoint
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }else if(panGesture.state == UIGestureRecognizerStateEnded ||
             panGesture.state == UIGestureRecognizerStateFailed ||
             panGesture.state == UIGestureRecognizerStateCancelled){
        
        MMPoint* startPoint = currentEditedStick.p0;
        MMPoint* endPoint = [self getPointNear:currLoc];
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
        
        [sticks addObject:[MMPiston pistonWithP0:startPoint andP1:endPoint]];
    }else if(currentEditedStick){
        currentEditedStick = [MMStick stickWithP0:currentEditedStick.p0
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }
}

-(void) createSpringGesture:(InstantPanGestureRecognizer*)panGesture{
    CGPoint currLoc = [panGesture locationInView:self];
    if(panGesture.state == UIGestureRecognizerStateBegan){
        currLoc = panGesture.initialLocationInWindow;
        
        MMPoint* startPoint = [self getPointNear:currLoc];
        
        if(!startPoint){
            startPoint = [MMPoint pointWithCGPoint:currLoc];
        }
        
        currentEditedStick = [MMStick stickWithP0:startPoint
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }else if(panGesture.state == UIGestureRecognizerStateEnded ||
             panGesture.state == UIGestureRecognizerStateFailed ||
             panGesture.state == UIGestureRecognizerStateCancelled){
        
        MMPoint* startPoint = currentEditedStick.p0;
        MMPoint* endPoint = [self getPointNear:currLoc];
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
        
        [sticks addObject:[MMSpring springWithP0:startPoint andP1:endPoint]];
    }else if(currentEditedStick){
        currentEditedStick = [MMStick stickWithP0:currentEditedStick.p0
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }
}


-(void) createBalloonGesture:(UITapGestureRecognizer*)tapGesture{
    CGPoint currLoc = [tapGesture locationInView:self];
    if(tapGesture.state == UIGestureRecognizerStateRecognized){
        MMBalloon* balloon = [MMBalloon balloonWithCGPoint:currLoc];
        [points addObject:balloon.center];
        [balloons addObject:balloon];
    }
}

-(void) createWheelGesture:(UITapGestureRecognizer*)tapGesture{
    CGPoint currLoc = [tapGesture locationInView:self];
    if(tapGesture.state == UIGestureRecognizerStateRecognized){
        MMWheel* wheel = [MMWheel wheelWithCenter:[MMPoint pointWithCGPoint:currLoc]
                                        andRadius:40];
        [points addObject:wheel.center];
        [points addObject:wheel.p0];
        [points addObject:wheel.p1];
        [points addObject:wheel.p2];
        [points addObject:wheel.p3];
        [sticks addObject:wheel];
    }
}

-(void) createEngineGesture:(InstantPanGestureRecognizer*)panGesture{
    CGPoint currLoc = [panGesture locationInView:self];
    if(panGesture.state == UIGestureRecognizerStateBegan){
        currLoc = panGesture.initialLocationInWindow;

        MMPoint* startPoint = [self getPointNear:currLoc];
        
        if(!startPoint){
            startPoint = [MMPoint pointWithCGPoint:currLoc];
        }
        
        currentEditedStick = [MMStick stickWithP0:startPoint
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }else if(panGesture.state == UIGestureRecognizerStateEnded ||
             panGesture.state == UIGestureRecognizerStateFailed ||
             panGesture.state == UIGestureRecognizerStateCancelled){
        
        MMPoint* startPoint = currentEditedStick.p0;
        MMPoint* endPoint = [self getPointNear:currLoc];
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
        
        MMEngine* engine = (MMEngine*)[MMEngine engineWithP0:startPoint
                                                       andP1:endPoint];
        [points addObject:engine.p2];
        [sticks addObject:engine];
    }else if(currentEditedStick){
        currentEditedStick = [MMStick stickWithP0:currentEditedStick.p0
                                            andP1:[MMPoint pointWithCGPoint:currLoc]];
    }
}

-(void) movePointGesture:(UIPanGestureRecognizer*)panGesture{
    CGPoint currLoc = [panGesture locationInView:self];
    if(panGesture.state == UIGestureRecognizerStateBegan){
//        currLoc = panGesture.initialLocationInWindow;
        // find the point to grab
        grabbedPoint = [self getPointNear:currLoc];
    }
    
    if(panGesture.state == UIGestureRecognizerStateEnded){
        MMPoint* pointToReplace = [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return evaluatedObject != grabbedPoint && [evaluatedObject distanceFromPoint:grabbedPoint.asCGPoint] < 30;
        }]] firstObject];
        if(pointToReplace){
            for(int i=0;i<[sticks count];i++){
                MMStick* stick = [sticks objectAtIndex:i];
                [stick replacePoint:pointToReplace withPoint:grabbedPoint];
                [sticks replaceObjectAtIndex:i withObject:stick];
            }
            for(int i=0;i<[balloons count];i++){
                MMBalloon* balloon = [balloons objectAtIndex:i];
                [balloon replacePoint:pointToReplace withPoint:grabbedPoint];
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
    
    [points makeObjectsPerformSelector:@selector(bump)];
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
        [self tickMachines];
    }
    
    [processedPoints removeAllObjects];
    // constrain everything
    for(int i = 0; i < 5; i++) {
        [self enforceGesture];
        [self updateSticks];
        [self constrainWheels];
        [self constrainBalloons];
        [self constrainPoints];
    }
    
    // remove stressed objects
    [self cullSticks];
    
    // render everything
    [self renderSticks];
    [self renderBalloons];
    
    // render edit
    [currentEditedStick render];


    CGContextRestoreGState(context);
}


#pragma mark - Update Methods

-(void) tickMachines{
    for(MMStick* stick in sticks){
        [stick tick];
    }
}

-(void) enforceGesture{
    if(grabbedPoint){
        if(grabPointGesture.state == UIGestureRecognizerStateBegan ||
           grabPointGesture.state == UIGestureRecognizerStateChanged){
            grabbedPoint.x = [grabPointGesture locationInView:self].x;
            grabbedPoint.y = [grabPointGesture locationInView:self].y;
        }
        if(!animationOnOffSwitch.on){
            for (MMPoint* p in points) {
                [p nullVelocity];
            }
        }
    }
}

-(void) updatePoints{
    for(int i = 0; i < [points count]; i++) {
        MMPoint* p = [points objectAtIndex:i];
        [p updateWithGravity:gravity andFriction:friction];
    }
}

-(void) updateSticks{
    for(int i = 0; i < [sticks count]; i++) {
        MMStick* s = [sticks objectAtIndex:i];
        if(![s isKindOfClass:[MMWheel class]]){
            [s constrain];
        }
    }
}

-(void) constrainWheels{
    // bounce wheels
    for(int i = 0; i < [sticks count]; i++) {
        MMStick* stick = [sticks objectAtIndex:i];
        if([stick isKindOfClass:[MMWheel class]]){
            MMWheel* wheel = (MMWheel*) stick;
            [wheel constrain];
            
            // constrain the wheel
            
            CGFloat moveX = 0;
            CGFloat moveY = 0;
            
            CGFloat deltaVX = 0;
            CGFloat deltaVY = 0;
            
            [processedPoints addObject:wheel.center];
            if(!wheel.center.immovable){
                CGPoint v = [wheel.center velocityForFriction:friction];
                
                if(wheel.center.x > self.bounds.size.width - wheel.radius) {
                    moveX = wheel.center.x - (self.bounds.size.width - wheel.radius);
                    wheel.center.x = self.bounds.size.width - wheel.radius;
                    deltaVX = v.x * bounce;
                    wheel.center.oldx = wheel.center.x + deltaVX;
                }
                else if(wheel.center.x < wheel.radius) {
                    moveX = wheel.center.x - wheel.radius;
                    wheel.center.x = wheel.radius;
                    deltaVX = v.x * bounce;
                    wheel.center.oldx = wheel.center.x + deltaVX;
                }
                if(wheel.center.y > self.bounds.size.height - wheel.radius) {
                    moveY = wheel.center.y - (self.bounds.size.height - wheel.radius);
                    wheel.center.y = self.bounds.size.height - wheel.radius;
                    deltaVY = v.y * bounce;
                    wheel.center.oldy = wheel.center.y + deltaVY;
                }
                else if(wheel.center.y < wheel.radius) {
                    moveY = wheel.center.y - wheel.radius;
                    wheel.center.y = wheel.radius;
                    deltaVY = v.y * bounce;
                    wheel.center.oldy = wheel.center.y + deltaVY;
                }
                
                
                if(moveX || moveY){
                    // update other 4 points
                    for(MMPoint* p in @[wheel.p0, wheel.p1, wheel.p2, wheel.p3]){
                        CGPoint v = [p velocityForFriction:friction];
                        // reverse velocity of the point
                        // maintain relative velocity of point vs center
                        if(moveX){
                            p.x -= moveX;
                            p.oldx = p.x + v.x * bounce - (v.x - deltaVX);
                        }
                        if(moveY){
                            p.y -= moveY;
                            p.oldy = p.y + v.y * bounce - (v.y - deltaVY);
                        }
                    }
                }
                
                [processedPoints addObjectsFromArray:@[wheel.p0, wheel.p1, wheel.p2, wheel.p3]];
            }
        }
    }
}


-(void) constrainBalloons{
    for(MMBalloon* b in balloons) {
        if(![processedPoints containsObject:b.center]){
            [processedPoints addObject:b.center];
            // make sure balloon is inside the box
            if(!b.center.immovable){
                CGFloat vx = (b.center.x - b.center.oldx) * friction;
                CGFloat vy = (b.center.y - b.center.oldy) * friction;
                
                if(b.center.x > self.bounds.size.width - b.radius) {
                    b.center.x = self.bounds.size.width - b.radius;
                    b.center.oldx = b.center.x + vx * bounce;
                }
                else if(b.center.x < b.radius) {
                    b.center.x = b.radius;
                    b.center.oldx = b.center.x + vx * bounce;
                }
                if(b.center.y > self.bounds.size.height - b.radius) {
                    b.center.y = self.bounds.size.height - b.radius;
                    b.center.oldy = b.center.y + vy * bounce;
                }
                else if(b.center.y < b.radius) {
                    b.center.y = b.radius;
                    b.center.oldy = b.center.y + vy * bounce;
                }
            }
            // make sure the balloon isn't hitting other balloons
            for(MMBalloon* otherB in balloons) {
                if(otherB != b){
                    CGFloat dist = [otherB.center distanceFromPoint:b.center.asCGPoint];
                    CGFloat movement = (otherB.radius + b.radius) - dist;
                    if(movement > 0){
                        // collision!
                        
                        // fix their offset to be outside their
                        // combined radius
                        CGPoint distToMove = [otherB.center differenceFrom:b.center];
                        distToMove.x = (dist != 0) ? distToMove.x / dist : dist;
                        distToMove.y = (dist != 0) ? distToMove.y / dist : dist;
                        distToMove.x *= movement;
                        distToMove.y *= movement;
                        
                        b.center.x -= distToMove.x / 2;
                        b.center.y -= distToMove.y / 2;
                        otherB.center.x += distToMove.x / 2;
                        otherB.center.y += distToMove.y / 2;
                    }
                }
            }
        }
    }
}

-(void) constrainPoints{
    for(int i = 0; i < [points count]; i++) {
        MMPoint* p = [points objectAtIndex:i];
        if(![processedPoints containsObject:p]){
            [processedPoints addObject:p];
            if(!p.immovable){
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
    }
}


#pragma mark - Remove Stressed Objects

-(void) cullSticks{
    for(int i = 0; i < [sticks count]; i++) {
        MMStick* s = [sticks objectAtIndex:i];
        if(s.stress >= kMaxStress){
            // break stick
            [sticks removeObject:s];
            
            CGPoint p0 = s.p0.asCGPoint;
            CGPoint p3 = s.p1.asCGPoint;
            
            CGFloat xDiff = p3.x - p0.x;
            CGFloat yDiff = p3.y - p0.y;
            
            CGPoint p1 = CGPointMake(p0.x + .3*xDiff,
                                     p0.y + .3*yDiff);
            CGPoint p2 = CGPointMake(p0.x + .6*xDiff,
                                     p0.y + .6*yDiff);
            
            MMStick* s1 = [MMStick stickWithP0:[MMPoint pointWithCGPoint:p0]
                                         andP1:[MMPoint pointWithCGPoint:p1]];
            MMStick* s2 = [MMStick stickWithP0:[MMPoint pointWithCGPoint:p1]
                                         andP1:[MMPoint pointWithCGPoint:p2]];
            MMStick* s3 = [MMStick stickWithP0:[MMPoint pointWithCGPoint:p2]
                                         andP1:[MMPoint pointWithCGPoint:p3]];
            
            NSArray* newPoints = @[s1.p0, s1.p1, s2.p0, s2.p1, s3.p0, s3.p1];
            [newPoints makeObjectsPerformSelector:@selector(bump)];
            [sticks addObjectsFromArray:@[s1, s2, s3]];
            [points addObjectsFromArray:newPoints];
            
            // clean up unused points
            // remove s.p0, s.p1 if needed
            // later.
            //
            // actually, i dont think p0 or
            // p1 will ever be orphaned without
            // a stick, because a stressed stick
            // will always share points with
            // something else.
            i--;
        }
    }
}

#pragma mark - Render

-(void) renderSticks{
    for(MMStick* stick in sticks){
        [stick render];
    }
}

-(void) renderBalloons{
    for(MMBalloon* balloon in balloons){
        [balloon render];
    }
}



#pragma mark - Helper

-(MMPoint*) getPointNear:(CGPoint)point{
    return [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject distanceFromPoint:point] < 30;
    }]] firstObject];
}

@end
