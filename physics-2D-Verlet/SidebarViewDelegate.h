//
//  SidebarViewDelegate.h
//  spareparts
//
//  Created by Adam Wulf on 5/4/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SidebarViewDelegate <NSObject>

-(void) toggleRunning;
-(void) clearObjects;
-(void) saveObjects;
-(void) loadObjects;
-(void) tutorialButtonPressed;

@end
