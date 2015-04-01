//
//  MMPointPropsView.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/24/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPointPropsView.h"
#import "MMPoint.h"
#import "MMStick.h"

@implementation MMPointPropsView{
    UISwitch* immovableSwitch;
    MMPoint* selectedPoint;
}

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 10;
        self.hidden = YES;
        
        immovableSwitch = [[UISwitch alloc] init];
        immovableSwitch.on = NO;
        immovableSwitch.center = CGPointMake(50, 50);
        [immovableSwitch addTarget:self action:@selector(immovableChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:immovableSwitch];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        lbl.text = @"immovable";
        [lbl sizeToFit];
        lbl.center = CGPointMake(120, 50);
        [self addSubview:lbl];
    }
    return self;
}

-(void) showPointProperties:(MMPoint*)point{
    self.hidden = !point;
    selectedPoint = point;
    immovableSwitch.on = point.immovable;
}

-(void) immovableChanged{
    [selectedPoint setImmovable:immovableSwitch.on];
}

@end
