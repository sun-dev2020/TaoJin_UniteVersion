//
//  MessageViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "MessageViewController.h"
#import "LoadingView.h"
#import "MScrollVIew.h"
#import "SysMessage.h"
#import "ViewTip.h"
#import "StatusBar.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "MessageFrame.h"
#import "TJViewController.h"
#import "CButton.h"
#import "CommentViewController.h"
#import "TaoJinScrollView.h"
#import "QuestTable.h"
#import "UIImage+ColorChangeTo.h"
#import "TablePullToLoadingView.h"

@interface MessageViewController (){
    UITableView* tableView0;
    
    UIView* footView;
    
    UILabel *footLabel;
    
    ViewTip *tip;
    //    HeadView *headView;
    
    NSMutableArray *allLogs;                                                    //存放消息中心数据
    
    BOOL isFristToGetMessage;                                                   //表示是否第一次请求获取消息中心
    
    int timeOutCount;                                                           //连接超时次数
    
    int index;
    int page;
    int maxPage;
    int curPage;
    HeadToolBar *headBar;
    int deleteMsgID;
    
    
    QuestTable *questView;
    
    TaoJinScrollView *tjScrollView;
}
@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//初始化变量
-(void)initWithObjects{
    page = 1;
    maxPage = 0;
    curPage = 0;
    allLogs =[[NSMutableArray alloc] init];
    timeOutCount = 0;
    isFristToGetMessage = YES;
    [[MyUserDefault standardUserDefaults] setUserAskStr:nil];  // 进入界面后 本地数据清掉
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWithObjects];
    
    [[MyUserDefault standardUserDefaults] setUserMsgNum:0];
    
    
    headBar = [[HeadToolBar alloc] initWithTitle:@"消息中心" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:nil backgroundColor:KOrangeColor2_0];
    
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    [self initQuestViewContent];
    
    [self initAskViewContent];
    [self initScrollView];
    [self performSelector:@selector(requestToGetMyMessage) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (IOS_Version >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate =self;
    }
    
    if ([[MyUserDefault standardUserDefaults] getuserAskStr]) {
        NSDictionary *dic =[[MyUserDefault standardUserDefaults] getuserAskStr];
        
        if (allLogs.count ==0) {
            [allLogs addObject:dic];
            [tableView0 reloadData];
            if (tip) {
                [tip removeFromSuperview];
            }
        }else{
            [allLogs insertObject:dic atIndex:0];
            NSIndexPath *indexpath =[NSIndexPath indexPathForRow:1 inSection:0];
            [tableView0 insertRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
            if (allLogs.count >1) {
                [tableView0 reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
//    [headView removeFromSuperview];
//    headView = nil;


//    [tableView0 removeFromSuperview];
//    tableView0 = nil;
//    [footView removeFromSuperview];
//    footView = nil;
    //    [allLogs removeAllObjects];
    //    allLogs = nil;
    //    tip = nil;
//    
//    if (IOS_Version >= 7.0) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[LoadingView showLoadingView] actViewStopAnimation];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


//请求获取我的消息中心
-(void)requestToGetMyMessage{
    if(isFristToGetMessage){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFristToGetMessage = false;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":[NSNumber numberWithInt:page], @"Type":@"all"};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetMyMsg"];
    NSLog(@"请求获取我的消息中心【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"请求获取我的消息中心【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    curPage = [[body objectForKey:@"CurPage"] intValue];
                    maxPage = [[body objectForKey:@"MaxPage"] intValue];
                    NSArray *msg = [body objectForKey:@"Msg"];
                    if([msg isKindOfClass:[NSNull class]]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tableView0.tableFooterView.hidden = YES;
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [self showTipView];
                        });
                    }else{
                        if(curPage == page){
                            page ++;
                            if(allLogs == nil){
                                allLogs = [[NSMutableArray alloc] initWithArray:msg];
                            }else{
                                [allLogs insertObjects:msg atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(allLogs.count, msg.count)]];
                            }
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tableView0.tableFooterView.hidden = YES;
                            [tableView0 reloadData];
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        });
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        tableView0.tableFooterView.hidden = YES;
                        [[LoadingView showLoadingView] actViewStopAnimation];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                tableView0.tableFooterView.hidden = YES;
                [[LoadingView showLoadingView] actViewStopAnimation];
            });
            
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                [self requestToGetMyMessage];
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
        [[LoadingView showLoadingView] actViewStartAnimation];
        [self requestToGetMyMessage];
    }
}

-(void)showTipView{
    tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    [tip setViewTipByImage:[UIImage imageNamed:@"a3.png"]];
    [tip setViewTipByContent:@"提点宝贵的意见\n让我们送更多的钱"];
    [tableView0 insertSubview:tip atIndex:0];
    
}
-(void)initQuestViewContent{
    questView =[[QuestTable alloc] initWithFrame:CGRectMake(0,0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y ) style:UITableViewStylePlain];
    questView.backgroundView = nil;
    questView.backgroundColor = [UIColor clearColor];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [questView setContentSize:CGSizeMake(320, webView.frame.size.height)];
}

-(void)initScrollView{
    
    NSArray *arrayView =[[NSArray alloc] initWithObjects:tableView0,questView, nil];
    NSArray *array =[[NSArray alloc] initWithObjects:@"我要提问",@"常见问题" ,nil];
    tjScrollView =[[TaoJinScrollView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y  +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y) btnAry:array btnAction:^(UIButton *button) {
        if (button.tag ==1) {
            
        }
        else{
            if (questView.isFirst) {
                [questView requestCommonQuest];
            }
            
        }
    } slidColor:KOrangeColor2_0 viewAry:arrayView];
    tjScrollView.scrollView.delaysContentTouches =NO;
    tableView0.frame =CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -[tjScrollView getButtonRowHeight]);
    if (IOS_Version < 7.0) {
        tableView0.frame  =CGRectMake(0, 0, kmainScreenWidth, tableView0.frame.size.height -20);
    }
    questView.frame =CGRectMake(320.0f, 0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height -[tjScrollView getButtonRowHeight]);
    if (IOS_Version < 7.0) {
        questView.frame =CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, questView.frame.size.height -20);
    }
    [self.view addSubview:tjScrollView];
    
}
-(void)initAskViewContent{
    
    if (tableView0) {
        [tableView0 removeFromSuperview];
        tableView0 = nil;
    }
    tableView0 = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kmainScreenWidth, kmainScreenHeigh -headBar.frame.size.height -headBar.frame.origin.y ) style:UITableViewStylePlain];
    
    tableView0.delegate = self;
    tableView0.dataSource = self;
    tableView0.delaysContentTouches =NO;
    tableView0.backgroundView = nil;
    tableView0.backgroundColor = [UIColor clearColor];
    [tableView0 setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] init];
    tableView0.tableFooterView = loadingView;
    tableView0.tableFooterView.hidden = YES;
}

