//
//  ViewController.m
//  CycleScrollView
//
//  Created by B.H.Liu on 12-10-30.
//  Copyright (c) 2012年 B.H.Liu. All rights reserved.
//

#import "ViewController.h"
#import "CycleScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSArray *titles = @[@"Panda0",@"Monkey1",@"Dolphin2",@"Penguin3",@"Bear4",@"Dog5",@"Kitty6",@"Tiger7",@"Lion8"];
    
    CycleScrollView *cycleScrollView = [[CycleScrollView alloc] initWithItems:titles andFrame:CGRectMake(0, 100, 320, 44)];
    [self.view addSubview:cycleScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
