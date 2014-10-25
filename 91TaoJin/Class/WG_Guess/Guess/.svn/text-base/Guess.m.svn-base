//
//  Guess.m
//  91TaoJin
//
//  Created by keyrun on 14-5-29.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "Guess.h"

@implementation Guess
/**
 *  初始化竞猜信息对象
 *
 *  @param lastMessage 上期开奖信息
 *  @param goldLimit   最少金豆参与
 *  @param goldNum     每次投注金额
 *  @param goldAllNum  本期参与金豆数
 *  @param personNum   参与人数
 *  @param time        倒计时
 *  @param betsNum     本轮投注号码
 *
 */
-(id)initWithLastMessage:(NSDictionary *)lastMessage goldLimit:(int )goldLimit goldNum:(int )goldNum
              goldAllNum:(int )goldAllNum personNum:(int )personNum time:(int )time betsNum:(int )betsNum{
    self = [super init];
    if(self){
        self.guess_lastMessageDic = lastMessage;
        self.guess_goldLimit = goldLimit;
        self.guess_goldNum = goldNum;
        self.guess_goldAllNum = goldAllNum;
        self.guess_personNum = personNum;
        self.guess_time = time;
        self.guess_betsNum = betsNum;
    }
    return self;
}
@end
