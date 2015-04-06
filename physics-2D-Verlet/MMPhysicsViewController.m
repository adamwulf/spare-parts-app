//
//  ViewController.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/22/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPhysicsViewController.h"
#import "MMPhysicsView.h"
#import "SidebarBackground.h"
#import "Constants.h"
#import "TutorialView.h"
#import "TutorialViewDelegate.h"
#import "MMStick.h"
#import "MMEngine.h"
#import "MMPiston.h"
#import "MMWheel.h"
#import "MMBalloon.h"
#import "MMSpring.h"

@interface MMPhysicsViewController ()<TutorialViewDelegate>

@end

@implementation MMPhysicsViewController{
    MMPhysicsView* physicsView;
    SidebarBackground* sidebar;
    TutorialView* tutorial;
}

- (void)viewDidLoad {
    
#ifdef DEBUG
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasCompletedTutorial"];
#endif

    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* backyard = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backyard.contentMode = UIViewContentModeScaleAspectFill;
    backyard.image = [UIImage imageNamed:@"backyard.jpg"];
    [self.view addSubview:backyard];

    sidebar = [[SidebarBackground alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-kSidebarWidth, 0, kSidebarWidth, self.view.bounds.size.height)];
    sidebar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [backyard addSubview:sidebar];
    
    physicsView = [[MMPhysicsView alloc] initWithFrame:self.view.bounds];
    physicsView.controller = self;
    physicsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:physicsView];
    
    
    
    CGFloat sidebarLeft = self.view.bounds.size.width - 230;
    CGFloat sidebarRight = self.view.bounds.size.width - 60;
    [physicsView.defaultObjects addObject:[MMStick stickWithP0:[MMPoint pointWithX:sidebarLeft andY:200]
                                             andP1:[MMPoint pointWithX:sidebarRight andY:240]]];
    [physicsView.defaultObjects addObject:[MMPiston pistonWithP0:[MMPoint pointWithX:sidebarLeft andY:300]
                                               andP1:[MMPoint pointWithX:sidebarRight andY:340]]];
    [physicsView.defaultObjects addObject:[MMEngine engineWithP0:[MMPoint pointWithX:sidebarLeft andY:400]
                                               andP1:[MMPoint pointWithX:sidebarRight andY:440]]];
    [physicsView.defaultObjects addObject:[MMSpring springWithP0:[MMPoint pointWithX:sidebarLeft andY:500]
                                               andP1:[MMPoint pointWithX:sidebarRight andY:540]]];
    [physicsView.defaultObjects addObject:[MMBalloon balloonWithCGPoint:CGPointMake(sidebarLeft, 600)]];
    [physicsView.defaultObjects addObject:[MMWheel wheelWithCenter:[MMPoint pointWithX:sidebarLeft + 100 andY:680]
                                             andRadius:kWheelRadius]];
    
    
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasCompletedTutorial"]){
        // add the tutorial
        tutorial = [[TutorialView alloc] initWithFrame:self.view.bounds];
        tutorial.delegate = self;
        [self.view addSubview:tutorial];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TutorialViewDelegate

-(void) tutorialViewClosed{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasCompletedTutorial"];
    [UIView animateWithDuration:.3 animations:^{
        tutorial.alpha = 0;
    } completion:^(BOOL finished) {
        [tutorial removeFromSuperview];
    }];
}

@end
