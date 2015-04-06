//
//  PhysicsViewDelegate.h
//  spareparts
//
//  Created by Adam Wulf on 4/5/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhysicsViewDelegate <NSObject>

-(void) initializePhysicsDataIntoPoints:(NSMutableArray*)points
                              andSticks:(NSMutableArray*)sticks
                            andBalloons:(NSMutableArray*)balloons;

-(void) pleaseOpenTutorial;

@end
