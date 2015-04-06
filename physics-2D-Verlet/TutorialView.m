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

@implementation TutorialView{
    UIScrollView* scrollView;
    MMPhysicsView* physics;
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
        
        physics = [[MMPhysicsView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
        
    }
    return self;
}


-(void) closeTutorialPressed:(id)button{
    [delegate tutorialViewClosed];
}


@end
