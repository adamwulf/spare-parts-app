//
//  TutorialView.m
//  spareparts
//
//  Created by Adam Wulf on 4/5/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "TutorialView.h"
#import "Constants.h"
#import "MMPhysicsView.h"
#import "MMStick.h"
#import "MMEngine.h"
#import "MMPiston.h"
#import "MMWheel.h"
#import "MMBalloon.h"
#import "MMSpring.h"
#import "PhysicsViewDelegate.h"

@interface TutorialView ()<PhysicsViewDelegate>

@end

@implementation TutorialView{
    UIScrollView* scrollView;
    MMPhysicsView* physicsView;
}

@synthesize delegate;

-(id) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        UIView* bitsOfWhite = [[UIView alloc] initWithFrame:self.bounds];
        bitsOfWhite.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.5];
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        beView.frame = self.bounds;
        [beView.contentView addSubview:bitsOfWhite];
        [self addSubview:beView];
        
        
        CGRect collectionFrame = CGRectInset(self.bounds, 100, 200);
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kThumbnailSize, kThumbnailSize);
        layout.minimumLineSpacing = 40;
        layout.headerReferenceSize = CGSizeMake(40, kThumbnailSize);
        layout.footerReferenceSize = CGSizeMake(40, kThumbnailSize);
        
        scrollView = [[UIScrollView alloc] initWithFrame:collectionFrame];
        scrollView.layer.borderColor = [UIColor grayColor].CGColor;
        scrollView.layer.borderWidth = 2;
        scrollView.layer.cornerRadius = 10;
        scrollView.backgroundColor = [UIColor whiteColor];
        [self addSubview:scrollView];
        
        
        UIButton* closeTutorialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSAttributedString* title = [[NSAttributedString alloc] initWithString:@"Get Started!"
                                                                    attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:30] }];
        [closeTutorialButton setAttributedTitle:title forState:UIControlStateNormal];
        [closeTutorialButton addTarget:self action:@selector(closeTutorialPressed:) forControlEvents:UIControlEventTouchUpInside];
        [closeTutorialButton sizeToFit];
        closeTutorialButton.center = CGPointMake(1000, scrollView.bounds.size.height/2);
        [scrollView addSubview:closeTutorialButton];
        scrollView.contentSize = CGSizeMake(1200, scrollView.bounds.size.height);
        
        physicsView = [[MMPhysicsView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
        physicsView.delegate = self;

        [physicsView.staticObjects addObject:[MMStick stickWithP0:[MMPoint pointWithX:100 andY:200]
                                                             andP1:[MMPoint pointWithX:300 andY:240]]];
        [physicsView.staticObjects addObject:[MMPiston pistonWithP0:[MMPoint pointWithX:100 andY:300]
                                                               andP1:[MMPoint pointWithX:300 andY:340]]];
        [physicsView.staticObjects addObject:[MMEngine engineWithP0:[MMPoint pointWithX:100 andY:400]
                                                               andP1:[MMPoint pointWithX:300 andY:440]]];
        [physicsView.staticObjects addObject:[MMSpring springWithP0:[MMPoint pointWithX:100 andY:500]
                                                               andP1:[MMPoint pointWithX:300 andY:540]]];
        [physicsView.staticObjects addObject:[MMBalloon balloonWithCGPoint:CGPointMake(100, 600)]];
        [physicsView.staticObjects addObject:[MMWheel wheelWithCenter:[MMPoint pointWithX:100 + 100 andY:680]
                                                             andRadius:kWheelRadius]];
        [scrollView addSubview:physicsView];
        
    }
    return self;
}


-(void) closeTutorialPressed:(id)button{
    [delegate tutorialViewClosed];
}

#pragma mark - PhysicsViewDelegate

-(void) initializePhysicsDataIntoPoints:(NSMutableArray *)points
                              andSticks:(NSMutableArray *)sticks
                            andBalloons:(NSMutableArray *)balloons{
    // noop
}

@end
