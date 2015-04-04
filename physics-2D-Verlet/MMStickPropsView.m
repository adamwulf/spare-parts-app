//
//  MMStickPropsView.m
//  spareparts
//
//  Created by Adam Wulf on 4/1/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMStickPropsView.h"

@implementation MMStickPropsView{
    UILabel* lengthLbl;
    UISlider* lengthSlider;
    MMStick* selectedStick;
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
        

        lengthLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 100, 40)];
        lengthLbl.text = @"Length: 0";
        [lengthLbl sizeToFit];
        CGRect fr = lengthLbl.frame;
        fr.size.width = self.bounds.size.width;
        lengthLbl.frame = fr;
        [self addSubview:lengthLbl];
        lengthSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 110 + lengthLbl.bounds.size.height, self.bounds.size.width-60, 40)];
        lengthSlider.minimumValue = 20;
        lengthSlider.maximumValue = 400;
        lengthSlider.continuous = YES;
        [lengthSlider addTarget:self action:@selector(lengthChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:lengthSlider];
        
        
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

-(void) showObjectProperties:(MMStick*)stick{
    selectedStick = stick;
    self.hidden = !stick;
    lengthLbl.text = [NSString stringWithFormat:@"Length: %.0f", stick.length];
    lengthSlider.value = stick.length;
}


-(void) lengthChanged:(UISlider*)slider{
    selectedStick.length = slider.value;
    lengthLbl.text = [NSString stringWithFormat:@"Length: %.0f", selectedStick.length];
}


@end
