//
//  RewardListViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "RewardListViewController.h"
#import "MScrollVIew.h"
#import "RewardListCell.h"
#import "LoadingView.h"
#import "ViewTip.h"
#import "RewardViewController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "TablePullToLoadingView.h"

@interface RewardListViewController ()
{
    //    HeadView *headView;
    MScrollVIew *ms;
    
    NSMutableArray *allLogs;
    UITableView *tableView0;
    
    int page;
    int curPage;
    int maxPage;
    int timeOutCount;                                                   //连接超时次数
    
    BOOL isFrist;                                                       //标识是否第一次请求数据
}
@end

@implementation RewardListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

//初始化变量
-(void)initWithObjects{
    page = 1;
    curPage =0;
    maxPage =0;
    isFrist = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //ios7 以上，更改状态栏的样式
    //    if (IOS_Version >=7.0) {
    //        UIView* statusView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 20)];
    //        statusView.backgroundColor =[UIColor blackColor];
    //        [self.view addSubview:statusView];
    //    }
    
    [self initWithObjects];
    
    HeadToolBar *headBar = [[HeadToolBar alloc] initWithTitle:@"兑奖记录" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    if (IOS_Version >= 7.0) {
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height + 20) andWithPageCount:3 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y + headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height) andWithPageCount:3 backgroundImg:nil];
    }
    ms.bounces = NO;
    [ms setContentSize:CGSizeMake(kmainScreenWidth,ms.frame.size.height)];
    
    [self.view addSubview:ms];
    
    
    tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, ms.frame.size.height - 20) style:UITableViewStylePlain];
    [tableView0 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView0.delegate = self;
    tableView0.dataSource = self;
    tableView0.backgroundView = nil;
    tableView0.backgroundColor = [UIColor clearColor];
    tableView0.delaysContentTouches =NO;
    
    TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] init];
    tableView0.tableFooterView = loadingView;
    tableView0.tableFooterView.hidden = YES;
    
    [ms addSubview:tableView0];
    
    [self performSelector:@selector(requestToGetRewardList) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (IOS_Version >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    if (self.isRootPush ) {
        if (IOS_Version >= 7.0) {
            self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan =YES;
        }
        [[MyUserDefault standardUserDefaults] setIsNeedReloadRV:[NSNumber numberWithInt:1]];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [allLogs removeAllObjects];
    allLogs = nil;
    [tableView0 removeFromSuperview];
    tableView0 = nil;
    [ms removeFromSuperview];
    ms = nil;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]] && ![otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
            if (self.isRootPush ) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            return YES;
        }
    }
    
    return YES;
}
//请求获取【兑奖中心】列表
-(void)requestToGetRewardList{
    if (isFrist) {
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":[NSNumber numberWithInt:page]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardRecord"];
    NSLog(@"请求获取【兑奖中心】列表【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求获取【兑奖中心】列表【response】 = %@",dataDic);
            timeOutCount = 0;
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"CurPage"] intValue];
                    maxPage = [[body objectForKey:@"MaxPage"] intValue];
                    int maxNum = [[body objectForKey:@"MaxNum"] intValue];
                    if(maxNum == 0){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tableView0.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [self showTipView];
                        });
                    }else{
                        NSArray *orders = [body objectForKey:@"Orders"];
                        if(orders != nil && orders.count > 0 && curPage == page){
                            page ++;
                            if(allLogs == nil){
                                allLogs = [[NSMutableArray alloc] initWithArray:orders];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    tableView0.tableFooterView.hidden = YES;
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    [tableView0 reloadData];
                                });
                            }else{
                                NSMutableArray *paths =[[NSMutableArray alloc] init];
                                for (int i=0; i< orders.count; i++) {
                                    [paths addObject:[NSIndexPath indexPathForRow:allLogs.count+i inSection:0]];
                                }
                                [allLogs insertObjects:orders atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(allLogs.count, orders.count)]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    tableView0.tableFooterView.hidden = YES;
                                    [tableView0 beginUpdates];
                                    [tableView0 insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
                                    [tableView0 endUpdates];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                    
                                });
                                
                            }
                        }
                        
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        tableView0.tableFooterView.hidden = YES;
                        [[LoadingView showLoadingView] actViewStopAnimation];
                        [tableView0 reloadData];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    tableView0.tableFooterView.hidden = YES;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if (timeOutCount < 2) {
                [self requestToGetRewardList];
            }else{
                tableView0.tableFooterView.hidden = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
                timeOutCount = 0;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [UIAlertView resetNetAlertNil];
        [[LoadingView showLoadingView] actViewStopAnimation];
        [self requestToGetRewardList];
    }
}

-(void)showTipView{
    ViewTip *tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    [tip setViewTipByImage:[UIImage imageNamed:@"a3.png"]];
    [tip setViewTipByStringOne:@"您还没有兑换任何奖品"];
    [tableView0 addSubview:tip];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RewardListCell *cell = (RewardListCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
    float height = [cell getCellHeight];
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allLogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = @"RewardListCell";
    RewardListCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        //<<<<<<< .mine
        //        NSLog(@"Cell");
        //        cell = [[RewardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        //=======
        
        cell = [[RewardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }else{
        while ([cell.contentView.subviews lastObject] !=nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        //>>>>>>> .r3566
    }
    cell.goods = [[RewardGoods alloc]initRewardGoodsByDic:[allLogs objectAtIndex:indexPath.row]];
    [cell initCellContent];
    for (UIView *currentView in cell.subviews)
    {
        if([currentView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float y_float = tableView0.contentOffset.y;
    if (y_float < 0)
        return;
    
    if (allLogs.count != 0 && curPage != maxPage) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        float reload_distance = 2 * kTableLoadingViewHeight2_0;
        if(y > h + reload_distance) {
            tableView0.tableFooterView.hidden = NO;
            [self requestToGetRewardList];
        }else{
            tableView0.tableFooterView.hidden = YES;
        }
    }else{
        tableView0.tableFooterView.hidden =YES;
    }
}
-(void)onClickBackBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

