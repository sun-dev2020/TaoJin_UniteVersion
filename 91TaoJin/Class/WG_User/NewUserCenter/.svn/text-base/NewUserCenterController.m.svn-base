//
//  NewUserCenterController.m
//  91TaoJin
//
//  Created by keyrun on 14-5-24.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "NewUserCenterController.h"
#import "HeadToolBar.h"

#import "LoadingView.h"
#import "AsynURLConnection.h"
#import "MyUserDefault.h"
#import "User.h"
#import "NewUserTableCell.h"
#import "NSString+IsEmply.h"
#import "SDImageView+SDWebCache.h"
#import "SettingViewController.h"
#import "IncomeViewController.h"
#import "RewardListViewController.h"
#import "MessageViewController.h"
#import "VisitViewController.h"
#import "InforViewController.h"

#import "UploadViewController.h"
#define kHeadHeight 100.0
@interface NewUserCenterController ()
{
    MScrollVIew *ms;
    HeadToolBar *headBar;
    User *user;
    int inviteCount;                                                                //
    int needReloadCell;
    
    BOOL isFrist;                                                                   //判断是不是第一次请求用户信息
    NSMutableArray *cellArray;
    NSMutableArray *titles;
    NSMutableArray *arrImage;
    
    UITableView *userTabel;
    int logBetween;
    
    int isNeedReload;
    UIView *bgView;
    

    SettingViewController *setting;
    UINavigationController *nc;
}
@end

