//
//  InstantPanGestureRecognizer.h
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/27/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstantPanGestureRecognizer : UIPanGestureRecognizer

@property (readonly) CGPoint initialLocationInWindow;

@end
