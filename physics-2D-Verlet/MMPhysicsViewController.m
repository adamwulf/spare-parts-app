//
//  ViewController.m
//  physics-2D-Verlet
//
//  Created by Adam Wulf on 3/22/15.
//  Copyright (c) 2015 Milestone made. All rights reserved.
//

#import "MMPhysicsViewController.h"
#import "MMPhysicsView.h"

@interface MMPhysicsViewController ()

@end

@implementation MMPhysicsViewController{
    MMPhysicsView* physicsView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    physicsView = [[MMPhysicsView alloc] initWithFrame:self.view.bounds];
    physicsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:physicsView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
