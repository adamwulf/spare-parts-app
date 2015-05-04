//
//  MMStickPropsView.m
//  spareparts
//
//  Created by Adam Wulf on 4/1/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStickPropsView.h"
#import "MMWheel.h"
#import "Constants.h"
#import "MMBalloon.h"

@implementation MMStickPropsView{
    UILabel* lengthLbl;
    UISlider* lengthSlider;
    MMPhysicsObject* selectedStick;
}

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        lengthLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 40)];
        lengthLbl.text = @"Length: 0";
        [lengthLbl sizeToFit];
        CGRect fr = lengthLbl.frame;
        fr.size.width = self.bounds.size.width;
        lengthLbl.frame = fr;
        [self addSubview:lengthLbl];
        lengthSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 50 + lengthLbl.bounds.size.height, self.bounds.size.width-60, 40)];
        lengthSlider.minimumValue = 20;
        lengthSlider.maximumValue = 400;
        lengthSlider.continuous = YES;
        [lengthSlider addTarget:self action:@selector(lengthChanged:) forControlEvents:UIControlEventValueChanged];
        [lengthSlider addTarget:self action:@selector(startEditingProperties) forControlEvents:UIControlEventTouchDown];
        [lengthSlider addTarget:self action:@selector(stopEditingProperties) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:lengthSlider];
        
    }
    return self;
}

-(void) showObjectProperties:(MMPhysicsObject*)object{
    lengthSlider.minimumValue = 20;
    lengthSlider.maximumValue = 400;
    
    selectedStick = object;
    self.hidden = !object;
    if([object isKindOfClass:[MMWheel class]]){
        lengthSlider.minimumValue = 40;
        lengthSlider.maximumValue = 100;
        MMWheel* w = (MMWheel*)object;
        lengthLbl.text = [NSString stringWithFormat:@"Radius: %.0f", w.radius];
        lengthSlider.value = w.radius;
    }else if([object isKindOfClass:[MMBalloon class]]){
        lengthSlider.minimumValue = kBalloonMinRadius;
        lengthSlider.maximumValue = kBalloonMaxRadius;
        MMBalloon* b = (MMBalloon*)object;
        lengthLbl.text = [NSString stringWithFormat:@"Radius: %.0f", b.radius];
        lengthSlider.value = b.radius;
    }else{
        MMStick* stick = (MMStick*)object;
        lengthLbl.text = [NSString stringWithFormat:@"Length: %.0f", stick.length];
        lengthSlider.value = stick.length;
    }
}


-(void) lengthChanged:(UISlider*)slider{
    if([selectedStick isKindOfClass:[MMWheel class]]){
        MMWheel* w = (MMWheel*)selectedStick;
        w.radius = lengthSlider.value;
        lengthLbl.text = [NSString stringWithFormat:@"Radius: %.0f", w.radius];
    }else if([selectedStick isKindOfClass:[MMBalloon class]]){
        MMBalloon* b = (MMBalloon*)selectedStick;
        b.radius = lengthSlider.value;
        lengthLbl.text = [NSString stringWithFormat:@"Radius: %.0f", b.radius];
    }else{
        MMStick* stick = (MMStick*)selectedStick;
        stick.length = lengthSlider.value;
        lengthLbl.text = [NSString stringWithFormat:@"Length: %.0f", stick.length];
    }
}










@end