-(void)onClickAskBtn{      //点击提问
    CommentViewController *cvc =[[CommentViewController alloc] initWithNibName:nil bundle:nil];
    cvc.commentType =CommentTypeAsk;
    [self.navigationController presentViewController:cvc animated:YES completion:^{
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allLogs.count +1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *string = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.tag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row ==0) {
        [cell initAskBtn];
    }else{
        if (allLogs.count != 0 ) {
            cell.msg = [[SysMessage alloc]initSysMessageByDic:[allLogs objectAtIndex:indexPath.row -1]];
            if (indexPath.row -2 >=0) {         //判断消息是否是同一天
                SysMessage *lastMsg =[[SysMessage alloc] initSysMessageByDic:[allLogs objectAtIndex:indexPath.row -2]];
                if ([lastMsg.msgTime isEqualToString:cell.msg.msgTime]) {
                    cell.isOneDay =YES;
                }
            }
            [cell initMessageCellContentWith:cell.msg];
            
        }
    }
    cell.mcDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

//获取长按手势
-(void)getLongPressGestureRecognizer:(int )msgid andCellTag:(int) tag{
    index =tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"删除" , nil];
    deleteMsgID =msgid;
    if (IOS_Version < 7.0) {
        TJViewController *tj = [[TJViewController alloc] init];
        [actionSheet showFromTabBar:tj.tabBar];
    }else{
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        [self onClickDeleteBtn:deleteMsgID ];
    }
}

//点击删除按钮
-(void)onClickDeleteBtn:(int )msgid {
    
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"Mid":[NSNumber numberWithInt:msgid], @"Type":@"del"};
    [self requestToDeleteMyMessage:dic];
}

//请求删除我的信息
-(void)requestToDeleteMyMessage:(NSDictionary *)dic{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetMyMsg"];
    NSLog(@"请求删除我的信息【urlStr】 = %@",dic);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求删除我的信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if(body != nil){
                    NSString *type = [body objectForKey:@"Type"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(type != nil && [@"del" isEqualToString:type]){
                            [[LoadingView showLoadingView] actViewStopAnimation];
                            [allLogs removeObjectAtIndex:index -1];
                            [tableView0 deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [tableView0 reloadData];
                            [StatusBar showTipMessageWithStatus:@"消息删除成功" andImage:[UIImage imageNamed:@"icon_yes.png"]andTipIsBottom:YES];
                            if (allLogs.count ==0) {
                                [self showTipView];
                            }
                        }else{
                            [[LoadingView showLoadingView] actViewStopAnimation];
                        }
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[LoadingView showLoadingView] actViewStopAnimation];
                    });
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView showLoadingView] actViewStopAnimation];
            });
            
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                [self requestToGetMyMessage];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 50.0;
    }else{
        MessageCell *cell = (MessageCell* )[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell getMessageCellHeight] ;
    }
}

-(void)onClickBackBtn:(UIButton*)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
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
        //        float reload_distance = 2 * kTableLoadingViewHeight2_0;
        if(y > h - 1) {
            tableView0.tableFooterView.hidden = NO;
            [self requestToGetMyMessage];
        }else{
            tableView0.tableFooterView.hidden = YES;
        }
    }else{
        tableView0.tableFooterView.hidden =YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end









