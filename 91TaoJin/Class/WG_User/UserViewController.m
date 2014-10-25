//
//  UserViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "UserViewController.h"
#import "CellView.h"
#import "SettingViewController.h"
#import "SDImageView+SDWebCache.h"
#import "VisitViewController.h"
#import "RewardListViewController.h"
#import "MessageViewController.h"
#import "TJViewController.h"
#import "User.h"
#import "JSONKit.h"
#import "LoadingView.h"
#import "MScrollVIew.h"
#import "CompressImage.h"
#import "TjNavigationController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "NSString+IsEmply.h"
#import "CButton.h"
#import "HeadToolBar.h"
#import "InforViewController.h"

#define kIncomeName @"收支明细"
#define kRewardName @"兑奖记录"
#define kMsgName @"消息中心"
#define kVisitName @"邀请奖励"
#define kMakeGrade @"求五星评价"

#define kHeadHeight 100.0
#define kLogoSize 29.0
#define GetCell(tag) (CellView *)[self.view viewWithTag:tag]

@interface UserViewController ()
{
    UIImage* getImage;
    User* user ;
    UIImageView* headBackground2;
    UIImageView* headBackground1;
    
    AVAudioPlayer* newPlay;
    
    int logBetween;
    MScrollVIew* ms;
    //    HeadView *headView;
    
    CMMotionManager *motionManager;
    
    //    CellView *cellHead;                                                             //第二个section的第一个cell
    //    CellView *cellBottom;                                                           //第二个section的最后一个cell
    
    UILabel *erinnernLab;                                                           //在第一个section的第一个cell上方显示提醒消息
    UILabel *userNameLab;                                                           //显示用户名
    UILabel *userJdsLab;                                                            //显示金豆数量
    UIImageView *topImage;                                                          //
    UIImageView *bootom;                                                            //
    
    int inviteCount;                                                                //
    int needReloadCell;                                                             //需要重新刷新加载的cell
    
    BOOL isFrist;                                                                   //判断是不是第一次请求用户信息
    NSMutableArray *cellArray;
    UIView *bgView ;
    UINavigationController *nc;
    TjNavigationController *tc;
}
@end

@implementation UserViewController

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
    inviteCount = 0;
    needReloadCell = 0;
    isFrist = YES;
    cellArray =[[NSMutableArray alloc]init];
    if(nc == nil)
        nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    if(tc == nil)
        tc = (TjNavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initWithObjects];
    NSLog(@"  frame %f  ",self.navigationController.navigationBar.frame.size.height);
    
    
    HeadToolBar *headBar =[[HeadToolBar alloc] initWithTitle:KLfour leftBtnTitle:nil leftBtnImg:nil leftBtnHighlightedImg:nil rightBtnTitle:@"设置" rightBtnImg:GetImage(@"icon_setting.png") rightBtnHighlightedImg:GetImage(@"setting_sel.png") backgroundColor:KOrangeColor2_0];
    headBar.rightBtn.tag =1;
    [headBar.rightBtn addTarget:self action:@selector(onClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    
    if (IOS_Version >= 7.0) {
        ms = [[MScrollVIew alloc]initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height - kfootViewHeigh + 20) andWithPageCount:1 backgroundImg:nil];
    }else{
        ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0,kHeadViewHeigh, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height - kfootViewHeigh) andWithPageCount:1 backgroundImg:nil];
    }
    
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    //    ms.panGestureRecognizer.enabled = NO;
    ms.delegate =self;
    ms.bounces =YES;
    [self.view addSubview:ms];
    
    [self setViewContent];
    
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offY = scrollView.contentOffset.y;
    if (offY <=0) {
        bgView.frame =CGRectMake(0, scrollView.frame.origin.y, scrollView.frame.size.width, offY *-1);
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self initCellData];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    //设置传感器
    //    if (!motionManager.accelerometerActive) {
    //        [self setAccelerometer];
    //    }
    [self requestToGetUserInfor];
}

