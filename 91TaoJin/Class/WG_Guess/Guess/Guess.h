//
//  Guess.h
//  91TaoJin
//
//  Created by keyrun on 14-5-29.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Guess : NSObject

@property (nonatomic, strong) NSDictionary *guess_lastMessageDic;       //上期开奖信息
@property (nonatomic, assign) int guess_goldLimit;                      //最少金豆参与
@property (nonatomic, assign) int guess_goldNum;                        //每次投注金额
@property (nonatomic, assign) int guess_goldAllNum;                     //本期参与金豆数
@property (nonatomic, assign) int guess_personNum;                      //参与人数
@property (nonatomic, assign) int guess_time;                           //倒计时
@property (nonatomic, assign) int guess_betsNum;                        //本轮投注号码

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
              goldAllNum:(int )goldAllNum personNum:(int )personNum time:(int )time betsNum:(int )betsNum;

@end