@implementation NewUserCenterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushRewardList) name:@"PushRewardList" object:nil];
    }
    return self;
}
//初始化变量
-(void)initWithObjects{
    inviteCount = 0;
    needReloadCell = 0;
    isFrist = YES;
    cellArray =[[NSMutableArray alloc]init];
    
    arrImage = [NSMutableArray arrayWithObjects:GetImage(@"icon_Income.png"),GetImage(@"icon_Reward.png"),GetImage(@"icon_Message.png"),GetImage(@"icon_Visit.png"),nil];
    titles = [NSMutableArray arrayWithObjects:kIncomeName,kRewardName ,kMsgName ,kVisitName, nil];
    
    [self requestToGetUserInfor];

    nc =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
   
}
-(void)viewWillAppear:(BOOL)animated{
    [self initCellData];
    
}
-(void)initCellData{
    NewUserTableCell *cell =(NewUserTableCell *)[userTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:isNeedReload inSection:0]];
    switch (isNeedReload) {
            
        case 1:
            [cell showCellCoinDetails:nil withIncomeType:1];
            break;
        case 4:{      //visit cell
            
            [cell showCellCoinDetails:nil withIncomeType:1];
            cell.hotImage.alpha =1;
        }
            break;
        case 3:
            [cell showCellMessageTip:0];
            break;
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offY = scrollView.contentOffset.y;
    if (offY <=0) {
        if (IOS_Version >=7.0) {
            bgView.frame =CGRectMake(0, scrollView.frame.origin.y, scrollView.frame.size.width, offY *-1);
        }
        else{
            bgView.frame =CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, scrollView.frame.size.width, -1 *offY);
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    if ([[MyUserDefault standardUserDefaults] getUserPic]) {
        NewUserTableCell * headCell =(NewUserTableCell *)[userTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UIImage *image =[UIImage imageWithData:[[MyUserDefault standardUserDefaults]getUserPic]];
        headCell.userIcon.image =image;
        user.userIcon =@"test";
    }
    if (![[[MyUserDefault standardUserDefaults] getUserNickname] isEqualToString:@""]) {
        NewUserTableCell * headCell =(NewUserTableCell *)[userTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *name =[[MyUserDefault standardUserDefaults] getUserNickname];
        headCell.erinnernLab.text =name;
        headCell.erinnernLab.textColor =KBlockColor2_0;
        user.userName =name;

    }
}

-(void)onClickSettingBtn{
    setting =[[SettingViewController alloc] initWithNibName:nil bundle:nil];
    [nc pushViewController:setting animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.isRequesting = NO;
    [self initWithObjects];
    
    
    headBar =[[HeadToolBar alloc] initWithTitle:KLfour leftBtnTitle:nil leftBtnImg:nil leftBtnHighlightedImg:nil rightBtnTitle:@"设置" rightBtnImg:GetImage(@"icon_setting.png") rightBtnHighlightedImg:GetImage(@"setting_sel.png") backgroundColor:KOrangeColor2_0];
    headBar.rightBtn.tag =1;
    [headBar.rightBtn addTarget:self action:@selector(onClickSettingBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    if (IOS_Version >= 7.0) {
        ms = [[MScrollVIew alloc]initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height - kfootViewHeigh + 20) andWithPageCount:1 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0,headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height - kfootViewHeigh) andWithPageCount:1 backgroundImg:nil];
    }
    
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    ms.msDelegate =self;
    ms.bounces =YES;
    [self.view addSubview:ms];
    [self.view addSubview:headBar];
    
    [self setViewContent];
    
}

-(void)setViewContent{
    
    bgView =[[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor =KLightGrayColor2_0;
    
    
    userTabel =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, ms.frame.size.height)];
    userTabel.delegate =self;
    userTabel.dataSource =self;
    userTabel.backgroundView =nil;
    userTabel.backgroundColor =[UIColor clearColor];
    userTabel.separatorStyle =UITableViewCellSeparatorStyleNone;
    [ms addSubview:userTabel];
    [self.view insertSubview:bgView belowSubview:ms];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([[[MyUserDefault standardUserDefaults] getIsNeedActivityView] intValue] == 1){
        //显示【邀请奖励】
        return titles.count + 1;
    }else{
        //不显示【邀请奖励】
        return titles.count + 1 - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId =@"userTableCell";
    NewUserTableCell *cell =[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell =[[NewUserTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0) {
        [cell initUserCenterHeadCell];
        
    }else{
        [cell setCellViewByType:1 andWithImage:[arrImage objectAtIndex:indexPath.row -1] andCellTitle:[titles objectAtIndex:indexPath.row-1]];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return  kHeadHeight;
    }else{
        return kCellHeight;
    }
}
//请求获取我的中心的信息
-(void)requestToGetUserInfor{
    _isRequesting = YES;
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"Id":@"0"};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetUserInfo"];
    NSLog(@"请求获取我的中心的信息【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            NSLog(@"请求获取我的中心的信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                if ([body objectForKey:@"GetStarsForAppstore"]) {
                    NSString *adress =[body objectForKey:@"GetStarsForAppstore"];
                    [[MyUserDefault standardUserDefaults] setAppStoreAdress:adress];
                }
                user = [[User alloc] initWithDictionary:body];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:user.userBean];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    NewUserTableCell *headCell =(NewUserTableCell *)[userTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    headCell.hotImage.hidden =YES;
                    if([NSString isEmply:user.userName]){
                        
                        headCell.erinnernLab.hidden = NO;
                        
                        headCell.erinnernLab.text = [NSString stringWithFormat:@"完善用户信息奖金豆"];
                        
                    }else{
                        headCell.erinnernLab.text =user.userName;
                        headCell.erinnernLab.textColor =KBlockColor2_0;
                    }
                    NSData *userPicData = [[MyUserDefault standardUserDefaults] getUserPic];
                    //判断本地有无该用户的头像图片,若无需要请求服务器进行获取
                    if(userPicData != nil){
                        UIImage *userPicImg = [UIImage imageWithData:userPicData];
                        headCell.userIcon.image = userPicImg;
                    }else{
                        [headCell.userIcon setImageWithURL:[NSURL URLWithString:user.userIcon] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
                    }

                    if (![NSString isEmply:user.userIcon]) {
                        [[MyUserDefault standardUserDefaults] setUserIconUrlStr:user.userIcon];
                    }
                    headCell.userJdsLab.text = [NSString stringWithFormat:@"%d",user.userBean];
                    int log =0;
                    NewUserTableCell *incomeCell =(NewUserTableCell *)[userTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    if (![[MyUserDefault standardUserDefaults]getUserLog]) {
                        logBetween =user.userBean;
                        NSNumber* jdnum =[NSNumber numberWithInt:user.userBean];
                        [incomeCell showCellCoinDetails:jdnum withIncomeType:2];
                    }else{
                        log = [[[MyUserDefault standardUserDefaults]getUserLog] integerValue];
                        
                        logBetween =user.userLog -log;
                        NSNumber* numBetween =[NSNumber numberWithInt:logBetween];
                        if (logBetween > 0) {
                            
                            [incomeCell showCellCoinDetails:numBetween withIncomeType:2];
                        }else if (logBetween < 0){
                            
                            [incomeCell showCellCoinDetails:numBetween withIncomeType:1];
                        }else{
                            [incomeCell showCellCoinDetails:nil withIncomeType:1];
                        }
                    }
                    
                    NewUserTableCell *inviteCell =(NewUserTableCell *)[userTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
                    if ([[[MyUserDefault standardUserDefaults]getUserInviteCount] isKindOfClass:[NSNull class]]) {
                        
                        if ([[body objectForKey:@"Invite"]integerValue]!=0) {
                            int count =[[body objectForKey:@"Invite"]integerValue];
                            NSNumber* num =[NSNumber numberWithInt:count];
                            inviteCount =count;
                            inviteCell.hotImage.alpha=0;
                            if (count >0) {
                                [inviteCell showCellCoinDetails:num withIncomeType:2];
                            }
                            else if (count < 0){
                                //                [cell showCellCoinDetails:nil withIncomeType:1];
                            }
                        }
                        else{
                            inviteCell.hotImage.alpha=1;
                        }
                    }
                    else{
                        if ([[body objectForKey:@"Invite"]integerValue]!=0) {
                            int count =[[body objectForKey:@"Invite"]integerValue];
                            int oldnum =[[[MyUserDefault standardUserDefaults]getUserInviteCount] integerValue];
                            inviteCount = count;
                            int newnum =count -oldnum;
                            inviteCell.hotImage.alpha=0;
                            NSNumber* num =[NSNumber numberWithInt:newnum];
                            if (newnum >0) {
                                [inviteCell showCellCoinDetails:num withIncomeType:2];
                                
                            }
                            else if (newnum < 0){
                                [inviteCell showCellCoinDetails:nil withIncomeType:1];
                            }else if (newnum ==0){
                                
                                inviteCell.hotImage.alpha=1;
                                [inviteCell showCellCoinDetails:nil withIncomeType:1];
                            }
                        }
                        else{
                            inviteCell.hotImage.alpha=1;
                        }
                    }
                    
                    NewUserTableCell *msgCell =(NewUserTableCell *)[userTabel cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    if ([[body objectForKey:@"MsgNum"]integerValue]!=0) {
                        int count =[[body objectForKey:@"MsgNum"]integerValue];
                        //                        NSNumber* number =[NSNumber numberWithInt:count];
                        [[MyUserDefault standardUserDefaults]setUserMsgNum:count];
                        [msgCell showCellMessageTip:count];
                        
                    }
                    else {
                        [msgCell showCellMessageTip:0];
                    }
                    _isRequesting = NO;
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _isRequesting = NO;
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            //连接超时
            [self requestToGetUserInfor];
        }
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
//    UINavigationController *nc =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    isNeedReload =indexPath.row;
    switch (indexPath.row) {
            
        case 0:
        {
            InforViewController *infor =[[InforViewController alloc] initWithNibName:nil bundle:nil];
            infor.user =user;
            [nc pushViewController:infor animated:YES];
            
        }
            break;
            
        case 1:
        {
            IncomeViewController *income =[[IncomeViewController alloc] initWithNibName:nil bundle:nil];
            income.userLog = user.userLog;
            [nc pushViewController:income animated:YES];
        }
            break;
        case 2:
        {
            RewardListViewController *reward =[[RewardListViewController alloc] initWithNibName:nil bundle:nil];
            [nc pushViewController:reward animated:YES];
        }
            break;
        case 3:
        {
            MessageViewController *msg =[[MessageViewController alloc] initWithNibName:nil bundle:nil];
            [nc pushViewController:msg animated:YES];
        }
            break;
        case 4:
        {
            VisitViewController *visit= [[VisitViewController alloc] initWithNibName:nil bundle:nil];
            visit.inviteCount = inviteCount;
            visit.player =user;
            [nc pushViewController:visit animated:YES];
            
        }
            break;
        default:
            break;
    }
}

-(void)getPushRewardList{   // 接受到push 通知
    UINavigationController *ncPush =(UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    RewardListViewController *reward =[[RewardListViewController alloc] initWithNibName:nil bundle:nil];
    [ncPush pushViewController:reward animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
