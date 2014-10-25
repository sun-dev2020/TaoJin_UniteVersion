//
//  ActivityCenterViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-5-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ActivityCenterViewController.h"
#import "HeadToolBar.h"
#import "TaoJinScrollView.h"
#import "UIImage+ColorChangeTo.h"
#import "ButtonRowView.h"
#import "TakePartCell.h"
#import "TakePart.h"
#import "ScratchViewController.h"
#import "ShakeViewController.h"
#import "GuessViewController.h"
#import "VisitViewController.h"
#import "ShowPostsTableView.h"
#import "MyUserDefault.h"
#import "ViewTip.h"
#import "TakePartDetailViewController.h"
#import "ShowPostsDetailViewController.h"
#import "CommentViewController.h"
#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "LuckyLotteryViewController.h"
@interface ActivityCenterViewController (){
    TaoJinScrollView *_scrollView;
    
    UIView *takePartView;                                           //【天天参与】视图
    
    __block HeadToolBar *headView;
}

@end

@implementation ActivityCenterViewController

@synthesize takePartTableView = _takePartTableView;
@synthesize showPostsTableView = _showPostsTableView;
@synthesize shareTableView = _shareTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushLottery) name:@"PushLottery" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushHuoDong:) name:@"PushHuoDong" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPushShow:) name:@"PushShow" object:nil];
    }
    return self;
}
-(void)getPushHuoDong:(NSNotification* )notic{   //活动详情跳转
    
    UINavigationController *nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    TakePartDetailViewController *tpDetails = [[TakePartDetailViewController alloc] initWithNibName:nil bundle:nil];
    tpDetails.isPush =YES;
    NSString *tpId =[notic.userInfo objectForKey:@"hd"];
    [tpDetails requestToGetTakePartDetail:tpId];
    [nc pushViewController:tpDetails animated:YES];

}
-(void)getPushShow:(NSNotification *)notic{     // 晒单详情跳转
    UINavigationController *nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    ShowPostsDetailViewController *showDetail =[[ShowPostsDetailViewController alloc] initWithNibName:nil bundle:nil];
    showDetail.isPush =YES;
    int showID =[[notic.userInfo objectForKey:@"sd"] intValue];
    [showDetail requestToGetShowPostsDetail:showID];
    [nc pushViewController:showDetail animated:YES];
}
-(void)getPushLottery{   // 接受到push 通知后跳转
    UINavigationController *nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    GuessViewController *guess = [[GuessViewController alloc] init];
    [nc pushViewController:guess animated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
//    HeadToolBar *headView = [[HeadToolBar alloc] initWithTitle:KLtwo backgroundColor:KOrangeColor2_0];
    headView = [[HeadToolBar alloc] initWithTitle:KLtwo leftBtnTitle:nil leftBtnImg:nil leftBtnHighlightedImg:nil rightBtnTitle:@"晒单广场" rightBtnImg:nil rightBtnHighlightedImg:nil backgroundColor:KOrangeColor2_0];
    int currentId = [[[MyUserDefault standardUserDefaults] getShowPostsType] intValue];
    if(currentId == 0){
        [headView.rightBtn setTitle:@"晒单广场" forState:UIControlStateNormal];
    }else{
        [headView.rightBtn setTitle:@"我的晒单" forState:UIControlStateNormal];
    }
    headView.rightBtn.hidden = YES;
    [headView.rightBtn addTarget:self action:@selector(changeShowPostType:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headView];
    
    _currentType = 1;
    //【天天参与】界面
    NSArray *imgAry = @[@"icon_lottery",@"icon_jingcai",@"icon_guagua",@"icon_jiangli"];
    NSArray *titleAry = @[@"幸运抽奖",@"乐透竞猜",@"刮刮乐",@"邀请奖励"];
    NSArray *colorAry = @[KRedColor2_0, KOrangeColor2_0, KPurpleColor2_0, kBlueColor2_0];
    ButtonRowView *buttonRowView;
    if([[[MyUserDefault standardUserDefaults] getIsNeedActivityView] intValue] == 1){
        buttonRowView = [[ButtonRowView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 0.0f) imgAry:imgAry titleAry:titleAry colorAry:colorAry btnAction:^(UIButton *button) {
            [self onClickButtonRowAction:button];
        }];
    }
    float tableY = buttonRowView.frame.origin.y + buttonRowView.frame.size.height;
    
    if(takePartView == nil)
        takePartView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kmainScreenHeigh - headView.frame.origin.y - headView.frame.size.height - kfootViewHeigh)];
    
    [takePartView addSubview:buttonRowView];
    //【天天参与】界面
    _takePartTableView = [[TakePartTableView alloc] initWithFrame:CGRectMake(0.0f, tableY, kmainScreenWidth, takePartView.frame.size.height - tableY - (kBatterHeight))];
    [takePartView addSubview:_takePartTableView];
    
    //【晒单有奖】界面
    _showPostsTableView = [[ShowPostsTableView alloc] initWithFrame:CGRectMake(320.0f, 0.0f, kmainScreenWidth, kmainScreenHeigh - headView.frame.origin.y - headView.frame.size.height - kfootViewHeigh )];
    
    //【分享有奖】界面
    _shareTableView =[[ShareTableView alloc] initWithFrame:CGRectMake(640.0f, 0.0f, kmainScreenWidth,  kmainScreenHeigh - headView.frame.origin.y - headView.frame.size.height - kfootViewHeigh )];
    
    NSArray *viewAry = @[takePartView,_showPostsTableView,_shareTableView];
    _scrollView = [[TaoJinScrollView alloc] initWithFrame:CGRectMake(0.0f, headView.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headView.frame.size.height - kfootViewHeigh) btnAry:@[@"天天参与",@"晒单有奖",@"分享有奖"] btnAction:^(UIButton *button) {
        switch (button.tag) {
            case 1:
                _currentType = 1;
                if(_takePartTableView.takePartAry == nil || _takePartTableView.takePartAry.count == 0){
                    [_takePartTableView initObjects];
                }
                headView.rightBtn.hidden = YES;
                break;
            case 2:
                _currentType = 2;
                if(_showPostsTableView.showPosts == nil && _showPostsTableView.myShowPosts == nil){
                    [_showPostsTableView initObjects];
                }
                if ([[[MyUserDefault standardUserDefaults] getIsNeedDutyView] intValue] ==1) {
                    
                if ([[[MyUserDefault standardUserDefaults] getShaiDanCenterDutyShow] intValue] !=1) {
                    [[MyUserDefault standardUserDefaults] setShaiDanCenterDutyShow:[NSNumber numberWithInt:1]];
                    [self showDutyView];
                }
                    
                }
                int currentId = [[[MyUserDefault standardUserDefaults] getShowPostsType] intValue];
                if(currentId == 0){
                    [headView.rightBtn setTitle:@"我的晒单" forState:UIControlStateNormal];
                }else{
                    [headView.rightBtn setTitle:@"晒单广场" forState:UIControlStateNormal];
                    
                }
                headView.rightBtn.hidden = NO;
                break;
            case 3:
                _currentType = 3;
                if(_shareTableView.allShares == nil || _shareTableView.allShares.count == 0){
                    //                    [_shareTableView sendRequestForShare];
                    [_shareTableView initObjects];
                }
                if ([[[MyUserDefault standardUserDefaults] getIsNeedDutyView] intValue] ==1) {
                if ([[[MyUserDefault standardUserDefaults] getShareCenterDutyShow]intValue] !=1) {
                    [[MyUserDefault standardUserDefaults] setShareCenterDutyShow:[NSNumber numberWithInt:1]];
                    [self showDutyView];
                }
                }
                headView.rightBtn.hidden = YES;
                [_shareTableView sendRequestForShare];
                break;
            default:
                break;
        }
        
    } slidColor:KOrangeColor2_0 viewAry:viewAry headView:headView];
    /*  2.0.0版本
    _scrollView = [[TaoJinScrollView alloc] initWithFrame:CGRectMake(0.0f, headView.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headView.frame.size.height - kfootViewHeigh) btnAry:@[@"天天参与",@"晒单有奖",@"分享有奖"] btnAction:^(UIButton *button) {
        switch (button.tag) {
            case 1:
                _currentType = 1;
                if(_takePartTableView.takePartAry == nil || _takePartTableView.takePartAry.count == 0){
                    [_takePartTableView initObjects];
                }
                break;
            case 2:
                _currentType = 2;
                if(_showPostsTableView.showPosts == nil && _showPostsTableView.myShowPosts == nil){
                    [_showPostsTableView initObjects];
                }
                if ([[[MyUserDefault standardUserDefaults] getShaiDanCenterDutyShow]intValue] !=1) {
                    
                    [[MyUserDefault standardUserDefaults] setShaiDanCenterDutyShow:[NSNumber numberWithInt:1]];
                    [self showDutyView];
                }
                break;
            case 3:
                _currentType = 3;
                if(_shareTableView.allShares == nil || _shareTableView.allShares.count == 0){
//                    [_shareTableView sendRequestForShare];
                    [_shareTableView initObjects];
                }
                if ([[[MyUserDefault standardUserDefaults] getShareCenterDutyShow]intValue] !=1) {

                    [[MyUserDefault standardUserDefaults] setShareCenterDutyShow:[NSNumber numberWithInt:1]];
                    [self showDutyView];
                }
                [_shareTableView sendRequestForShare];
                break;
            default:
                break;
        }
        
    } slidColor:KOrangeColor2_0 viewAry:viewAry];
     */
    _takePartTableView.frame = CGRectMake(_takePartTableView.frame.origin.x, _takePartTableView.frame.origin.y, _takePartTableView.frame.size.width, _takePartTableView.frame.size.height - _scrollView.getButtonRowHeight);
    _showPostsTableView.frame = CGRectMake(_showPostsTableView.frame.origin.x, _showPostsTableView.frame.origin.y, _showPostsTableView.frame.size.width, kmainScreenHeigh - [_scrollView getButtonRowHeight]- kfootViewHeigh - headView.frame.origin.y - headView.frame.size.height - (kBatterHeight));
    _shareTableView.frame =CGRectMake(640.0f, 0.0f, kmainScreenWidth, kmainScreenHeigh - [_scrollView getButtonRowHeight] - kfootViewHeigh - headView.frame.origin.y -headView.frame.size.height - (kBatterHeight));
    
    _scrollView.scrollView.delaysContentTouches = NO;
    [self.view addSubview:_scrollView];
}

