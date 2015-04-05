//
//  PropertiesView.h
//  spareparts
//
//  Created by Adam Wulf on 4/5/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertiesViewDelegate.h"

@interface PropertiesView : UIView

@property (weak) NSObject<PropertiesViewDelegate>* delegate;


-(void) startEditingProperties;

-(void) stopEditingProperties;

@end
