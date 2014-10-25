//
//  ActivityCenterViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-5-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPostsTableView.h"
#import "TakePartTableView.h"
#import "ShareTableView.h"
@interface ActivityCenterViewController : UIViewController<ShowPostsTableViewDelegate>
-(void)initObjects;

@property (nonatomic, strong) TakePartTableView *takePartTableView;                           //【天天参与】列表
@property (nonatomic, strong) ShowPostsTableView *showPostsTableView;                         //【晒单有奖】视图
@property (nonatomic, strong) ShareTableView *shareTableView;                                 //【分享有奖】视图

@property (nonatomic, assign) int currentType;                                                //记录当前显示的是哪个界面（1：天天参与；2：晒单有奖；3：分享有奖）

@end
