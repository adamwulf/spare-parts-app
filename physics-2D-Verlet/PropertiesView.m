//
//  PropertiesView.m
//  spareparts
//
//  Created by Adam Wulf on 4/5/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "PropertiesView.h"

@implementation PropertiesView

@synthesize delegate;

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

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* ret = [super hitTest:point withEvent:event];
    if(!ret) return nil;
    
    UIView* foobar = ret;
    while(foobar.superview){
        if([foobar isKindOfClass:[UIControl class]]){
            return ret;
        }
        foobar = foobar.superview;
    }
    return self;
}


-(void) startEditingProperties{
    [self.delegate didStartEditingProperties];
}

-(void) stopEditingProperties{
    [self.delegate didStopEditingProperties];
}

@end
