//
//  MMPointPropsView.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/24/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertiesView.h"
#import "MMPoint.h"
#import "MMStick.h"

@interface MMPointPropsView : PropertiesView

-(void) showPointProperties:(MMPoint*)point;

@end
