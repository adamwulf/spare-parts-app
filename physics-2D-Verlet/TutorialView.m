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
        
        
        scrollView.contentSize = CGSizeMake(2000 + scrollView.bounds.size.width, scrollView.bounds.size.height);
        
        physicsView = [[MMPhysicsView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height) andDelegate:self];
        
        CGFloat startOfPartsTutorial = scrollView.bounds.size.width;

        [physicsView.staticObjects addObject:[MMStick stickWithP0:[MMPoint pointWithX:startOfPartsTutorial+100 andY:50]
                                                             andP1:[MMPoint pointWithX:startOfPartsTutorial+300 andY:70]]];
        [physicsView.staticObjects addObject:[MMPiston pistonWithP0:[MMPoint pointWithX:startOfPartsTutorial+400 andY:50]
                                                               andP1:[MMPoint pointWithX:startOfPartsTutorial+600 andY:70]]];
        [physicsView.staticObjects addObject:[MMEngine engineWithP0:[MMPoint pointWithX:startOfPartsTutorial+700 andY:50]
                                                               andP1:[MMPoint pointWithX:startOfPartsTutorial+900 andY:70]]];
        [physicsView.staticObjects addObject:[MMSpring springWithP0:[MMPoint pointWithX:startOfPartsTutorial+1000 andY:50]
                                                               andP1:[MMPoint pointWithX:startOfPartsTutorial+1200 andY:70]]];
        [physicsView.staticObjects addObject:[MMBalloon balloonWithCGPoint:CGPointMake(startOfPartsTutorial+1370, 80)]];
        [physicsView.staticObjects addObject:[MMWheel wheelWithCenter:[MMPoint pointWithX:startOfPartsTutorial+1580 andY:80]
                                                             andRadius:kWheelRadius]];
        [physicsView turnOffGestures];
        [physicsView hideSidebar];
        [scrollView addSubview:physicsView];
        
        
        UIButton* closeTutorialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSAttributedString* title = [[NSAttributedString alloc] initWithString:@"Get Started!"
                                                                    attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:30] }];
        [closeTutorialButton setAttributedTitle:title forState:UIControlStateNormal];
        [closeTutorialButton addTarget:self action:@selector(closeTutorialPressed:) forControlEvents:UIControlEventTouchUpInside];
        [closeTutorialButton sizeToFit];
        closeTutorialButton.center = CGPointMake(startOfPartsTutorial+1830, scrollView.bounds.size.height/2);
        [scrollView addSubview:closeTutorialButton];
        
        
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
        lbl.numberOfLines = 3;
        lbl.text = @"Spare Parts is a fun sandbox contraption building game where the only limit is your imagination!";
        [self sizeLabelAndKeepWidth:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.center = CGPointMake(scrollView.bounds.size.width/2, scrollView.bounds.size.height/2);
        [scrollView addSubview:lbl];
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 200)];
        lbl.numberOfLines = 1;
        lbl.attributedText = [[NSAttributedString alloc] initWithString:@"Hello, Builder!"
                                                             attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:28] }];
        [self sizeLabelAndKeepWidth:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.center = CGPointMake(scrollView.bounds.size.width/2, scrollView.bounds.size.height/2 - 100);
        [scrollView addSubview:lbl];
        
        // planks
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        lbl.numberOfLines = 0;
        lbl.text = @"Drag these planks from the sidebar to start building your contraption! Careful that they don't flex or bend, or they'll break!\n\n Connect planks together at their end points!";
        lbl.center = CGPointMake(startOfPartsTutorial+200, 200);
        [self sizeLabelAndKeepWidth:lbl];
        [scrollView addSubview:lbl];
        
        
        // pistons
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        lbl.numberOfLines = 0;
        lbl.text = @"Pistons expand and contract to add motion and movement to your machine!";
        lbl.center = CGPointMake(startOfPartsTutorial+500, 220);
        [self sizeLabelAndKeepWidth:lbl];
        [scrollView addSubview:lbl];
        
        // engine
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        lbl.numberOfLines = 0;
        lbl.text = @"Engines have 3 connection points! The center point will slide between the two endpoints of the engine!";
        lbl.center = CGPointMake(startOfPartsTutorial+800, 220);
        [self sizeLabelAndKeepWidth:lbl];
        [scrollView addSubview:lbl];
        
        // spring
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        lbl.numberOfLines = 0;
        lbl.text = @"The spring can stretch and add some suspension to your machine! Perfect to help ease stress on planks and pistons!";
        lbl.center = CGPointMake(startOfPartsTutorial+1100, 220);
        [self sizeLabelAndKeepWidth:lbl];
        [scrollView addSubview:lbl];
        
        // balloon
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        lbl.numberOfLines = 0;
        lbl.text = @"Balloons can be attached to the endpoint of any plank, piston, engine, or spring, and will lift it up! Larger balloons can lift heavier objects!";
        lbl.center = CGPointMake(startOfPartsTutorial+1380, 260);
        [self sizeLabelAndKeepWidth:lbl];
        [scrollView addSubview:lbl];
        
        // wheel
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        lbl.numberOfLines = 0;
        lbl.text = @"Wheels can spin around their center point, and offer five attachment points for other objects!";
        lbl.center = CGPointMake(startOfPartsTutorial+1600, 260);
        [self sizeLabelAndKeepWidth:lbl];
        [scrollView addSubview:lbl];
        
        
        
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        lbl.attributedText = [[NSAttributedString alloc] initWithString:@"Scroll! →"
                                                                    attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:18] }];
        lbl.center = CGPointMake(scrollView.bounds.size.width - 50, scrollView.bounds.size.height - 20);
        [scrollView addSubview:lbl];
        
    }
    return self;
}

-(void) sizeLabelAndKeepWidth:(UILabel*)lbl{
    CGFloat w = lbl.bounds.size.width;
    [lbl sizeToFit];
    CGRect fr = lbl.frame;
    fr.size.width = w;
    lbl.frame = fr;
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

-(void) pleaseOpenTutorial{
    // noop
}

@end
