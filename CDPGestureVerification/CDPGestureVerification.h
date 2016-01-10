//
//  CDPGestureVerification.h
//  GesturesVerificationCode
//
//  Created by 柴东鹏 on 15/11/16.
//  Copyright © 2015年 CDP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CDPGestureVerificationDelegate <NSObject>

@optional

//取消点击
-(void)cancelClick;

@end


@interface CDPGestureVerification : NSObject


//验证的图片
@property (nonatomic,strong) UIImage *image;

//毛玻璃背景风格
@property (nonatomic,assign) UIBlurEffectStyle blurEffect;

//验证取消button(frame和背景image等可根据自己需要改变)
@property (nonatomic,strong) UIButton *cancelButton;


@property (nonatomic,weak) id <CDPGestureVerificationDelegate> delegate;

//满屏初始化
//image为需要验证的源图片，
//isRound裁切的图片是否圆形
-(instancetype)initOnScreenWithImage:(UIImage *)image isRound:(BOOL)isRound;

//添加显示
-(void)addGestureVerification;

//移除消失
-(void)removeGestureVerification;









@end
