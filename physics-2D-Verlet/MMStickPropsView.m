//
//  MMStickPropsView.m
//  spareparts
//
//  Created by Adam Wulf on 4/1/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStickPropsView.h"

@implementation MMStickPropsView

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 10;
        self.hidden = YES;
    }
    return self;
}

-(void) showObjectProperties:(MMStick*)stick{
    self.hidden = !stick;
}


@end