/**
 *  【晒单广场】和【我的晒单】之间的切换
 *
 */
-(void)changeShowPostType:(id)sender{
    int currentId = [[[MyUserDefault standardUserDefaults] getShowPostsType] intValue];
    if(currentId == 0){
        //请求【晒单广场】
        currentId = [[[MyUserDefault standardUserDefaults] getUserId] intValue];
    }else{
        //请求【我的晒单】
        currentId = 0;
    }
    [[LoadingView showLoadingView] actViewStartAnimation];
    [_showPostsTableView changeShowPostType:currentId];
    _showPostsTableView.block = ^(){
        [[LoadingView showLoadingView] actViewStopAnimation];
        if(currentId == 0){
            [headView.rightBtn setTitle:@"我的晒单" forState:UIControlStateNormal];
        }else{
            [headView.rightBtn setTitle:@"晒单广场"    forState:UIControlStateNormal];
            
        }
    };
}

-(void)cleanCache{
    [[MyUserDefault standardUserDefaults] setIsHavePullMyPosts:[NSNumber numberWithBool:NO]];
    [[MyUserDefault standardUserDefaults] setIsHavePullShowPosts:[NSNumber numberWithBool:NO]];
    if(_showPostsTableView.showPostsHeadView != nil){
        [_showPostsTableView.showPostsHeadView removeFromSuperview];
        [_showPostsTableView refrushView];
        [_showPostsTableView reloadData];
    }
}

