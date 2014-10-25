//
//  NewUserCenterController.h
//  91TaoJin
//
//  Created by keyrun on 14-5-24.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MScrollVIew.h"
#define kIncomeName @"收支明细"
#define kRewardName @"兑奖记录"
#define kMsgName @"消息中心"
#define kVisitName @"邀请奖励"
#define kMakeGrade @"求五星评价"

@interface NewUserCenterController : UIViewController<UITableViewDataSource ,UITableViewDelegate ,MScrollVIewDelegate>

@property (nonatomic, assign) BOOL isRequesting;                        //标识是否正在请求网络或者刷新界面

-(void)initWithObjects;

@end
