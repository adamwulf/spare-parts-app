//
//  LoadingDeviceViewDelegate.h
//  spareparts
//
//  Created by Adam Wulf on 4/3/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadingDeviceViewDelegate <NSObject>

-(void) loadDeviceNamed:(NSString*)name;

-(void) cancelLoadingDevice;

@end
