//
//  DidRewardView.h
//  TJiphone
//
//  Created by keyrun on 13-9-29.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol DidRewardDelegate <NSObject>

@optional
-(void)didRewardGoodsPushToRewardListView;

@end


@interface DidRewardView : UIView<UIAlertViewDelegate>
{
    UILabel* titleText;
    UILabel* gift;
}

@property(nonatomic,strong) id <DidRewardDelegate> drDelegate;
@property(nonatomic,assign) int arg0;
@property(nonatomic,strong) GoodsModel* goods;
@property(nonatomic,strong) NSString* name;

@property (nonatomic ,strong) NSString *chargeStyle;   //兑换的内容
@property(nonatomic,assign) int QCount;
@property(nonatomic,strong)NSString* getCoins;
@property(nonatomic,strong)NSString* QNumber;

@property(nonatomic,assign) int getHfInt;
@property(nonatomic,strong)NSString* getHF;
@property(nonatomic,assign)int type;

@property(nonatomic,strong)UIImageView* imageView;
@property(nonatomic,assign)BOOL isRecharge;
@property(nonatomic,strong)NSString* rechargeType;

@property(nonatomic,assign)BOOL isAdress;


@property(nonatomic,assign) int needBean;      //tyep 3，5
@property(nonatomic,strong) NSString* area;
@property(nonatomic,strong) NSString* adress;
@property(nonatomic,strong)NSString* goodsName;
@property(nonatomic,assign)int JDs;
@property(nonatomic,strong)NSString* phoneNumber;

@property(nonatomic,assign) int rewardType;



-(void)setBasicView;


@end
