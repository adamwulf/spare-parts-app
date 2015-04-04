//
//  Renderable.h
//  spareparts
//
//  Created by Adam Wulf on 4/4/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Renderable : NSObject

@property (nonatomic) CGFloat shadowSize;
@property (nonatomic) CGFloat shadowOpacity;

-(void) renderWithHighlight;

-(void) render;

-(void) renderAtZeroZero;

@end
