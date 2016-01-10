//
//  CDPGestureVerification.m
//  GesturesVerificationCode
//
//  Created by 柴东鹏 on 15/11/16.
//  Copyright © 2015年 CDP. All rights reserved.
//

#import "CDPGestureVerification.h"
#define Window ([UIApplication sharedApplication].delegate).window
#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@implementation CDPGestureVerification{
    UIVisualEffectView *_backgroundView;//全屏毛玻璃背景
    
    UIView *_imageBackgroundView;
    UIImageView *_imageView;
    UIImageView *_smallImageView;
    
    BOOL _isRound;//裁切的图片是否圆形
    
    CGRect _rect;//图片缺少部分的位置
}

//满屏初始化
-(instancetype)initOnScreenWithImage:(UIImage *)image isRound:(BOOL)isRound{
    if (self=[super init]) {
        
        _isRound=isRound;
        
        [self createUI];

        self.image=image;
        
    }
    return self;
}
-(void)setImage:(UIImage *)image{
    _image=image;
    _imageView.image=_image;
    
    _rect=CGRectMake(arc4random()%210,arc4random()%210,30,30);
    
    _smallImageView.image=[self getImageFromImageView:_imageView withRect:_rect];
    _imageView.image=[self getNoSmallImageWithRect:_rect];
}
-(void)setBlurEffect:(UIBlurEffectStyle)blurEffect{
    _blurEffect=blurEffect;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:_blurEffect];
    _backgroundView.effect=blur;
}
#pragma mark - 添加/移除GestureVerification
//添加显示
-(void)addGestureVerification{
    if (_backgroundView.superview==nil) {
        [Window addSubview:_backgroundView];
        
        [Window bringSubviewToFront:_backgroundView];
    }
    if (_imageBackgroundView.superview==nil) {
        [Window addSubview:_imageBackgroundView];
        
        [Window bringSubviewToFront:_imageBackgroundView];
    }
    
}
//移除消失
-(void)removeGestureVerification{
    if (_backgroundView.superview) {
        [_backgroundView removeFromSuperview];
    }
    if (_imageBackgroundView.superview) {
        [_imageBackgroundView removeFromSuperview];
    }
    
}
#pragma mark - 创建UI
-(void)createUI{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _backgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _backgroundView.frame = CGRectMake(0,0,SWidth,SHeight);
    
    //取消
    _cancelButton=[[UIButton alloc] initWithFrame:CGRectMake(_backgroundView.bounds.size.width-10-24,30,24,24)];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"CDPCancel"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_cancelButton];
    
    _imageBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(SWidth/2-120,SHeight/2-120-15-10,240,240+30+10)];
    
    //验证图片imageView
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,40,240,240)];
    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(0,0);
    _imageView.layer.shadowOpacity = 0.5;
    _imageView.layer.shadowRadius = 10.0;
    [_imageBackgroundView addSubview:_imageView];
    
    //裁切的小图imageView
    _smallImageView=[[UIImageView alloc] initWithFrame:CGRectMake(120-15,0,30,30)];
    _smallImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _smallImageView.layer.shadowOffset = CGSizeMake(0,0);
    _smallImageView.layer.shadowOpacity = 0.5;
    _smallImageView.layer.shadowRadius = 10.0;
    _smallImageView.userInteractionEnabled=YES;
    if (_isRound==YES) {
        _smallImageView.layer.cornerRadius=_smallImageView.bounds.size.height/2;
        _smallImageView.layer.masksToBounds=YES;
    }
    [_imageBackgroundView addSubview:_smallImageView];
    
    UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGR:)];
    [_smallImageView addGestureRecognizer:panGR];
    
}
#pragma mark - 手势
-(void)panGR:(UIPanGestureRecognizer *)panGR{
    CGPoint point=[panGR translationInView:Window];
    panGR.view.center = CGPointMake(panGR.view.center.x+point.x,panGR.view.center.y+point.y);
    [panGR setTranslation:CGPointZero inView:Window];

    if (panGR.state==UIGestureRecognizerStateEnded) {
        CGPoint lastPoint=[panGR.view convertPoint:CGPointMake(0,0) toView:_imageView];
        
        if (lastPoint.x>=_rect.origin.x-5&&lastPoint.x<=_rect.origin.x+5&&lastPoint.y>=_rect.origin.y-5&&lastPoint.y<=_rect.origin.y+5) {
            [self removeGestureVerification];
        }
        else{
            [UIView animateWithDuration:0.25 animations:^{
                panGR.view.frame=CGRectMake(120-15,0,30,30);
            }];
        }
    }
}

#pragma mark - 图片裁剪相关
//创建去掉小图的验证图片
-(UIImage *)getNoSmallImageWithRect:(CGRect)rect{
    UIGraphicsBeginImageContext(_imageView.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CALayer *layer = [CALayer layer];
    layer.frame=rect;
    layer.backgroundColor=[UIColor whiteColor].CGColor;
    layer.shadowColor = [UIColor whiteColor].CGColor;
    layer.shadowOffset = CGSizeMake(0,0);
    layer.shadowOpacity = 0.7;
    layer.shadowRadius = 10.0;
    if (_isRound==YES) {
        layer.cornerRadius=_smallImageView.bounds.size.height/2;
        layer.masksToBounds=YES;
    }
    [_imageView.layer addSublayer:layer];
    
    [_imageView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//smallImage的裁剪
-(UIImage *)getImageFromImageView:(UIImageView *)imageView withRect:(CGRect)rect{
    
    UIImage *changedImage=[self createChangedImageWithImageView:imageView];
    
    UIGraphicsBeginImageContext(rect.size);
    
    [changedImage drawInRect:CGRectMake(-rect.origin.x,-rect.origin.y,changedImage.size.width,changedImage.size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//创建当前比例图片
-(UIImage *)createChangedImageWithImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [imageView.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - 点击事件
//取消点击
-(void)cancelClick:(UIButton *)sender{
    [self removeGestureVerification];
    
    if ([_delegate respondsToSelector:@selector(cancelClick)]) {
        [_delegate cancelClick];
    }
}


















@end
