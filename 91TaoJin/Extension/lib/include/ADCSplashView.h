//
//  ADCSplashView.h
//  AppDriverSDK
//
//  Created by li fengrong on 13-4-18.
//  Copyright (c) 2014年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCProtocolEngineDelegate.h"
#import "ADCUrlImageQueueDelegate.h"
#import <QuartzCore/QuartzCore.h>

@class  ADCUrlImageQueue;

@protocol ADCSplashViewDelegate;

@interface ADCSplashView : UIView<ADCProtocolEngineDelegate,
ADCUrlImageQueueDelegate>
{
    NSString                        *_siteId;
    NSString                        *_siteKey;
    NSString                        *_mediaId;
    NSString                        *_userIdentifier;
    BOOL                             _useSandBox;
    id<ADCSplashViewDelegate>        _splashViewDelegate;
    
@private
    
    UIImageView                     *_showImageView;
    NSMutableArray                  *_requestIDArray;
    UIButton                        *_closeButton;
    NSMutableArray                  *_needShowArray;
    NSMutableArray                  *_cacheListArray;
    NSMutableArray                  *_isReadyArray;
    ADCUrlImageQueue                *_urlImageQueue;
    NSString                        *_orientationTYpeString;
    UIView                          *_backgroundView;
    UIView                          *_contentView;
    NSInteger                        _errorNumber;
    UIButton                        *_touchButton;
    NSString                        *_domain;
    BOOL                             _isNeedDownload;
}

@property(nonatomic, copy) NSString *siteId;
@property(nonatomic, copy) NSString *siteKey;
@property(nonatomic, copy) NSString *mediaId;
@property(nonatomic, copy) NSString *userIdentifier;
@property(nonatomic, copy) NSString *orientationTYpeString;
@property(nonatomic, assign) BOOL useSandBox;
@property(nonatomic, assign) id<ADCSplashViewDelegate>splashViewDelegate;


/*
 function: 创建并返回一个新的ADCSplashView实例。
 parameter: @siteId， AppDriver生成，开发者从AppDriver网站上可获得。
            @siteKey，AppDriver生成，开发者从AppDriver网站上可获得。
            @mediaId，AppDriver生成，开发者从AppDriver网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @splashViewOrientationType 传入屏幕的方向，参数采用官方标准，示例：UIInterfaceOrientationPortrait
            @sandBox，NO用正式环境，YES用测试环境。
            @useReward，YES获取缓存列表数据，NO不请求数据列表
            @delegate， 设置代理
 retrun value: ADCSplashView 对象
 */
+ (ADCSplashView *)initWithSiteId:(NSString *)siteId
                          siteKey:(NSString *)siteKey
                          mediaId:(NSString *)mediaId
                   userIdentifier:(NSString *)userIdentifier
                       orentation:(UIInterfaceOrientation)splashViewOrientationType
                       useSandBox:(BOOL)useSandBox
                        useReward:(BOOL)useReward
                         delegate:(id<ADCSplashViewDelegate>)delegate;

/*
 function: 初始化一个新的ADCSplashView实例。
 parameter: @splashViewOrientationType 传入屏幕的方向，参数采用官方标准，示例：UIInterfaceOrientationPortrait
            @siteId，AppDriver生成，开发者从AppDriver网站上可获得。
            @splashFrame， 设置view的位置和大小。
            @siteKey，AppDriver生成，开发者从AppDriver网站上可获得。
            @mediaId，AppDriver生成，开发者从AppDriver网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境。
            @delegate，设置代理。
 retrun value: ADCSplashView对象。
 */
- (id)initWithSplashViewOrentationType:(UIInterfaceOrientation)splashViewOrientationType
                           splashFrame:(CGRect)frame
                                siteId:(NSString *)siteId
                               siteKey:(NSString *)siteKey
                               mediaId:(NSString *)mediaId
                        userIdentifier:(NSString *)userIdentifier
                            useSandBox:(BOOL)useSandBox
                              delegate:(id<ADCSplashViewDelegate>)delegate;

/*
 function: 判断本地是否有资源
 */
- (BOOL)isReady;

/*
 function: 请求广告队列
 */
- (void)loadRequestList;

@end


@protocol ADCSplashViewDelegate<NSObject>

@optional

- (void)closeSplashView;                        //关闭splashView的回调方法
- (void)clickImageSplashView;                   //点击图片的回调方法

@end