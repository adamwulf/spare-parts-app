//
//  InstantPanGestureRecognizer.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/27/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "InstantPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation InstantPanGestureRecognizer

@synthesize initialLocationInWindow;

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    initialLocationInWindow = [[touches anyObject] locationInView:nil];
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    self.state = UIGestureRecognizerStateChanged;
}

@end
