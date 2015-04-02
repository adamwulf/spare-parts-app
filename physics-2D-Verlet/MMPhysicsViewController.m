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

@interface MMPhysicsViewController ()

@end

@implementation MMPhysicsViewController{
    MMPhysicsView* physicsView;
    SidebarBackground* sidebar;
}

- (void)viewDidLoad {
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
