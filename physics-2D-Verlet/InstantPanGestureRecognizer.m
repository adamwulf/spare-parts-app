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
    if(self.numberOfTouches >= self.minimumNumberOfTouches &&
       self.numberOfTouches <= self.maximumNumberOfTouches){
        self.state = UIGestureRecognizerStateChanged;
    }
}

#pragma mark - Subclass

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{
    if(self.maximumNumberOfTouches > 1){
        if([preventedGestureRecognizer isKindOfClass:[InstantPanGestureRecognizer class]]){
            InstantPanGestureRecognizer* other = (InstantPanGestureRecognizer*)preventedGestureRecognizer;
            if(other.maximumNumberOfTouches == 1){
                return YES;
            }
        }
    }
    return NO;
}


- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer{
    if(self.maximumNumberOfTouches == 1){
        return YES;
    }
    return NO;
}

// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide failure requirements
- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0){
    return NO;
}


- (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0){
    if(self.maximumNumberOfTouches == 1){
        return YES;
    }
    return NO;
}


@end
