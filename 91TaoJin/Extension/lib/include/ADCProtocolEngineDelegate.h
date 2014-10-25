//
//  ADCProtocolEngineDelegate.h
//  AppDriverBanner
//
//  Created by song duan on 12-5-2.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADCProtocolEngineSelector : NSObject {
    
}

+ (SEL)getResponseSEL:(NSInteger)aProtocolApiId;

@end


@protocol ADCProtocolEngineDelegate

@optional

#pragma mark - Advertisement Splash 接口

/*
 function: 获得全屏广告数据返回
 parameter: @aRequestId, http请求id
 @aResponseObject
 */
- (NSNumber *)getSplashAdvertisementListResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;


#pragma mark - Advertisement Banner 接口

/*
 function: 获得广告列表数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)getBannerAdvertisementListResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 发送已经成功安装的app到服务器数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)sendBannerAdvertisementActionResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 发送非推广安装的app到服务器数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)sendBannerAdvertisementReportResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 发送PV到服务器，既每个广告的展示次数数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)sendBannerAdvertisementPVResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

#pragma mark - Advertisement Wall 接口

/*
 function: 获得广告列表数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)getWallAdvertisementListResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 获得积分墙banner数据
 parameter: @aRequestId, http请求id
 @aResponseObject
 */
- (NSNumber *)getWallAdvertisementBannerListResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;


/*
 function: 发送已经成功安装的app到服务器数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)sendWallAdvertisementActionResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 发送非推广安装的app到服务器数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)sendWallAdvertisementReportResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 向服务器请求积分的返回
 parameter: @aRequestId, http请求id
            aResponseObject
 */
- (NSNumber *)getWallAdvertisementScoreResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 向服务器请求消耗积分的返回
 parameter: @aRequestId, http请求id
 aResponseObject
 */
- (NSNumber *)getWallAdvertisementReduceScoreResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: 程序第一次启动，调用该接口，发送相应数据到服务器（仅限广告主）数据返回
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)sendAdvertisementActionForAdvertiserResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;

/*
 function: web to app 使用时检测点击，根据返回值确定是否需要跳转浏览器
 parameter: @aRequestId, http请求id
            @aResponseObject
 */
- (NSNumber *)web2AppCheckClickResponse:(NSNumber *)aRequestId withObject:(id)aResponseObject;



@end

