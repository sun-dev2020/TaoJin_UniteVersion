//
//  ADCPowerWallViewController.h
//  AppDriverBanner
//
//  Created by song duan on 12-5-16.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCProtocolEngineDelegate.h"
#import "ADCPowerWallViewControllerDelegate.h"


@interface ADCPowerWallViewController : UIViewController<ADCProtocolEngineDelegate>

@property (nonatomic, copy) NSString *mediaCurrency;
@property (nonatomic, copy) NSString *userIdentifier;
@property (nonatomic, copy) NSString *siteId;
@property (nonatomic, copy) NSString *siteKey;
@property (nonatomic, copy) NSString *mediaId;
@property (nonatomic, assign) BOOL useSandBox;
@property (nonatomic, assign) id<ADCPowerWallViewControllerDelegate> delegate;

/*
 function: 创建并返回一个新的ADCPowerWallViewController实例。
 parameter: @siteId， AppDriver生成，开发者从AppDriver网站上可获得。
            @siteKey，AppDriver生成，开发者从AppDriver网站上可获得。
            @mediaId，AppDriver生成，开发者从AppDriver网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境。
            @useReward，YES使用AppDriver的积分系统，NO不使用AppDriver的积分系统。
            @powerWallViewControllerDelegate， ADCADCPowerWallViewControllerDelegate
 retrun value: ADCPowerWallViewController 对象
 */
+ (ADCPowerWallViewController *)initWithSiteId:(NSString *)siteId
                                       siteKey:(NSString *)siteKey
                                       mediaId:(NSString *)mediaId
                                userIdentifier:(NSString *)userIdentifier
                                    useSandBox:(BOOL)useSandBox
               powerWallViewControllerDelegate:(id)powerWallViewControllerDelegate;

/*
 function: 创建并返回一个新的ADCPowerWallViewController实例。
 parameter: @viewController，从该UIViewController的界面切换到动力墙界面。
            @siteId， AppDriver生成，开发者从AppDriver网站上可获得。
            @siteKey，AppDriver生成，开发者从AppDriver网站上可获得。
            @mediaId，AppDriver生成，开发者从AppDriver网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @useReward，YES使用AppDriver的积分系统，NO不使用AppDriver的积分系统。
            @sandBox，NO用正式环境，YES用测试环境。
 retrun value: ADCPowerWallViewController 对象
 */
+ (ADCPowerWallViewController *)showPowerWallViewFromViewController:(UIViewController *)viewController 
                                                             siteId:(NSString *)siteId
                                                            siteKey:(NSString *)siteKey
                                                            mediaId:(NSString *)mediaId
                                                     userIdentifier:(NSString *)userIdentifier 
                                                         useSandBox:(BOOL)useSandBox;

/*
 function: 获取动力墙上的激励列表（当您需要自定义动力墙UI时使用）。
 parameter: @pageSize，每一页返回数据的大小（条数）。
            @pageNumber，请求哪一页数据。起始页码从1开始。
 */
- (void)loadiOSAppList;

/*
 function: 使用积分后，对积分进行减操作。
 parameter: @score，需要减掉的积分值。
 retrun value: 减掉积分后的剩余积分，当剩余积分为<=0时都返回0
 */
- (void)reduceScore:(CGFloat)score;

/*
 function: 获得用户的剩余积分。
 */
- (void)getScore;

@end
