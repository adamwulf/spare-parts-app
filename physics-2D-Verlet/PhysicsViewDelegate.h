//
//  PhysicsViewDelegate.h
//  spareparts
//
//  Created by Adam Wulf on 4/5/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPhysicsObject.h"

@protocol PhysicsViewDelegate <NSObject>

-(void) initializePhysicsDataIntoPoints:(NSMutableArray*)points
                              andSticks:(NSMutableArray*)sticks;

-(void) pleaseOpenTutorial;

-(MMPhysicsObject*) getSidebarObject:(CGPoint)point;

@end
