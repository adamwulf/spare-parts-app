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
#import "MMStickPropsView.h"
#import "MMPoint.h"
#import "MMStick.h"
#import "MMPiston.h"
#import "MMEngine.h"
#import "MMSpring.h"
#import "MMBalloon.h"
#import "MMWheel.h"
#import "Constants.h"

#define kMaxStress 0.5

@implementation MMPhysicsView{
    CGFloat bounce;
    CGFloat gravity;
    CGFloat friction;
    
    NSMutableArray* points;
    NSMutableArray* sticks;
    NSMutableArray* balloons;

    // stuff for the move gesture
    MMStick* grabbedStick;
    CGPoint grabbedStickOffsetP0;
    CGPoint grabbedStickOffsetP1;
    MMPoint* grabbedPoint;
    
    // all of the gestures
    UITapGestureRecognizer* selectGesture;
    UIPanGestureRecognizer* grabPointGesture;
    
    // toggle running the simulation on/off
    UIButton* animationOnOffSwitch;
    
    // the stick that's currently being made
    MMStick* currentEditedStick;
    
    
    MMPointPropsView* pointPropertiesView;
    MMStickPropsView* stickPropertiesView;
    MMPoint* selectedPoint;
    MMStick* selectedStick;
    
    NSMutableSet* processedPoints;
    
    NSMutableArray* defaultObjects;
}

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        bounce = 0.9;
        gravity = 0.5;
        friction = 0.999;
        
        processedPoints = [NSMutableSet set];
        
        points = [NSMutableArray array];
        sticks = [NSMutableArray array];
        balloons = [NSMutableArray array];
        
        pointPropertiesView = [[MMPointPropsView alloc] initWithFrame:CGRectMake(20, 20, 200, 250)];
        [self addSubview:pointPropertiesView];
        
        stickPropertiesView = [[MMStickPropsView alloc] initWithFrame:CGRectMake(20, 20, 200, 250)];
        [self addSubview:stickPropertiesView];
        
        [self initializeData];
        
        CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkPresentRenderBuffer:)];
        displayLink.frameInterval = 2;
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        
        selectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPointGesture:)];
        [self addGestureRecognizer:selectGesture];
        
        grabPointGesture = [[InstantPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePointGesture:)];
        [self addGestureRecognizer:grabPointGesture];
        
        animationOnOffSwitch = [UIButton buttonWithType:UIButtonTypeCustom];
        [animationOnOffSwitch setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [animationOnOffSwitch setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
        [animationOnOffSwitch sizeToFit];
        animationOnOffSwitch.center = CGPointMake(self.bounds.size.width - 180, 80);
        [animationOnOffSwitch addTarget:self action:@selector(toggleAnimation:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:animationOnOffSwitch];


        UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setImage:[UIImage imageNamed:@"trash.png"] forState:UIControlStateNormal];
        [clearButton sizeToFit];
        [clearButton addTarget:self action:@selector(clearObjects) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearButton];
        clearButton.center = CGPointMake(self.bounds.size.width - 80, 80);
        
        
        // initialize default objects in the sidebar
        defaultObjects = [NSMutableArray array];
        
        CGFloat sidebarLeft = self.bounds.size.width - 230;
        CGFloat sidebarRight = self.bounds.size.width - 60;
        [defaultObjects addObject:[MMStick stickWithP0:[MMPoint pointWithX:sidebarLeft andY:200]
                                                 andP1:[MMPoint pointWithX:sidebarRight andY:240]]];
        [defaultObjects addObject:[MMPiston pistonWithP0:[MMPoint pointWithX:sidebarLeft andY:300]
                                                   andP1:[MMPoint pointWithX:sidebarRight andY:340]]];
        [defaultObjects addObject:[MMEngine engineWithP0:[MMPoint pointWithX:sidebarLeft andY:400]
                                                   andP1:[MMPoint pointWithX:sidebarRight andY:440]]];
        [defaultObjects addObject:[MMSpring springWithP0:[MMPoint pointWithX:sidebarLeft andY:500]
                                                   andP1:[MMPoint pointWithX:sidebarRight andY:540]]];
        [defaultObjects addObject:[MMBalloon balloonWithCGPoint:CGPointMake(sidebarLeft, 600)]];
        [defaultObjects addObject:[MMWheel wheelWithCenter:[MMPoint pointWithX:sidebarLeft + 100 andY:680]
                                                 andRadius:kWheelRadius]];
    }
    return self;
}

#pragma mark - Gesture

-(void) toggleAnimation:(UIButton*)button{
    button.selected = !button.selected;
}

-(void) clearObjects{
    [points removeAllObjects];
    [sticks removeAllObjects];
    [balloons removeAllObjects];
}

-(void) tapPointGesture:(UITapGestureRecognizer*)tapGesture{
    CGPoint currLoc = [tapGesture locationInView:self];
    if(tapGesture.state == UIGestureRecognizerStateRecognized){
        selectedPoint = [self getPointNear:currLoc];
        selectedStick = nil;
        if(!selectedPoint){
            selectedStick = [self getStickNear:currLoc];
        }
        [pointPropertiesView showPointProperties:selectedPoint];
        [stickPropertiesView showObjectProperties:selectedStick];
    }
}

