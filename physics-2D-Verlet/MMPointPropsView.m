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
    UISlider* gravitySlider;
    UISwitch* immovableSwitch;
    MMPoint* selectedPoint;
    UILabel* gravityLbl;
}

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        immovableSwitch = [[UISwitch alloc] init];
        immovableSwitch.on = NO;
        immovableSwitch.center = CGPointMake(50, 60);
        [immovableSwitch addTarget:self action:@selector(immovableChanged) forControlEvents:UIControlEventValueChanged];
        [immovableSwitch addTarget:self action:@selector(startEditingProperties) forControlEvents:UIControlEventTouchDown];
        [immovableSwitch addTarget:self action:@selector(stopEditingProperties) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:immovableSwitch];
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        lbl.text = @"Immovable";
        [lbl sizeToFit];
        lbl.center = CGPointMake(120, 60);
        [self addSubview:lbl];
        

        gravityLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 100, 40)];
        gravityLbl.text = @"Gravity: 0";
        [gravityLbl sizeToFit];
        CGRect fr = gravityLbl.frame;
        fr.size.width = self.bounds.size.width;
        gravityLbl.frame = fr;
        [self addSubview:gravityLbl];
        gravitySlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 110 + lbl.bounds.size.height, self.bounds.size.width-60, 40)];
        gravitySlider.minimumValue = -2;
        gravitySlider.maximumValue = 2;
        gravitySlider.continuous = YES;
        [gravitySlider addTarget:self action:@selector(gravityChanged:) forControlEvents:UIControlEventValueChanged];
        [gravitySlider addTarget:self action:@selector(startEditingProperties) forControlEvents:UIControlEventTouchDown];
        [gravitySlider addTarget:self action:@selector(stopEditingProperties) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:gravitySlider];
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        lbl.text = @"-2";
        [lbl sizeToFit];
        [self addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.center = CGPointMake(15, gravitySlider.center.y);
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        lbl.text = @"+2";
        [lbl sizeToFit];
        [self addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.center = CGPointMake(self.bounds.size.width - 15, gravitySlider.center.y);
    }
    return self;
}

-(void) showPointProperties:(MMPoint*)point{
    self.hidden = !point;
    selectedPoint = point;
    immovableSwitch.on = point.immovable;
    gravitySlider.value = point.gravityModifier;
    gravityLbl.text = [NSString stringWithFormat:@"Gravity: %.1f", point.gravityModifier];
}

-(void) immovableChanged{
    [selectedPoint setImmovable:immovableSwitch.on];
}

-(void) gravityChanged:(UISlider*)_slider{
    selectedPoint.gravityModifier = _slider.value;
    gravityLbl.text = [NSString stringWithFormat:@"Gravity: %.1f", selectedPoint.gravityModifier];
}



@end
