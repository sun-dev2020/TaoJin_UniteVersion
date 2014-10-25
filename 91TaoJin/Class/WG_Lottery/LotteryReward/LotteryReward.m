//
//  LotteryReward.m
//  91淘金
//
//  Created by keyrun on 14-7-14.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "LotteryReward.h"

@implementation LotteryReward

-(id)initLotteryRewardWithDic:(NSDictionary *)dataDic{
    self =[super init];
    if (self) {
        self.LRGold =[[dataDic objectForKey:@"Gold"] intValue];
        self.LRId =[[dataDic objectForKey:@"Id"] intValue];
        self.LRType =[[dataDic objectForKey:@"Type"] intValue];
        NSDictionary *picDic =[dataDic objectForKey:@"Pic"];
        if (picDic) {
            self.LRImageUrl =[picDic objectForKey:@"Url"];
            self.LRImageHeight =[[picDic objectForKey:@"Height"] intValue];
        }
        
    }
    return self;
}
@end
