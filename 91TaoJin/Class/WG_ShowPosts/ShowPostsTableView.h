//
//  ShowPostsTableView.h
//  91TaoJin
//
//  Created by keyrun on 14-5-26.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPostsHeadView.h"
#import "CommentViewController.h"
#import "ShowPosts.h"

typedef void (^ ChangeShowPostsTypeBlock)(void);

/*
@protocol ShowPostsTableViewDelegate;

@interface ShowPostsTableView : UITableView<UITableViewDelegate,UITableViewDataSource,ShowPostsRefreshTableHeaderDelegate,ReloadViewDelegate>
 */
@interface ShowPostsTableView : UITableView<UITableViewDelegate,UITableViewDataSource,ReloadViewDelegate>

@property (nonatomic, strong) ShowPostsHeadView *showPostsHeadView;
@property (nonatomic, retain) ShowPosts *showPosts;                                           //晒单对象（全部）
@property (nonatomic, retain) ShowPosts *myShowPosts;                                         //晒单对象（我的）
@property (nonatomic, retain) ShowPosts *myOldPost;                                           //保存上一次的晒单对象（我的）
@property (nonatomic, assign) BOOL isRequesting;                                                //标识是否正在请求数据或者刷新界面
@property (nonatomic, copy) ChangeShowPostsTypeBlock block;

-(void)refrushView;

/**
 *  请求获取晒单列表
 *
 *  @param showPostsId 获取晒单的用户ID，为0表示获取所有晒单
 */
-(void)initObjects;

-(void)changeShowPostType:(int)typeId;;

@end

@protocol ShowPostsTableViewDelegate

-(void)pushToCommentVCWithGold:(int )goldOne goldTwo:(int )goldTwo;       //点击参与晒单

@end