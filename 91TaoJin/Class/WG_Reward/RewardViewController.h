//
//  RewardViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RewardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
-(void)initWithObjects;
-(void)requestForUserBeans;

@property (nonatomic, strong) NSMutableArray *allGoodsAry;                                //产品数据数组
@property (nonatomic, assign) BOOL isRequesting;                                            //标识是否正在请求网络或者刷新界面
@property (nonatomic, assign) BOOL isRequestingWithGold;                                    //标识是否正在请求获取用户金豆数
@end
