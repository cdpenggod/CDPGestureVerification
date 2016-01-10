//
//  onTheScreenViewController.m
//  GesturesVerificationCode
//
//  Created by 柴东鹏 on 15/11/18.
//  Copyright © 2015年 CDP. All rights reserved.
//

#import "onTheScreenViewController.h"
#import "CDPGestureVerification.h"

@interface onTheScreenViewController () <CDPGestureVerificationDelegate> {
    CDPGestureVerification *_gv;
}


@end

@implementation onTheScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //生成验证
    _gv=[[CDPGestureVerification alloc] initOnScreenWithImage:[UIImage imageNamed:@"image"] isRound:NO];
    _gv.delegate=self;
    
    //返回button
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(20,40,40,20)];
    [backButton setTitle:@"<" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //验证成功后UI
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20,65,self.view.bounds.size.width-40,self.view.bounds.size.height-20-30)];
    label.backgroundColor=[UIColor cyanColor];
    label.numberOfLines=0;
    label.textAlignment=NSTextAlignmentCenter;
    label.text=@"验证成功验证成功！！\n\n因为在斗鱼的网站看见这种验证方式，挺好玩,就做了个\n\n可以将裁切的图片改成圆形以及更改毛玻璃背景的风格等，验证的图片要自己传入，裁切的位置是随机的，具体看demo里\n\n";
    [self.view addSubview:label];
}
-(void)viewWillAppear:(BOOL)animated{

    [_gv addGestureVerification];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_gv removeGestureVerification];
}

//返回
-(void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - CDPGestureVerificationDelegate
//验证取消
-(void)cancelClick{
    [self backClick];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
