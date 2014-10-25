//
//  TMAlertView.m
//  91TaoJin
//
//  Created by keyrun on 14-3-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TMAlertView.h"
#import "DashLine.h"
#import "NSString+IsEmply.h"
#import "MyUserDefault.h"
#import "SDImageView+SDWebCache.h"
#define kLineOffY   40.0
#define kCodeViewHeight  300
#define kCodeImgSize  160
#define kUserPicImgSize  35
@implementation TMAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"  draw ");
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, KRedColor2_0.CGColor);
    float lengths[] ={2,2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, kLineOffY);
    CGContextAddLineToPoint(context, kViewWeith, kLineOffY);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}
*/


-(id)initWithTitle:(NSString* )title andOneTip:(NSString* )oneTip andTwoTip:(NSString* )twoTip andThreeTip :(NSString* )threeTip andFourTip :(NSString* )fourTip andTipContent:(NSString* )tip andTipImage:(UIImage* )tipImage andTipHighlightImage:(UIImage*)highlightImage  andOkContent:(NSString *)okContent andBGImageL:(UIImage *)bgImage jifenName:(NSString *)jifenName{
    if (self =[super init]) {
        self.clipsToBounds =YES;
//        self.bgImage =[[UIImageView alloc]initWithImage:bgImage];
//        self.bgImage.frame =CGRectMake(0, 0, kViewWeith, kViewHeigth);
//        [self addSubview:self.bgImage];
        UIView *bgView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWeith, kViewHeigth)];
        bgView.layer.cornerRadius =5;
        bgView.backgroundColor =[UIColor whiteColor];
        [self addSubview:bgView];
        
        DashLine *dashLine =[[DashLine alloc] initWithFrame:CGRectMake(0, kLineOffY, kViewWeith, 0.6)];
        [self addSubview:dashLine];
        
        self.dengpao =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dengpao_red@2x.png"]];
        self.dengpao.frame =CGRectMake(22, kYOff-3, 17, 18);
        [self addSubview:self.dengpao];
        
        self.alertViewTitle =[[UILabel alloc]initWithFrame:CGRectMake(10, kYOff, kViewWeith, 16.0)];
        self.alertViewTitle.textAlignment =NSTextAlignmentCenter;
        self.alertViewTitle.backgroundColor =[UIColor clearColor];
        self.alertViewTitle.text =title;
        self.alertViewTitle.font =[UIFont fontWithName:@"Helvetica-Bold" size:16];
        self.alertViewTitle.textColor =KRedColor2_0;
        [self addSubview:self.alertViewTitle];
        
        self.oneContent =[[UILabel alloc]initWithFrame:CGRectMake(10, kYOff2, kViewWeith, 11.0)];
        self.oneContent.textAlignment =NSTextAlignmentLeft;
        self.oneContent.numberOfLines =0;
        self.oneContent.lineBreakMode =NSLineBreakByCharWrapping;
        self.oneContent.backgroundColor =[UIColor clearColor];
        self.oneContent.text =oneTip;
        self.oneContent.font =[UIFont systemFontOfSize:11.0];
        self.oneContent.textColor =KRedColor2_0;

        [self addSubview:self.oneContent];
        
        self.twoContent =[[UILabel alloc]initWithFrame:CGRectMake(10, self.oneContent.frame.origin.y+ 20, kViewWeith, 11.0)];
        self.twoContent.textAlignment =NSTextAlignmentLeft;
        self.twoContent.lineBreakMode =NSLineBreakByCharWrapping;
        self.twoContent.numberOfLines =0;
        self.twoContent.backgroundColor =[UIColor clearColor];
        self.twoContent.text =twoTip;
        self.twoContent.font =[UIFont systemFontOfSize:11.0];
        self.twoContent.textColor =KRedColor2_0;

        [self addSubview:self.twoContent];
        
        self.threeContent =[[UILabel alloc]initWithFrame:CGRectMake(10, self.twoContent.frame.origin.y+ 20, kViewWeith, 11.0)];
        self.threeContent.textAlignment =NSTextAlignmentLeft;
        self.threeContent.lineBreakMode =NSLineBreakByCharWrapping;
        self.threeContent.numberOfLines =0;
        self.threeContent.backgroundColor =[UIColor clearColor];
        self.threeContent.text =threeTip;
        self.threeContent.font =[UIFont systemFontOfSize:11.0];
        self.threeContent.textColor =KRedColor2_0;
        [self addSubview:self.threeContent];
        
        self.fourContent =[[UILabel alloc]initWithFrame:CGRectMake(10, self.threeContent.frame.origin.y+ 20, kViewWeith, 11.0)];
        self.fourContent.textAlignment =NSTextAlignmentLeft;
        self.fourContent.lineBreakMode =NSLineBreakByCharWrapping;
        self.fourContent.numberOfLines =0;
        self.fourContent.backgroundColor =[UIColor clearColor];
        self.fourContent.text =fourTip;
        self.fourContent.font =[UIFont systemFontOfSize:11.0];
        self.fourContent.textColor =KRedColor2_0;
        [self addSubview:self.fourContent];
        
        self.tipContent =[[UILabel alloc]initWithFrame:CGRectMake(0, self.fourContent.frame.origin.y+ 20, kViewWeith, 11.0)];
        self.tipContent.textAlignment =NSTextAlignmentCenter;
        self.tipContent.backgroundColor =[UIColor clearColor];
        self.tipContent.text =tip;
        self.tipContent.font =[UIFont systemFontOfSize:11.0];
        self.tipContent.textColor =kSilverColor;
        [self addSubview:self.tipContent];
        
        self.tipButton =[UIButton buttonWithType:UIButtonTypeCustom];
        self.tipButton.frame =self.tipContent.frame;
        [self.tipButton addTarget:self action:@selector(onClickedCheck) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tipButton];
       
        self.checkImage =[UIButton buttonWithType:UIButtonTypeCustom];
        self.noCheckImage =tipImage;
        self.isCheckImage =highlightImage;
        self.checkImage.frame =CGRectMake(95, self.tipContent.frame.origin.y-3, 17,17 );
        [self.checkImage addTarget:self action:@selector(onClickedCheck) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.checkImage];
        
        UIView* lineView =[self loadSeprateLineWithFrame:CGRectMake(0, 150, kViewWeith, .5)];
        [self addSubview:lineView];
        
        self.okContent =[UIButton buttonWithType:UIButtonTypeCustom];
        self.okContent.frame =CGRectMake(0, 151, kViewWeith, 40);
        self.okContent.clipsToBounds =YES;
        self.okContent.backgroundColor =[UIColor clearColor];
        [self.okContent setTitle:okContent forState:UIControlStateNormal];
        self.okContent.titleLabel.font =[UIFont systemFontOfSize:15.0];
        
        self.okContent.titleLabel.textColor =kGreenColor2;
        [self.okContent setTitleColor:kGreenColor2 forState:UIControlStateNormal];
        [self.okContent setTitleColor:kthreeColor forState:UIControlStateHighlighted];
        
        [self.okContent addTarget:self action:@selector(onClickedOk) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.okContent];
        
        self.jfqCheckMark = jifenName;
         
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
-(UIView *)loadSeprateLineWithFrame:(CGRect) frame{
    UIView *line =[[UIView alloc] initWithFrame:frame];
    line.backgroundColor =kSilverColor2;
    return line;
}
-(UILabel *)loadLabelWithFrame:(CGRect) frame andText:(NSString *)text andFont:(UIFont *)font{
    UILabel *lab =[[UILabel alloc] initWithFrame:frame];
    lab.font =font;
    lab.text =text;
    lab.numberOfLines =0;
    lab.lineBreakMode = NSLineBreakByWordWrapping;
    lab.textColor =KRedColor2_0;
    lab.backgroundColor =[UIColor clearColor];
    return lab;
}
-(UIImageView *)loadImageViewWithFrame:(CGRect) frame andImage:(UIImage *)image orImageUrl:(NSString *)imgUrl{
    UIImageView *img =[[UIImageView alloc] initWithImage:image];
    img.frame= frame;
    if (image ==nil) {
        [img setImageWithURL:[NSURL URLWithString:imgUrl] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage imageNamed:@"touxiang2.png"]];
    }
    return img;
}
-(UIButton *)loadBtnWithFrame:(CGRect) frame andTitle:(NSString *)title{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitleColor:KGreenColor2_0 forState:UIControlStateNormal];
    [btn setTitleColor:kthreeColor forState:UIControlStateHighlighted];
    return btn;
}
-(id)initWithTitle:(NSString *)title andUserPic:(NSData *)userPicData andProduceImg:(UIImage *)img andIntroduce:(NSString *)intro okBtnTitle:(NSString *)okTitle cancleTitle:(NSString *)cancelTitle{
    self =[super init];
    if (self) {
         self.clipsToBounds =YES;
        UIView *bgView =[self loadSeprateLineWithFrame:CGRectMake(0, 0, kViewWeith, kCodeViewHeight)];
        bgView.backgroundColor =[UIColor whiteColor];
        bgView.layer.cornerRadius =5.0;
        [self addSubview:bgView];
        
        self.alertViewTitle =[self loadLabelWithFrame:CGRectMake(0, kYOff, kViewWeith, 16.0) andText:title andFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        self.alertViewTitle.textAlignment =NSTextAlignmentCenter;
        [self addSubview:self.alertViewTitle];
        
        DashLine *dashLine =[[DashLine alloc] initWithFrame:CGRectMake(0, kLineOffY, kViewWeith, 0.6)];
        [self addSubview:dashLine];
        
        self.codeImg =img;
        self.codeImgView =[self loadImageViewWithFrame:CGRectMake((kViewWeith -kCodeImgSize) /2, dashLine.frame.origin.y +10, kCodeImgSize, kCodeImgSize) andImage:img orImageUrl:nil];
        [self addSubview:self.codeImgView];
       
        UIImageView *userPic;
        if (userPicData) {
          userPic =[self loadImageViewWithFrame:CGRectMake((kViewWeith -kUserPicImgSize) /2, self.codeImgView.frame.origin.y +(kCodeImgSize -kUserPicImgSize)/2, kUserPicImgSize, kUserPicImgSize) andImage:[UIImage imageWithData:userPicData] orImageUrl:nil];
        }else{
             userPic =[self loadImageViewWithFrame:CGRectMake((kViewWeith -kUserPicImgSize) /2, self.codeImgView.frame.origin.y +(kCodeImgSize -kUserPicImgSize)/2, kUserPicImgSize, kUserPicImgSize) andImage:nil orImageUrl:[[MyUserDefault standardUserDefaults] getUserIconUrl]];
        }
      
        userPic.frame =CGRectMake((kCodeImgSize -kUserPicImgSize) /2, (kCodeImgSize -kUserPicImgSize)/2, kUserPicImgSize, kUserPicImgSize);
        
        UIView *backView =[self loadSeprateLineWithFrame:CGRectMake(userPic.frame.origin.x -4, userPic.frame.origin.y -4, userPic.frame.size.width +8, userPic.frame.size.height +8)];
        backView.backgroundColor =[UIColor whiteColor];

        [self.codeImgView addSubview:backView];
        [self.codeImgView addSubview:userPic];
        
        self.oneContent =[self loadLabelWithFrame:CGRectMake((kViewWeith -180) /2 , self.codeImgView.frame.origin.y +self.codeImgView.frame.size.height , 180, 30) andText:intro andFont:[UIFont systemFontOfSize:11.0]];
        self.oneContent.textAlignment =NSTextAlignmentCenter;
        [self addSubview:self.oneContent];
        
        UIView *line =[self loadSeprateLineWithFrame:CGRectMake(0, kCodeViewHeight-40, kViewWeith, 0.5)];
        [self addSubview:line];
        
        NSArray *arr =[[NSArray alloc] initWithObjects:cancelTitle,okTitle, nil];
        if (![NSString isEmply:cancelTitle] && ![NSString isEmply:okTitle]) {
            for (int i=0; i<2; i ++) {
              UIButton *btn =[self loadBtnWithFrame:CGRectMake(kViewWeith/2 *i, line.frame.origin.y, kViewWeith /2, 40) andTitle:[arr objectAtIndex:i]];
                btn.clipsToBounds =YES;
                btn.tag =i;
                [btn addTarget:self action:@selector(onClickedCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
            }
        }
        UIView *line2 =[self loadSeprateLineWithFrame:CGRectMake(kViewWeith/2, line.frame.origin.y, 0.5, 40)];
        [self addSubview:line2];
         self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
-(void)onClickedCodeBtn:(UIButton *)btn{
    if (btn.tag ==1) {
       // 保存2维码 到相册
        [self.TMAlertDelegate onClickedSaveCodeImage];
    }
    [self.backImageView removeFromSuperview];
     self.backImageView =nil;
    [self removeFromSuperview];
}


- (void)show
{
    if (self.isChecked ==YES) {
        [self.checkImage setBackgroundImage:self.isCheckImage forState:UIControlStateNormal];
    }else {
        [self.checkImage setBackgroundImage:self.noCheckImage forState:UIControlStateNormal];
    }
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kViewWeith) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kViewHeigth) * 0.5, kViewWeith, kViewWeith);
   
    [topVC.view addSubview:self];
}
-(void)showCodeView{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kViewWeith) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kCodeViewHeight) * 0.5, kViewWeith, kCodeViewHeight);
    
    [topVC.view addSubview:self];
}
- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.3f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];

    [UIView animateWithDuration:0.17 animations:^{
        self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.12 animations:^{
            self.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.layer.transform = CATransform3DIdentity;
            } completion:^(BOOL finished) {
               
            }];
        }];
    }];
}

