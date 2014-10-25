//
//  TMAlertView.h
//  91TaoJin
//
//  Created by keyrun on 14-3-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol TMAlertViewDelegate <NSObject>

@optional
-(void)onClickedTMAlerViewButton;

-(void)onClickedSaveCodeImage ;
@end


@interface TMAlertView : UIView

-(id)initWithTitle:(NSString* )title andOneTip:(NSString* )oneTip andTwoTip:(NSString* )twoTip andThreeTip :(NSString* )threeTip andFourTip :(NSString* )fourTip andTipContent:(NSString* )tip andTipImage:(UIImage* )tipImage andTipHighlightImage:(UIImage*)highlightImage  andOkContent:(NSString *)okContent andBGImageL:(UIImage *)bgImage  jifenName:(NSString *)jifenName;

-(id)initWithTitle:(NSString *)title andUserPic:(NSData *)userPicData andProduceImg:(UIImage *)img andIntroduce:(NSString *)intro okBtnTitle:(NSString *)okTitle cancleTitle:(NSString *)cancelTitle;
-(void)show;
-(void)showCodeView;
-(void)remakeContent;

@property(nonatomic,strong) UIImageView* dengpao;
@property(nonatomic ,strong) UILabel* alertViewTitle;
@property(nonatomic ,strong) UIImageView* alertViewTitleImage;
@property(nonatomic ,strong) UILabel* oneContent;
@property(nonatomic ,strong) UILabel* twoContent;
@property(nonatomic ,strong) UILabel* threeContent;
@property(nonatomic ,strong) UILabel* fourContent;
@property(nonatomic ,strong) UILabel* tipContent;

@property(nonatomic ,strong) UIButton* checkImage;
@property(nonatomic ,strong) UIButton* okContent;
@property(nonatomic ,strong) UIImage* isCheckImage;
@property(nonatomic ,strong) UIImage* noCheckImage;

@property(nonatomic ,strong) UIImageView* bgImage;

@property(nonatomic ,strong) UIView* backImageView;

@property(nonatomic ,strong) UIButton* tipButton;
@property(nonatomic ,assign) BOOL isChecked;

@property(nonatomic ,strong) NSString* jfqCheckMark;

@property (nonatomic ,strong) UIImage *codeImg;
@property (nonatomic ,strong) UIImageView *codeImgView;

@property(nonatomic ,strong) id <TMAlertViewDelegate> TMAlertDelegate;
@end
