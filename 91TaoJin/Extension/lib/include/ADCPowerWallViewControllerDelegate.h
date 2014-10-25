//
//  ADCADCPowerWallViewControllerDelegate.h
//  AppDriverBanner
//
//  Created by song duan on 12-5-22.
//  Copyright (c) 2012年 adways. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADCError.h"

@protocol ADCPowerWallViewControllerDelegate <NSObject>

@optional

/*
 function: 当退出动力墙完成后调用此委托方法通知用户。
 */

- (void)powerWallDidDismiss;

/*
 function: 请求动力墙的iPhone App列表完成后返回数据。
 parameter: @responseObject, 如果responseObject类型是NSString类型的表示获取数据成功，数据是已JSON格式返回的。
                             如果responseObject类型是ADCError类型的表示获取数据失败，具体错误请参考ADCError.h的定义。
 */
- (void)iOSAppListLoaded:(id)responseObject;

/*
 function: 获得用户积分成功后返回数据
 parameter: @totalScore, 用户的剩余总积分。当用户剩余总积分<=0时，totalScore的值都将返回0。
 */
- (void)getScoreFinished:(CGFloat)totalScore;

/*
 function: 获得用户积分失败
 parameter: @error, 获取用户积分失败后,返回出错信息。
 */
- (void)getScoreFailed:(ADCError *)error;

/*
 function: 用户消耗积分成功后返回总积分
 parameter: @totalScore, 用户的剩余总积分。当用户剩余总积分<=0时，totalScore的值都将返回0。
 */
- (void)reduceScoreFinished:(CGFloat)totalScore;

/*
 function: 用户消耗积分失败
 parameter: @error, 获取用户积分失败后,返回出错信息。
 */
- (void)reduceScoreFailed:(ADCError *)error;

@end
