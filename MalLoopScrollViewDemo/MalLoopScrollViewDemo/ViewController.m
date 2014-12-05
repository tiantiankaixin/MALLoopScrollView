//
//  ViewController.m
//  MalLoopScrollViewDemo
//
//  Created by wangtian on 14-12-5.
//  Copyright (c) 2014年 wangtian. All rights reserved.
//

#import "ViewController.h"
#import "LoopViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openLoopView:(UIButton *)sender
{
    [self.navigationController pushViewController:[[LoopViewController alloc] init] animated:YES];
}
@end
