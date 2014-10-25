//
//  RewardGoods.m
//  TJiphone
//
//  Created by keyrun on 13-10-29.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardGoods.h"

@implementation RewardGoods

-(id)initRewardGoodsByDic:(NSDictionary* )dic{
    self =[super init];
    if (self) {
        
    self.goodsType =[[dic objectForKey:@"Type"]integerValue];
    self.goodsStatus =[[dic objectForKey:@"Status"]integerValue];
    self.goodsPs =[dic objectForKey:@"Ps"];
    self.goodsOrder =[[dic objectForKey:@"Order"]integerValue];
    self.goodsName =[dic objectForKey:@"product"];
    NSString* string =[dic objectForKey:@"Time"];
       
    double dtime=[string doubleValue];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:dtime];
    NSTimeZone* zone=[NSTimeZone systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:date];
    NSDate* locationDate=[date dateByAddingTimeInterval:interval];
    NSString* timeStr =[locationDate description];
    NSArray* arr =[timeStr componentsSeparatedByString:@" "];
        
    self.goodsTime =[NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:1]];

        
    
    self.goodsProduce =[dic objectForKey:@"Produce"];
    if (self.goodsType ==2 ||self.goodsType ==4) {
        self.goodsPhone =[dic objectForKey:@"Phone"];
    }
    if (self.goodsType ==4 || self.goodsType ==2) {
        self.goodsAddress =[dic objectForKey:@"Address"];
        self.goodsUserName =[dic objectForKey:@"Name"];
    }
   
    if (self.goodsType ==5) {
        self.goodsCard =[dic objectForKey:@"Card"];
    }
    if (self.goodsType ==5 ||self.goodsType ==4 ||self.goodsType ==3) {
        self.goodsCode =[dic objectForKey:@"Code"];
    }
    if (self.goodsType ==1) {
        self.goodsQQ =[dic objectForKey:@"QQ"];
    }
    }
    if (self.goodsType ==6 || self.goodsType ==7) {
        self.goodsUserAccount =[dic objectForKey:@"Account"];
    }
    
    return self;
}


@end
