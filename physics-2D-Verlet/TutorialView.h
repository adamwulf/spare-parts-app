//
//  TutorialView.h
//  spareparts
//
//  Created by Adam Wulf on 4/5/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialViewDelegate.h"

@interface TutorialView : UIView

@property (weak) NSObject<TutorialViewDelegate>* delegate;

@end
