//
//  LotteryReward.h
//  91淘金
//
//  Created by keyrun on 14-7-14.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryReward : NSObject

@property (nonatomic ,assign) int LRGold ;       //type =2 时的金豆数
@property (nonatomic ,assign) int LRId ;         //奖品id
@property (nonatomic ,assign) int LRType ;       // 奖品类型
@property (nonatomic ,strong) NSString *LRImageUrl ;    //奖品图片地址
@property (nonatomic ,assign) int LRImageHeight ;      // 奖品图片大小

-(id)initLotteryRewardWithDic:(NSDictionary *)dataDic;
@end
