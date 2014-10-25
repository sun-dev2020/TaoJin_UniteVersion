//
//  ADCAdvertiser.h
//  AppDriverBanner
//
//  Created by song duan on 12-5-28.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADCAdvertiser : NSObject

/*
 function: 广告主发送该请求到服务端，上传一些参数。
 parameter: @siteId， AppDriver生成，开发者从AppDriver网站上可获得。
            @siteKey，AppDriver生成，开发者从AppDriver网站上可获得。
            @advertisement，AppDriver生成，开发者从AppDriver网站上可获得。
            @campaignId，活动id。AppDriver生成，开发者从AppDriver网站上可获得。
            @sandBox，YES用正是环境，NO用测试环境
 */

+ (void)advertiserWithSiteId:(NSString *)siteId
                     siteKey:(NSString *)siteKey 
               advertisement:(NSString *)advertisement 
                  campaignId:(NSString *)campaignId 
                     sandBox:(BOOL)sandBox;
@end
