//
//  MMPhysicsView.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/22/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhysicsViewDelegate.h"

@class MMPhysicsViewController;

@interface MMPhysicsView : UIView

@property (weak) MMPhysicsViewController* controller;
@property (weak) NSObject<PhysicsViewDelegate>* delegate;
@property (readonly) NSMutableArray* staticObjects;

-(id) initWithFrame:(CGRect)frame NS_UNAVAILABLE;

-(id) initWithFrame:(CGRect)frame andDelegate:(NSObject<PhysicsViewDelegate>*)_delegate andDrawOnce:(BOOL)drawOnce;

-(void) turnOffGestures;

-(void) hideSidebar;

@end
