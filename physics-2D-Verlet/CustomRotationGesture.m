//
//  CustomRotationGesture.m
//  spareparts
//
//  Created by Adam Wulf on 4/23/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "CustomRotationGesture.h"
#import "InstantPanGestureRecognizer.h"

@implementation CustomRotationGesture



#pragma mark - Subclass

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{
    if([preventedGestureRecognizer isKindOfClass:[InstantPanGestureRecognizer class]]){
        InstantPanGestureRecognizer* other = (InstantPanGestureRecognizer*)preventedGestureRecognizer;
        if(other.maximumNumberOfTouches == 1){
            return YES;
        }
    }
    return NO;
}


- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer{
    return NO;
}

// same behavior as the equivalent delegate methods, but can be used by subclasses to define class-wide failure requirements
- (BOOL)shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0){
    return NO;
}


- (BOOL)shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0){
    return NO;
}


@end