-(void)onClickedCheck{
    NSUserDefaults* ud =[NSUserDefaults standardUserDefaults];
    // 点击不再提示  记录下某个积分墙的提示状态  1为不提示  0为提示
    if (self.isChecked) {
        [self.checkImage setBackgroundImage:self.noCheckImage forState:UIControlStateNormal];
        [ud setObject:[NSNumber numberWithInt:0] forKey:kJFQIsCheck];
        self.isChecked =NO;
    }else{
     [self.checkImage setBackgroundImage:self.isCheckImage forState:UIControlStateNormal];
        [ud setObject:[NSNumber numberWithInt:1] forKey:kJFQIsCheck];
        self.isChecked =YES;
    }
}
-(void)onClickedOk{
//    [[MyUserDefault standardUserDefaults] setIsShowDutyView:[NSNumber numberWithInt:1]];
    [self.TMAlertDelegate onClickedTMAlerViewButton];
    [self.backImageView removeFromSuperview];
    self.backImageView =nil;
    
    [self removeFromSuperview];
    
    
}
-(void)remakeContent{
    
    self.alertViewTitle.frame=CGRectMake(0, kYOff, kViewWeith, 16.0);
    self.dengpao.frame =CGRectMake(78, kYOff-3, 17, 18);

    [self.oneContent sizeToFit];
    self.oneContent.frame =CGRectMake(10, kYOff2, kViewWeith -12, self.oneContent.frame.size.height);
    

    [self.twoContent sizeToFit];
    self.twoContent.frame =CGRectMake(10, self.oneContent.frame.origin.y+self.oneContent.frame.size.height+5, kViewWeith-12, self.twoContent.frame.size.height);
    

    [self.threeContent sizeToFit];
    self.threeContent.frame =CGRectMake(10, self.twoContent.frame.origin.y+self.twoContent.frame.size.height+5, kViewWeith-12, self.threeContent.frame.size.height);
    

    [self.fourContent sizeToFit];
    self.fourContent.frame =CGRectMake(10, self.threeContent.frame.origin.y+self.threeContent.frame.size.height+5, kViewWeith-12, self.fourContent.frame.size.height);

    
}

@end
