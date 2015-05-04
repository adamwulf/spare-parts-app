//
//  ViewController.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/22/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPhysicsViewController.h"
#import "MMPhysicsView.h"
#import "SidebarView.h"
#import "Constants.h"
#import "TutorialView.h"
#import "TutorialViewDelegate.h"
#import "MMStick.h"
#import "MMEngine.h"
#import "MMPiston.h"
#import "MMWheel.h"
#import "MMBalloon.h"
#import "MMSpring.h"
#import "PhysicsViewDelegate.h"

@interface MMPhysicsViewController ()<TutorialViewDelegate,PhysicsViewDelegate>

@end

@implementation MMPhysicsViewController{
    MMPhysicsView* physicsView;
    SidebarView* sidebar;
    TutorialView* tutorial;
}

- (void)viewDidLoad {
    
//#ifdef DEBUG
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasCompletedTutorial"];
//#endif

    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView* backyard = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backyard.contentMode = UIViewContentModeScaleAspectFill;
    backyard.image = [UIImage imageNamed:@"backyard.jpg"];
    [self.view addSubview:backyard];

    sidebar = [[SidebarView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-kSidebarWidth, 0, kSidebarWidth, self.view.bounds.size.height)];
    sidebar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [backyard addSubview:sidebar];
    
    physicsView = [[MMPhysicsView alloc] initWithFrame:self.view.bounds andDelegate:self andDrawOnce:NO];
    physicsView.controller = self;
    physicsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:physicsView];
    
    
    
    CGFloat sidebarLeft = kSidebarWidth - 230;
    CGFloat sidebarRight = kSidebarWidth - 60;
    [sidebar.physicsView.staticObjects addObject:[MMStick stickWithP0:[MMPoint pointWithX:sidebarLeft andY:200]
                                             andP1:[MMPoint pointWithX:sidebarRight andY:240]]];
    [sidebar.physicsView.staticObjects addObject:[MMPiston pistonWithP0:[MMPoint pointWithX:sidebarLeft andY:300]
                                               andP1:[MMPoint pointWithX:sidebarRight andY:340]]];
    [sidebar.physicsView.staticObjects addObject:[MMEngine engineWithP0:[MMPoint pointWithX:sidebarLeft andY:400]
                                               andP1:[MMPoint pointWithX:sidebarRight andY:440]]];
    [sidebar.physicsView.staticObjects addObject:[MMSpring springWithP0:[MMPoint pointWithX:sidebarLeft andY:500]
                                               andP1:[MMPoint pointWithX:sidebarRight andY:540]]];
    [sidebar.physicsView.staticObjects addObject:[MMBalloon balloonWithCGPoint:CGPointMake(sidebarLeft, 600)]];
    [sidebar.physicsView.staticObjects addObject:[MMWheel wheelWithCenter:[MMPoint pointWithX:sidebarLeft + 120 andY:680]
                                             andRadius:kWheelRadius]];
    
    [sidebar.physicsView setNeedsDisplay];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasCompletedTutorial"]){
        [self pleaseOpenTutorial];
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


#pragma mark - PhysicsViewDelegate

-(void) initializePhysicsDataIntoPoints:(NSMutableArray *)points
                              andSticks:(NSMutableArray *)sticks{
    [points addObject:[MMPoint pointWithX:300 andY:100]];
    [points addObject:[MMPoint pointWithX:400 andY:100]];
    [points addObject:[MMPoint pointWithX:400 andY:200]];
    [points addObject:[MMPoint pointWithX:300 andY:200]];
    
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:0]
                                     andP1:[points objectAtIndex:1]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:1]
                                     andP1:[points objectAtIndex:2]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:2]
                                     andP1:[points objectAtIndex:3]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:3]
                                     andP1:[points objectAtIndex:0]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:0]
                                     andP1:[points objectAtIndex:2]]];
    [sticks addObject:[MMStick stickWithP0:[points objectAtIndex:1]
                                     andP1:[points objectAtIndex:3]]];
    
    [points makeObjectsPerformSelector:@selector(bump)];
}


-(void) pleaseOpenTutorial{
    // add the tutorial
    tutorial = [[TutorialView alloc] initWithFrame:self.view.bounds];
    tutorial.delegate = self;
    [self.view addSubview:tutorial];
}

-(MMPhysicsObject*) getSidebarObject:(CGPoint)point{
    point = [sidebar convertPoint:point fromView:physicsView];
    MMPhysicsObject* ret = [[sidebar.physicsView.staticObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 distanceFromPoint:point] < [obj2 distanceFromPoint:point] ? NSOrderedAscending : NSOrderedDescending;
    }] firstObject];
    if([ret distanceFromPoint:point] < 30){
        // translate object back into the physics view
        // coordinate system.
        
        ret = [ret cloneObject];
        CGPoint translation = [sidebar convertPoint:CGPointZero toView:physicsView];
        [ret translateBy:translation];
        
        return ret;
    }
    return nil;
}


@end
