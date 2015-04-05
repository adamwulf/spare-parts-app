//
//  PropertiesViewDelegate.h
//  spareparts
//
//  Created by Adam Wulf on 4/5/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PropertiesViewDelegate <NSObject>

-(void) didStartEditingProperties;

-(void) didStopEditingProperties;

@end
