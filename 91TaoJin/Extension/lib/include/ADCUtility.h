//
//  ADCProxy.h
//  AppDriverBanner
//
//  Created by  on 12-5-22.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCProtocolEngineDelegate.h"
#import "ADCRegisterDelegate.h"

@interface ADCUtility : NSObject <ADCProtocolEngineDelegate,ADCRegisterDelegate>
{
    NSTimer *timer;
}

/*
 function: 获取当前sdk的版本号
 */

+ (NSString *)appDriverVersion;

/*
 function: web to app 中用于检测是否点击，根据返回值决定是否需要跳转浏览器以便获得UUID。
 parameter: @siteId， AppDriver生成，开发者从AppDriver网站上可获得。
            @mediaId，AppDriver生成，开发者从AppDriver网站上可获得。
            @siteKey，AppDriver生成，开发者从AppDriver网站上可获得。
            @advertisement，AppDriver生成，开发者从AppDriver网站上可获得。
            @campaignId，活动id。（App id，标示一个被推广的app）。广告列表中获得的。
            @sandBox，YES用测试环境，NO用正式环境
 */
- (void)web2AppCheckClickWithSiteId:(NSString *)siteId 
                            siteKey:(NSString *)siteKey 
                      advertisement:(NSString *)advertisement 
                         campaignId:(NSString *)campaignId 
                            sandBox:(BOOL)sandBox
                           delegate:(id<ADCRegisterDelegate>)delegate;

/*
 function: makeRegister 用于将浏览器返回App时传递的参数存储在本地,这个方法必须在application:handleOpenURL中使用。
 parameter: @registerURL 浏览器打开本地App的URL,值为application:handleOpenURL方法的handleOpenURL参数。
 */
- (void)makeRegisterWithDelegate:(id<ADCRegisterDelegate>)delegate sourceURL:(NSURL *)registerURL;


@end

