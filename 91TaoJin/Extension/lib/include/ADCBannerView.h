//
//  ADCBannerView.h
//  AppDriverBanner
//
//  Created by song duan on 12-5-10.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCProtocolEngineDelegate.h"
#import "ADCUrlImageQueueDelegate.h"

typedef enum {
    ADCBannerViewSize480x40 = 1,        //  (size: width = 480, height = 40)
    ADCBannerViewSize480x32,            //  (size: width = 480, height = 32)
    ADCBannerViewSize364x45,            //  (size: width = 364, height = 45)
    ADCBannerViewSize320x50,            //  (size: width = 320, height = 50)
    ADCBannerViewSize75x15,             //  (size: width = 75, height = 15)
    ADCBannerViewSize300X250,           //  (size: width = 300, height = 250)
    ADCBannerViewSize400X400,           //  (size: width = 400, height = 400 for iPad)
    ADCBannerViewSize1024X168,          //  (size: width = 1024, height = 168 for iPad)
    ADCBannerViewSize768x1024,          //  (size: width = 768, height = 1024 for iPad)
    ADCBannerViewSize1024x768,          //  (size: width = 1024, height = 768 for iPad)
    ADCBannerViewSize320X480,           //  (size: width = 320, height = 480)
    ADCBannerViewSize480X320,           //  (size: width = 480, height = 320)
    
    ADCBannerViewSizeTypeCount = ADCBannerViewSize480X320
} _ADCBannerViewSizeType;
typedef NSInteger ADCBannerViewSizeType;

@class ADCAdList;
@class ADCUrlImageQueue;

@protocol ADCBannerViewDelegate

- (void)requestDidFinished:(NSInteger)sumOfAd;
- (void)requestDidFailed:(ADCError *)error;

@end

@interface ADCBannerView : UIControl <ADCProtocolEngineDelegate, ADCUrlImageQueueDelegate>
{
    ADCBannerViewSizeType       _bannerViewSizeType;
    NSString                    *_siteId;
    NSString                    *_siteKey;
    NSString                    *_mediaId;
    NSString                    *_userIdentifier;
    BOOL                        _useSandBox;
    id<ADCBannerViewDelegate>   _bannerViewDelegate;
    
 @private
    ADCUrlImageQueue            *_urlImageQueue;
    NSString                    *_uiUrlString;
    NSInteger                   _currentAdIndex;
    NSMutableArray              *_requestIDArray;
    NSMutableArray              *_needShowAdInfoArray;
    NSMutableDictionary         *_reportedAdInfoDictionary;
    NSMutableDictionary         *_sendedPvDictionary;
    NSMutableArray              *_pvArray;
    NSTimer                     *_refreshUITimer;
    NSTimer                     *_sendPVTimer;
    BOOL                        _stopTimer;
    NSInteger                   _bannerListRequestErrorTime;
}
@property(nonatomic, assign) ADCBannerViewSizeType bannerViewSizeType;
@property(nonatomic, copy) NSString *siteId;
@property(nonatomic, copy) NSString *siteKey;
@property(nonatomic, copy) NSString *mediaId;
@property(nonatomic, copy) NSString *userIdentifier;
@property(nonatomic, assign) BOOL useSandBox;
@property (nonatomic,assign) id<ADCBannerViewDelegate> bannerViewDelegate;
/*
 function: 初始化ADCBannerView并返回一个新的ADCBannerView实例。
 parameter: @bannerViewSizeType，bannerView的尺寸，详情参考_ADCBannerViewSizeType定义。
            @origin，bannerView的位置坐标。bannerView的参考点在bannerView的左上角。
            @siteId， AppDriver生成，开发者从AppDriver网站上可获得。
            @siteKey，AppDriver生成，开发者从AppDriver网站上可获得。
            @mediaId，AppDriver生成，开发者从AppDriver网站上可获得。
            @userIdentifier，标识一个用户的变量。你可以给不同的用户设置不同的值。这是一个可选参数。
            @sandBox，NO用正式环境，YES用测试环境
 retrun value: ADCBannerView 对象。
 */
- (id)initWithBannerViewSizeType:(ADCBannerViewSizeType)bannerViewSizeType
                          origin:(CGPoint)origin 
                          siteId:(NSString *)siteId
                         siteKey:(NSString *)siteKey
                         mediaId:(NSString *)mediaId
                  userIdentifier:(NSString *)userIdentifier
                      useSandBox:(BOOL)useSandBox
                        delegate:(id<ADCBannerViewDelegate>)delegate;

/*
 function: 请求广告列表
 */
- (void)loadRequest;

/*
 function: 停止更新广告掉的定时器。在不需要广告条的时候（释放ADCBannerView前）一定要调用该方法才能释放ADCBannerView对象。
 */
- (void)stopUpdateBannerTimer;     

@end