-(void)onClickButtonRowAction:(UIButton* )btn{
    UINavigationController *nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    switch (btn.tag) {
            //摇一摇抽奖
        case 1:
        {
//            ShakeViewController *shake = [[ShakeViewController alloc] init];
            LuckyLotteryViewController *lucky =[[LuckyLotteryViewController alloc] init];
            [nc pushViewController:lucky animated:YES];
        }
            break;
            //乐透竞猜
        case 2:
        {
            GuessViewController *guess = [[GuessViewController alloc] init];
            [nc pushViewController:guess animated:YES];
        }
            break;
            //刮刮乐
        case 3:
        {
            ScratchViewController *scratch = [[ScratchViewController alloc] init];
            [nc pushViewController:scratch animated:YES];
        }
            break;
            //邀请奖励
        case 4:
        {
            VisitViewController *visit = [[VisitViewController alloc] init];
            [nc pushViewController:visit animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)showDutyView{
    TMAlertView* alView =[[TMAlertView alloc]initWithTitle:@"免责声明" andOneTip:@"对于91淘金APP内的活动,我们声明:" andTwoTip:@"1.APP内包括抽奖、竞彩、刮奖、晒单、分享等活动，苹果公司既不是赞助商，也没有以任何形式参与;" andThreeTip:@"2.活动涉及到的奖品与苹果公司无关;" andFourTip:@"3.每期活动内容以当天的活动详情为准。" andTipContent:nil andTipImage:nil andTipHighlightImage:nil andOkContent:@"好的，我知道了" andBGImageL:GetImage(@"tmalert.png") jifenName:nil];
    [alView remakeContent];
    [alView show];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@" ActiveCenterDutyShow %d  ",[[[MyUserDefault standardUserDefaults] getActiveCenterDutyShow] intValue]);
    if ([[[MyUserDefault standardUserDefaults] getIsNeedDutyView] intValue] ==1) {
        
    if ([[[MyUserDefault standardUserDefaults] getActiveCenterDutyShow] intValue] !=1) {
        [[MyUserDefault standardUserDefaults] setActiveCenterDutyShow:[NSNumber numberWithInt:1]];
        [self showDutyView];
    }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
