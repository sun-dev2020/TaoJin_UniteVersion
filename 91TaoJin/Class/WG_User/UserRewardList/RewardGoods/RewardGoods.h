//
//  RewardGoods.h
//  TJiphone
//
//  Created by keyrun on 13-10-29.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardGoods : NSObject

@property(nonatomic,assign) int goodsType;
@property(nonatomic,assign) int goodsOrder;   //订单号
@property(nonatomic,assign) int goodsStatus;   //出货状态
@property(nonatomic,strong) NSString* goodsTime;
@property(nonatomic,strong) NSString* goodsPs;  //附言
@property(nonatomic,strong) NSString* goodsProduce; //名称
@property(nonatomic,strong) NSString* goodsPhone;   //充值号，联系电话
@property(nonatomic,strong) NSString* goodsAddress;
@property(nonatomic,strong) NSString* goodsCard;    //充值卡密码
@property(nonatomic,strong) NSString* goodsCode;    //充值卡卡号
@property(nonatomic,strong) NSString* goodsQQ;
@property(nonatomic,strong) NSString* goodsUserName;
@property(nonatomic,strong) NSString* goodsUserAccount;    //财富通   支付宝账号
@property(nonatomic,strong) NSString* goodsName;
-(id)initRewardGoodsByDic:(NSDictionary* )dic;

@end
