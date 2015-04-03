//
//  LoadingDeviceView.h
//  spareparts
//
//  Created by Adam Wulf on 4/3/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingDeviceViewDelegate.h"

@interface LoadingDeviceView : UIView

@property (weak) NSObject<LoadingDeviceViewDelegate>* delegate;

-(void) reloadData;

@end
