//
//  ViewController.m
//  GesturesVerificationCode
//
//  Created by 柴东鹏 on 15/11/16.
//  Copyright © 2015年 CDP. All rights reserved.
//

#import "ViewController.h"
#import "onTheScreenViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *screenButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50,50,100,40)];
    [screenButton setTitle:@"全屏幕显示" forState:UIControlStateNormal];
    [screenButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    screenButton.backgroundColor=[UIColor cyanColor];
    [screenButton addTarget:self action:@selector(screenClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:screenButton];
    
}

//满屏幕
-(void)screenClick{
    onTheScreenViewController *screenViewController=[[onTheScreenViewController alloc] init];
    [self presentViewController:screenViewController animated:YES completion:nil];
}



















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