-(void) movePointGesture:(InstantPanGestureRecognizer*)panGesture{
    if(panGesture.state == UIGestureRecognizerStateBegan){
        CGPoint currLoc = panGesture.initialLocationInWindow;
        // find the point to grab
        MMStick* stick = [self getSidebarObject:currLoc];
        if(stick){
            stick = [stick cloneObject];
            // we just created a new object
            [points addObjectsFromArray:[stick allPoints]];
            if([stick isKindOfClass:[MMBalloon class]]){
                [balloons addObject:stick];
                grabbedPoint = [((MMBalloon*)stick) center];
            }else{
                [sticks addObject:stick];
                grabbedStick = stick;
                grabbedStickOffsetP0 = CGPointMake(currLoc.x - grabbedStick.p0.x,
                                                   currLoc.y - grabbedStick.p0.y);
                grabbedStickOffsetP1 = CGPointMake(currLoc.x - grabbedStick.p1.x,
                                                   currLoc.y - grabbedStick.p1.y);
            }
        }else{
            grabbedPoint = [self getPointNear:currLoc];
            if(!grabbedPoint){
                grabbedStick = [self getStickNear:currLoc];
                NSLog(@"got stick %@", [grabbedStick class]);
                grabbedStickOffsetP0 = CGPointMake(currLoc.x - grabbedStick.p0.x,
                                                   currLoc.y - grabbedStick.p0.y);
                grabbedStickOffsetP1 = CGPointMake(currLoc.x - grabbedStick.p1.x,
                                                   currLoc.y - grabbedStick.p1.y);
            }else{
                NSLog(@"got point %@", [grabbedPoint class]);
            }
        }
    }
    
    if(panGesture.state == UIGestureRecognizerStateEnded){
        for (MMPoint* pointToSnap in (grabbedPoint ? @[grabbedPoint] : [grabbedStick allPoints])) {
            MMPoint* pointToReplace = [[points filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return evaluatedObject != pointToSnap && [evaluatedObject distanceFromPoint:pointToSnap.asCGPoint] < 30;
            }]] firstObject];
            if(pointToReplace && pointToReplace.attachable && pointToSnap.attachable){
                for(int i=0;i<[sticks count];i++){
                    MMStick* stick = [sticks objectAtIndex:i];
                    [stick replacePoint:pointToReplace withPoint:pointToSnap];
                }
                for(int i=0;i<[balloons count];i++){
                    MMBalloon* balloon = [balloons objectAtIndex:i];
                    [balloon replacePoint:pointToReplace withPoint:pointToSnap];
                }
                [points removeObject:pointToReplace];
            }
        }
        grabbedPoint = nil;
        grabbedStick = nil;
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
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, rect);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    
    // render sidebar objects
    for (MMStick* stick in defaultObjects){
        [stick render];
    }
    

    if(animationOnOffSwitch.selected){
        // gravity + velocity etc
        [self updatePoints];
        [self tickMachines];
    }
    
    [processedPoints removeAllObjects];
    // constrain everything
    for(int i = 0; i < 5; i++) {
        [self enforceGesture];
        [self constrainSticks];
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
        if(!animationOnOffSwitch.selected){
            for (MMPoint* p in points) {
                [p nullVelocity];
            }
        }
    }else if(grabbedStick){
        if(grabPointGesture.state == UIGestureRecognizerStateBegan ||
           grabPointGesture.state == UIGestureRecognizerStateChanged){
            grabbedStick.p0.x = [grabPointGesture locationInView:self].x - grabbedStickOffsetP0.x;
            grabbedStick.p0.y = [grabPointGesture locationInView:self].y - grabbedStickOffsetP0.y;
            grabbedStick.p1.x = [grabPointGesture locationInView:self].x - grabbedStickOffsetP1.x;
            grabbedStick.p1.y = [grabPointGesture locationInView:self].y - grabbedStickOffsetP1.y;
        }
        if(!animationOnOffSwitch.selected){
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

-(void) constrainSticks{
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
            [b constrain];
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
            [b constrain];
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
                
                if(p.x > self.bounds.size.width - kStickWidth/2) {
                    p.x = self.bounds.size.width - kStickWidth/2;
                    p.oldx = p.x + vx * bounce;
                }
                else if(p.x < kStickWidth/2) {
                    p.x = kStickWidth/2;
                    p.oldx = p.x + vx * bounce;
                }
                if(p.y > self.bounds.size.height - kStickWidth/2) {
                    p.y = self.bounds.size.height - kStickWidth/2;
                    p.oldy = p.y + vy * bounce;
                }
                else if(p.y < kStickWidth/2) {
                    p.y = kStickWidth/2;
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
    MMPoint* ret = [[points sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 distanceFromPoint:point] < [obj2 distanceFromPoint:point] && [obj1 attachable] ? NSOrderedAscending : NSOrderedDescending;
    }] firstObject];
    if([ret distanceFromPoint:point] < 30 && ret.attachable){
        return ret;
    }
    return nil;
}

-(MMStick*) getStickNear:(CGPoint)point{
    MMStick* ret = [[sticks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 distanceFromPoint:point] < [obj2 distanceFromPoint:point] ? NSOrderedAscending : NSOrderedDescending;
    }] firstObject];
    NSLog(@"closest stick is: %f", [ret distanceFromPoint:point]);
    if([ret distanceFromPoint:point] < 30){
        return ret;
    }
    MMBalloon* balloon = [[balloons sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 distanceFromPoint:point] < [obj2 distanceFromPoint:point] ? NSOrderedAscending : NSOrderedDescending;
    }] firstObject];
    NSLog(@"closest stick is: %f", [ret distanceFromPoint:point]);
    if([balloon distanceFromPoint:point] < balloon.radius){
        return balloon.stick;
    }
    return nil;
}

-(MMStick*) getSidebarObject:(CGPoint)point{
    MMStick* ret = [[defaultObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 distanceFromPoint:point] < [obj2 distanceFromPoint:point] ? NSOrderedAscending : NSOrderedDescending;
    }] firstObject];
    if([ret distanceFromPoint:point] < 30){
        return ret;
    }
    return nil;
}

@end
