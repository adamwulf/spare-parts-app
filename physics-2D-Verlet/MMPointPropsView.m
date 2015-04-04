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
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 10;
        self.hidden = YES;
        
        UILabel* titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
        titleLbl.text = @"Properties";
        titleLbl.font = [UIFont boldSystemFontOfSize:titleLbl.font.pointSize];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLbl];
        
        immovableSwitch = [[UISwitch alloc] init];
        immovableSwitch.on = NO;
        immovableSwitch.center = CGPointMake(50, 60);
        [immovableSwitch addTarget:self action:@selector(immovableChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:immovableSwitch];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        lbl.text = @"immovable";
        [lbl sizeToFit];
        lbl.center = CGPointMake(120, 60);
        [self addSubview:lbl];
        
        UISlider* gravitySlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 110, self.bounds.size.width-40, 40)];
        [self addSubview:gravitySlider];
        
        UIView* bitsOfWhite = [[UIView alloc] initWithFrame:self.bounds];
        bitsOfWhite.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        beView.frame = self.bounds;
        [beView.contentView addSubview:bitsOfWhite];
        [self insertSubview:beView atIndex:0];
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