-(void)initCellData{
    switch (needReloadCell) {
        case 1:
            
            [GetCell(1000) showCellCoinDetails:nil withIncomeType:1];
            break;
        case 2:{      //visit cell
            CellView* cell =(CellView*)[self.view viewWithTag:1003];
            [cell showCellCoinDetails:nil withIncomeType:1];
            cell.hotImage.alpha =1;
        }
            break;
        case 3:
            [GetCell(1002) showCellMessageTip:0];
            break;
    }
}

//初始化UILabel的共用函数
-(UILabel *)loadWithLabel:(CGRect)frame textStr:(NSString *)textStr textColor:(UIColor *)textColor font:(UIFont *)font{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = textStr;
    label.textColor = textColor;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

-(void)setViewContent{
    
    bgView =[[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor =KLightGrayColor2_0;
    [self.view insertSubview:bgView belowSubview:ms];
    
    UIButton *headBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.backgroundColor =KLightGrayColor2_0;
    headBtn.tag =8 ;
    headBtn.frame =CGRectMake(0, 0, kmainScreenWidth, kHeadHeight);
    [headBtn addTarget:self action:@selector(onClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* lineView =[[UIView alloc]initWithFrame:CGRectMake(0, headBtn.frame.size.height, 320, 0.5)];
    lineView.backgroundColor =kGrayLineColor2_0;
    
    
    //用户的头像
    headBackground1 = [[UIImageView alloc] init];
    headBackground1.frame = CGRectMake(kOffX_float, kOffY_float, 65, 65);
    
    
    NSData *picData = [[MyUserDefault standardUserDefaults] getUserPic];
    UIImage *userPic = [[UIImage alloc]initWithData:picData];
    if (userPic) {
        headBackground1.image = userPic;
    }else{
        if (user.userIcon != nil) {
            [[MyUserDefault standardUserDefaults] setUserIconUrlStr:user.userIcon];
            [headBackground1 setImageWithURL:[NSURL URLWithString:user.userIcon] refreshCache:NO placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
        }else{
            headBackground1.image = [UIImage imageNamed:@"touxiang.png"];
        }
    }
    //提示信息显示
    erinnernLab = [self loadWithLabel:CGRectMake(headBackground1.frame.origin.x + headBackground1.frame.size.width + 11, headBackground1.frame.origin.y, 200, 17) textStr:nil textColor:KGrayColor2_0 font:[UIFont systemFontOfSize:16.0]];
    
    //用户昵称
    userNameLab = [self loadWithLabel:CGRectMake(erinnernLab.frame.origin.x, erinnernLab.frame.origin.y + erinnernLab.frame.size.height +11, 180, 12) textStr:[NSString stringWithFormat:@"淘金号:%@",[[MyUserDefault standardUserDefaults]getUserId]]  textColor:KGrayColor2_0 font:[UIFont systemFontOfSize:11.0]];
    
    //显示【金豆】文案
    UILabel *jinDouLab = [self loadWithLabel:CGRectMake(erinnernLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height+11,36, 16) textStr:@"金豆" textColor:KBlockColor2_0  font:[UIFont systemFontOfSize:16.0]];
    
    //显示金豆数量
    userJdsLab = [self loadWithLabel:CGRectMake(jinDouLab.frame.origin.x+jinDouLab.frame.size.width, jinDouLab.frame.origin.y, 100, 16) textStr:[NSString stringWithFormat:@"%d",user.userBean] textColor:KOrangeColor2_0 font:[UIFont boldSystemFontOfSize:16.0]];
    
    
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next.png"]];
    nextImage.frame = CGRectMake(296, 44, 8, 12);
    
    [ms addSubview:headBtn];
    [ms addSubview:lineView];
    [ms addSubview:headBackground1];
    
    
    [ms addSubview:erinnernLab];
    [ms addSubview:userNameLab];
    [ms addSubview:jinDouLab];
    [ms addSubview:userJdsLab];
    [ms addSubview:nextImage];
    
    
    NSMutableArray *arrImage = [NSMutableArray arrayWithObjects:GetImage(@"icon_Income.png"),GetImage(@"icon_Reward.png"),GetImage(@"icon_Message.png"),GetImage(@"icon_Visit.png"),nil];
    NSMutableArray *titles = [NSMutableArray arrayWithObjects:kIncomeName,kRewardName ,kMsgName ,kVisitName, nil];
    
    //第二个section中间的所有cell
    for (int i = 0; i < arrImage.count; i++) {
        CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(0, 100.5+ i*(kCellHeight-0.5) , 320, kCellHeight)];
        [cell setCellViewByType:i andWithImage:[arrImage objectAtIndex:i] andCellTitle:[titles objectAtIndex:i]];
        [cell setButtonFrame:CGRectMake(0, -0.5f, cell.frame.size.width, kCellHeight+1.0f) ];
        [cell setImageFrame:CGRectMake(kOffX_float, 12, kLogoSize, kLogoSize) andTitleFrame:CGRectMake(48, kCellHeight/2 -15, 100, 30)];
        [cellArray addObject:cell];
        if (i ==arrImage.count -1) {
            cell.hotImage.alpha =1.0;
        }
        cell.tag = 1000 + i;
        UIButton *btn = [[cell subviews]objectAtIndex:0];
        btn.tag = 3 + i;
        [btn addTarget:self action:@selector(onClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
        [ms addSubview:cell];
    }
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [motionManager stopAccelerometerUpdates];
}

-(void)setAccelerometer{
    if (motionManager) {
        motionManager =nil;
    }
    motionManager =[[CMMotionManager alloc]init];
    if (!motionManager.accelerometerAvailable) {
        
    }
    motionManager.accelerometerUpdateInterval = 0.01;
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData* accelerometerData,NSError* error){
        CMAccelerometerData *newestAccel = motionManager.accelerometerData;
        if (newestAccel.acceleration.x > 2.0 || newestAccel.acceleration.x < -2.0 || newestAccel.acceleration.y > 2.0 || newestAccel.acceleration.y < -2.0 || newestAccel.acceleration.z > 2.0 || newestAccel.acceleration.z < -2.0) {
            if (motionManager) {
                motionManager = nil;
                [self requestToYaoYiYao];
            }
        }
    }];
}

//请求发送摇一摇（new）
-(void)requestToYaoYiYao{
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    int random = arc4random() % 100000;
    NSDictionary *dic = @{@"sid": sid, @"time": [NSNumber numberWithInt:random]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"Yaoyao"];
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                int message = [[body objectForKey:@"Message"] intValue];
                int gold = [[body objectForKey:@"gold"] intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(message == -1){
                        [StatusBar showTipMessageWithStatus:@"今天已经摇过啦,请明天再摇" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
                    }else if(message == gold){
                        [StatusBar showTipMessageWithStatus:@"摇一摇抽奖" andImage:[UIImage imageNamed:@"icon_yes.png"] andCoin:[NSString stringWithFormat:@"+%d",gold] andSecImage:[UIImage imageNamed:@"tipBean.png"]andTipIsBottom:YES];
                        [self upDateJdCount:gold];
                        [self startImageAnimation];
                        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(startUpdate) userInfo:nil repeats:NO];
                    }
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            //连接超时
        }
    }];
}

//开始摇一摇的动画效果
-(void)startImageAnimation{
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:101];
    [imageView startAnimating];
}

-(void)upDateJdCount:(int)gold{
    int oldBeanCount = user.userBean;
    userJdsLab.text = [NSString stringWithFormat:@"%d",gold+oldBeanCount];
    int between = logBetween + gold;
    NSNumber* num = [NSNumber numberWithInt:between];
    CellView *incomeCell =(CellView *)[self.view viewWithTag:1000];
    if (between > 0) {
        [incomeCell showCellCoinDetails:num withIncomeType:2];
    }else if (between < 0){
        [incomeCell showCellCoinDetails:num withIncomeType:1];
    }else{
        [incomeCell showCellCoinDetails:nil withIncomeType:1];
    }
}

-(void)startUpdate{
    [self setAccelerometer];
}


//请求获取我的中心的信息
-(void)requestToGetUserInfor{
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
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求获取我的中心的信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                user = [[User alloc] initWithDictionary:body];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:user.userBean];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    if([NSString isEmply:user.userName]){
                        erinnernLab.hidden = NO;
                        //                            int iconGold = [[body objectForKey:@"IconGold"] intValue];
                        erinnernLab.text = [NSString stringWithFormat:@"完善用户信息奖金豆"];
                        //                        userNameLab.text =[NSString stringWithFormat:@"淘金号:%@",[[MyUserDefault standardUserDefaults]getUserId]];
                    }else{
                        erinnernLab.text =user.userName;
                        //                        userNameLab.text =user.userName;
                        NSData *userPicData = [[MyUserDefault standardUserDefaults] getUserPic];
                        //判断本地有无该用户的头像图片,若无需要请求服务器进行获取
                        if(userPicData != nil){
                            UIImage *userPicImg = [UIImage imageWithData:userPicData];
                            headBackground1.image = userPicImg;
                        }else{
                            [headBackground1 setImageWithURL:[NSURL URLWithString:user.userIcon] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage imageNamed:@"touxiang.png"]];
                        }
                    }
                    userJdsLab.text = [NSString stringWithFormat:@"%d",user.userBean];
                    
                    userJdsLab.text=[NSString stringWithFormat:@"%d",user.userBean];
                    NSString* name =[body objectForKey:@"NickName"];
                    if (![name isEqualToString:@""]) {
                        erinnernLab.text =[body objectForKey:@"NickName"];
                    }
                    int log =0;
                    CellView *income =GetCell(1000);
                    if (![[MyUserDefault standardUserDefaults]getUserLog]) {
                        logBetween =user.userBean;
                        NSNumber* jdnum =[NSNumber numberWithInt:user.userBean];
                        [income showCellCoinDetails:jdnum withIncomeType:2];
                    }else{
                        log = [[[MyUserDefault standardUserDefaults]getUserLog] integerValue];
                        
                        logBetween =user.userLog -log;
                        NSNumber* numBetween =[NSNumber numberWithInt:logBetween];
                        if (logBetween > 0) {
                            
                            [income showCellCoinDetails:numBetween withIncomeType:2];
                        }else if (logBetween < 0){
                            
                            [income showCellCoinDetails:numBetween withIncomeType:1];
                        }else{
                            [income showCellCoinDetails:nil withIncomeType:1];
                        }
                    }
                    
                    if ([[[MyUserDefault standardUserDefaults]getUserInviteCount] isKindOfClass:[NSNull class]]) {
                        CellView* cell =GetCell(1003);
                        if ([[body objectForKey:@"Invite"]integerValue]!=0) {
                            int count =[[body objectForKey:@"Invite"]integerValue];
                            NSNumber* num =[NSNumber numberWithInt:count];
                            inviteCount =count;
                            cell.hotImage.alpha=0;
                            if (count >0) {
                                [cell showCellCoinDetails:num withIncomeType:2];
                            }
                            else if (count < 0){
                                //                [cell showCellCoinDetails:nil withIncomeType:1];
                            }
                        }
                        else{
                            cell.hotImage.alpha=1;
                        }
                    }
                    else{
                        CellView* cell =GetCell(1003);
                        if ([[body objectForKey:@"Invite"]integerValue]!=0) {
                            
                            int count =[[body objectForKey:@"Invite"]integerValue];
                            int oldnum =[[[MyUserDefault standardUserDefaults]getUserInviteCount] integerValue];
                            inviteCount = count;
                            int newnum =count -oldnum;
                            cell.hotImage.alpha=0;
                            NSNumber* num =[NSNumber numberWithInt:newnum];
                            if (newnum >0) {
                                [cell showCellCoinDetails:num withIncomeType:2];
                                
                            }
                            else if (newnum < 0){
                                [cell showCellCoinDetails:nil withIncomeType:1];
                            }else if (newnum ==0){
                                
                                cell.hotImage.alpha=1;
                                [cell showCellCoinDetails:nil withIncomeType:1];
                            }
                        }
                        else{
                            cell.hotImage.alpha=1;
                        }
                    }
                    CellView *msgCell =GetCell(1002);
                    if ([[body objectForKey:@"MsgNum"]integerValue]!=0) {
                        int count =[[body objectForKey:@"MsgNum"]integerValue];
                        //                        NSNumber* number =[NSNumber numberWithInt:count];
                        [[MyUserDefault standardUserDefaults]setUserMsgNum:count];
                        [msgCell showCellMessageTip:count];
                        
                    }
                    else {
                        [msgCell showCellMessageTip:0];
                    }
                    
                    if ([body objectForKey:@""]) {
                        CellView *cell = [[CellView alloc] initWithFrame:CGRectMake(0, 100+ 4*(kCellHeight) , 320, kCellHeight)];
                        [cell setCellViewByType:2 andWithImage:[UIImage imageNamed:@""] andCellTitle:kMakeGrade];
                        [cell setButtonFrame:CGRectMake(0, -1, cell.frame.size.width, kCellHeight+1)];
                        [cell setImageFrame:CGRectMake(kOffX_float, 12, kLogoSize, kLogoSize) andTitleFrame:CGRectMake(48, kCellHeight/2 -15, 100, 30)];
                        cell.tag = 1004;
                        UIButton *btn = [[cell subviews]objectAtIndex:0];
                        btn.tag = 8;
                        [btn addTarget:self action:@selector(onClickNextBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [ms addSubview:cell];
                        
                    }
                    
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
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

-(void)onClickNextBtn:(UIButton* )btn{
    int num = btn.tag;
    switch (num) {
            //系统设置
        case 1:
        {
            settingView.highlighted = YES;
            SettingViewController *set = [[SettingViewController alloc]initWithNibName:nil bundle:nil];
            if (IOS_Version >= 7.0) {
                [tc pushViewController:set animated:YES];
            }else{
                [nc pushViewController:set animated:YES];
            }
            
        }
            break;
            //收支明细
        case 3:
        {
            IncomeViewController* ic = [[IncomeViewController alloc]initWithNibName:nil bundle:nil];
            ic.userLog = user.userLog;
            needReloadCell = 1;
            if (IOS_Version >= 7.0) {
                [tc pushViewController:ic animated:YES];
            }else{
                [nc pushViewController:ic animated:YES];
            }
            
        }
            break;
            //邀请奖励
        case 6:
        {
            VisitViewController *vc = [[VisitViewController alloc]initWithNibName:nil bundle:nil];
            vc.inviteCount = inviteCount;
            needReloadCell = 2;
            if (IOS_Version >= 7.0) {
                [tc pushViewController:vc animated:YES];
            }else{
                [nc pushViewController:vc animated:YES];
            }
            
        }
            break;
            //兑奖记录
        case 4:
        {
            RewardListViewController* rc = [[RewardListViewController alloc]initWithNibName:nil bundle:nil];
            rc.isRootPush =YES;
            if (IOS_Version >= 7.0) {
                [tc pushViewController:rc animated:YES];
            }else{
                [nc pushViewController:rc animated:YES];
            }
            
        }
            break;
            //消息中心
        case 5:
        {
            MessageViewController *rc = [[MessageViewController alloc]initWithNibName:nil bundle:nil];
            needReloadCell = 3;
            if (IOS_Version >= 7.0) {
                [tc pushViewController:rc animated:YES];
            }else{
                [nc pushViewController:rc animated:YES];
            }
            
        }
            break;
            
        case 8:
        {
            /*
             headImageView.highlighted=YES;
             UIActionSheet* as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
             
             as.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
             [as dismissWithClickedButtonIndex:2 animated:YES];
             if (IOS_Version < 7.0) {
             TJViewController *tj = [[TJViewController alloc]init];
             [as showFromTabBar:tj.tabBar];
             }else{
             [as showInView:self.view];
             }
             headImageView.highlighted=NO;
             */
            InforViewController *infor =[[InforViewController alloc]initWithNibName:nil bundle:nil];
            infor.user =user;
            if (IOS_Version >= 7.0) {
                [tc pushViewController:infor animated:YES];
            }else{
                [nc pushViewController:infor animated:YES];
            }
            
        }
            break;
            
        case 7:    // 五星评价
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kOfficeWeb]];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            //拍照
        case 0:
        {
            UIImagePickerControllerSourceType type=UIImagePickerControllerSourceTypeCamera;
            if([UIImagePickerController isSourceTypeAvailable:type]){
                UIImagePickerController* pc=[[UIImagePickerController alloc]init];
                pc.delegate=self;
                pc.allowsEditing=YES;
                pc.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:pc animated:YES completion:nil];
            }
        }
            break;
            //从相册取相片
        case 1:
        {
            UIImagePickerController* pc=[[UIImagePickerController alloc]init];
            pc.delegate=self;
            pc.allowsEditing=YES;
            pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:pc animated:YES completion:nil];
            
        }
            break;
        case 2:
        {
            
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    getImage=[info objectForKey:UIImagePickerControllerEditedImage];
    
    if ([self isBigImage:getImage]==YES) {
        getImage =[CompressImage imageWithOldImage:getImage scaledToSize:CGSizeMake(120, 120)];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self sendSaveInforRequest:getImage];
}

-(BOOL)isBigImage:(UIImage*)image{
    NSData* data =UIImageJPEGRepresentation(image, 1.0);
    
    if (data.length >10240) {
        return YES;
    }else{
        return NO;
    }
}

-(void)sendSaveInforRequest:(UIImage*)userimage{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSString* sid =[defaults objectForKey:@"sid"];
    
    NSMutableDictionary* dic2=[[NSMutableDictionary alloc]initWithObjectsAndKeys:sid,@"sid", nil];
    NSString* paramStr =[dic2 JSONString];
    UIImage* image =userimage;
    [dic2 setObject:image forKey:[NSString stringWithFormat:@"userPic"]];
    NSData* data12 =UIImageJPEGRepresentation(image, 1.0);
    
    
    NSString* urlStr =[NSString stringWithFormat:@"%@?d=api&c=MyCenterUI&m=ChangePic&IOS=ios",kOnlineWeb];
    NSURL* url =[NSURL URLWithString:urlStr];
    NSMutableURLRequest* urlRequest=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10.0];
    NSString* boundary =@"0xKhTmLbOuNdArY";
    NSString* contentType= [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
    [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* body =[NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='PARAM';value='%@'\n\n",paramStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"{\"sid\":\"%@\"}",sid] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //第二段
    int imageTag=0;
    for (NSString* key in dic2.allKeys) {
        id value =[dic2 objectForKey:key];
        
        if ([value isKindOfClass:[UIImage class]]) {
            NSData* dataImg;
            if (data12.length >10240) {
                dataImg= UIImageJPEGRepresentation(value, 0.5);
            }else{
                dataImg= UIImageJPEGRepresentation(value, 1);
            }
            [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name='userfile%d';filename='userfile.jpg'\n",imageTag] dataUsingEncoding:NSUTF8StringEncoding]];
            imageTag++;
            [body appendData:[[NSString stringWithFormat:@"Content-Type:image/jpg\n\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:dataImg];
            [body appendData:[[NSString stringWithFormat:@"\n--%@--\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }
    
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:body];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getPushMessageCenter:(NSNotification* )notic{
    MessageViewController *rc= [[MessageViewController alloc]initWithNibName:nil bundle:nil];
    [nc pushViewController:rc animated:NO];
    
}

@end









