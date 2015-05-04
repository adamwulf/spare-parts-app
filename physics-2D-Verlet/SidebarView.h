//
//  SidebarBackground.h
//  spareparts
//
//  Created by Adam Wulf on 3/31/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPhysicsView.h"
#import "SidebarViewDelegate.h"

@interface SidebarView : UIView

@property (nonatomic, weak) NSObject<SidebarViewDelegate>* delegate;
@property (nonatomic, readonly) MMPhysicsView* physicsView;

@end
