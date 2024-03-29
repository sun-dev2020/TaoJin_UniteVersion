//
//  QumiOfferWall.h
//  QumiAdWall
//
//  Created by 趣米-顾常新 on 14-2-28.
//  Copyright (c) 2014年 Qumi_SDK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QMOfferWallDelegate;

@interface QumiOfferWall : UIViewController
{
    id<QMOfferWallDelegate>   _delegate;
    UIViewController         *_rootViewController;
    BOOL                      _isHiddenStatusBar;   //是否隐藏信号区 YES隐藏  NO显示
}
@property (nonatomic,retain) id<QMOfferWallDelegate> delegate;
@property (nonatomic,retain) UIViewController       *rootViewController;
@property (nonatomic,assign)  BOOL                   isHiddenStatusBar;



//如果你希望在几部不同的设备中同步积分，比如你的app是游戏类的，用户注册了一个游戏账号，当这个用户换另一部手机，用该账号登陆，期望同步该账户的积分。这种情况可以设置用户pointUserId，pointUserId的优先级高于设备序列号，所以要请谨慎设置，有问题可以咨询我们商务或者技术
- (id)initwithPointUserID:(NSString *)pointUserId;

//弹出趣米积分墙
- (void)presentQumiOfferWall;

//自动检查领取积分，如果您要使用自动领取积分功能 就选择调用该方法，填写YES，就会自动检查是否有积分可以领取，填写NO，就不会检查是否有积分领取，那么就需要您调用手动领取。
- (void)autoGetPoints:(BOOL)isAutoCheck;

//手动检查领取积分 开发者可以选择手动调用检查领取积分的方法。
- (void)getPointsQueue;

//查询剩余积分
- (void)queryRemainPoints;

//消费积分
- (void)consumePoints:(NSInteger)points;

//追加积分
- (void)appendPoints:(NSInteger)points;

@end

@protocol QMOfferWallDelegate <NSObject>

@optional
#pragma mark QumiAdWall Methods
/**********************************
 *   积分墙加载，展示，关闭的回调方法   *
 **********************************/
//积分墙加载成功，回调该方法
- (void)QumiAdWallSuccessToLoaded:(QumiOfferWall *)qumiAdWall;

//加载广告失败后，回调该方法
- (void)QumiAdWallFailToLoaded:(QumiOfferWall *)qumiAdWall withError:(NSError *)error;

//积分墙开始展示，回调该方法
- (void)QumiAdWallPresent:(QumiOfferWall *)qumiAdWall;

//积分墙关闭，回调该方法
- (void)QumiAdWallDismiss:(QumiOfferWall *)qumiAdWall;

#pragma mark QumiAdWall CheckPoints Methods
/************************************************
 *   检查积分，获取积分，消费积分，追加积分的回调方法   *
 ************************************************/
@required
/*
 *注意：该方法必选，否则无法正常获取积分
 */
//请求领取积分成功方法的回调
- (void)qumiAdWallGetPointSuccess:(NSString *)getPointState getPoints:(NSInteger)points;

//请求领取积分失败方法的回调
- (void)qumiAdWallGetPointFailed:(NSError *)error;

//请求检查剩余积分成功后，回调该方法，获得总积分数和返回的积分数。
- (void)QumiAdWallCheckPointsSuccess:(NSInteger)remainPoints;

//请求检查剩余积分失败后，回调该方法，返回检查积分失败信息
-(void)QumiAdWallCheckPointsFailWithError:(NSError *)error;

#pragma mark QumiAdWall ConsumePoints Mehtods
//消费请求成功之后，回调该方法，返回消费情况(消费成功，或者当前的积分不足)，以及当前的总积分数
- (void)QumiAdWallConsumePointsSuccess:(NSString *)ConsumeState remainPoints:(NSInteger)points;

//消费请求失败之后，回调该方法，返回失败信息。
- (void)QumiAdWallConsumePointsFailWithError:(NSError *)error;

#pragma mark QumiAdWall AppendPoints Mehtods
//追加积分成功后，回调该方法，返回追加积分的情况(追加积分成功)，以及当前的总积分数
- (void)QumiAdWallAppendPointsSuccess:(NSString *)appendState remainPoints:(NSInteger)points;

//追加积分失败后，回调该方法，返回失败信息
- (void)QumiAdWallAppendPointsFailWithError:(NSError *)error;

@end
