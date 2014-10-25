//
//  OutTable.m
//  TJiphone
//
//  Created by keyrun on 13-10-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "OutTable.h"
#import "IncomeCell.h"
#import "LoadingView.h"
#import "ViewTip.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "TablePullToLoadingView.h"

@implementation OutTable{
    
    UIView* footView;
    UILabel* footLabel;
    
    int page;
    int curPage;
    int maxPage;
    int timeOutCount;                                                           //连接超时次数
    
    BOOL isFrist;                                                               //标识是否第一次访问
    
    NSMutableArray* _allLogs;
}
@synthesize allLogs =_allLogs;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        
        [self setSeparatorColor:[UIColor clearColor]];
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] init];
        self.tableFooterView = loadingView;
        self.tableFooterView.hidden = YES;
        
        
        
    }
    return self;
}
-(void) initObjects{
    page = 1;
    maxPage = 0;
    curPage = 0;
    timeOutCount = 0;
    isFrist = YES;

    [self requestToGetUserOutCome];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allLogs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IncomeCell* cell = (IncomeCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell getIncomeCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *IDENTIFIER = @"OutcomeCell";
    IncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        cell = [[IncomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDENTIFIER];
    }
    cell.backgroundColor = [UIColor clearColor];
    if (_allLogs.count != 0) {
        cell.userlog = [[UserLog alloc]initWithDictionary:[_allLogs objectAtIndex:indexPath.row]];
    }
    [cell initIncomeCell];
    return cell;
}

//请求获取用户【支出】
-(void)requestToGetUserOutCome{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":[NSNumber numberWithInt:page], @"Type":@"2"};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetUserLog"];
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
                            [self showTip];
                            self.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        });
                    }else{
                        NSArray *userLog = [body objectForKey:@"UserLog"];
                        if(userLog != nil && userLog.count > 0 && curPage == page){
                            page ++;
                            if(_allLogs == nil){
                                _allLogs = [[NSMutableArray alloc] initWithArray:userLog];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [self reloadData];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                });
                            }else{
                                NSMutableArray *paths =[[NSMutableArray alloc] init];
                                for (int i=0; i <userLog.count; i++) {
                                    [paths addObject:[NSIndexPath indexPathForRow:_allLogs.count +i inSection:0]];
                                }
                                [_allLogs insertObjects:userLog atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allLogs.count, userLog.count)]];

                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.tableFooterView.hidden = YES;
                                    [self beginUpdates];
                                    [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationNone];
                                    [self endUpdates];
                                    [[LoadingView showLoadingView] actViewStopAnimation];
                                });
                            }
                            
                        }
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [self reloadData];
                        self.tableFooterView.hidden = YES;
                        [[LoadingView showLoadingView] actViewStopAnimation];
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self reloadData];
                    self.tableFooterView.hidden = YES;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToGetUserOutCome];
            }else{
                self.tableFooterView.hidden = YES;
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
        [[LoadingView showLoadingView] actViewStartAnimation];
        [self requestToGetUserOutCome];
    }
}

-(void)showTip{
    ViewTip* tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    [tip setViewTipByImage:[UIImage imageNamed:@"a3.png"]];
    [tip setViewTipByContent:@"人民币都贬值了\n你还在等什么"];
    [self addSubview:tip];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float y_float = self.contentOffset.y;
    if (y_float < 0)
        return;
    
    if (_allLogs.count != 0 && curPage != maxPage) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
//        float reload_distance = 2 * kTableLoadingViewHeight2_0;
        if(y > h - 1) {
            self.tableFooterView.hidden = NO;
            [self requestToGetUserOutCome];
        }else{
            self.tableFooterView.hidden = YES;
        }
    }else{
        self.tableFooterView.hidden =YES;
    }
}

@end

