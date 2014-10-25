//
//  TJViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "TJViewController.h"
#import "RewardViewController.h"
#import "UserViewController.h"
#import "NewUserCenterController.h"
#import "TaskViewController.h"
#import "ActivityCenterViewController.h"
#import "ScratchViewController.h"
#import "MyUserDefault.h"
#import "NSDate+nowTime.h"
#import "AsynURLConnection.h"

//test
typedef enum{
    TaskType = 1,
    ActivityType,
    RewardType,
    NewUser,
}TaojinTypeEnum;

@interface TJViewController ()
{
    TaskViewController *task;                   //任务大厅
    
    ActivityCenterViewController *active;
    RewardViewController *reward;
    //    UserViewController *user;
    NewUserCenterController *user;
    
    TaojinTypeEnum taojintype;
    
    int freshTime;
    
    NSString* ver;                                           // 再次登录不提示的版本号
    int updatetype;                                          // 升级类型
    UIAlertView* updateTip;                                  // 提示框
    NSString *updateUrl;                                     // 升级目标地址
    UIImageView *footImgae;

    float  timeCount ;                                         //记录欢迎页已展示时间
    NSTimer *timer ;
    float welcomeStay ;                                        // 欢迎页停留时间
}

@end

@implementation TJViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    timeCount = 0;
    welcomeStay = 0 ;
    [self updateTabbarView];
    if (self.state == 0) {      // 是否需要展示欢迎图
        [self isNeedShowWelcome];
    }
    taojintype = TaskType;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonPosition) name:@"goBackToTaojin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoginedNotic) name:@"LoginedNotic" object:nil];
    
}
-(void)getLoginedNotic{

    [timer invalidate];
    NSLog(@" get notic %f %f",timeCount,welcomeStay);
    if (timeCount < welcomeStay) {
        float time = welcomeStay - timeCount ;
        [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(missWelcome) userInfo:nil repeats:NO];
    }else{
        [self missWelcome];
    }
}
-(void)changeButtonPosition{
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag =0;
    [self clickBtn:btn];
}

//初始化tabbar的按钮
- (UIButton *)loadWithTabbarButton:(CGRect)frame tag:(int)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//初始化tabbar的图片
-(UIImageView *)loadWithTabbarImage:(CGRect)frame defaultImage:(UIImage *)defaultImage highlightedImage:(UIImage *)highImage isHighlighted:(BOOL)isHighlighted{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage highlightedImage:highImage];
    imageView.frame = frame;
    [imageView setHighlighted:isHighlighted];
    return imageView;
}

//初始化tabbar的label
-(UILabel *)loadWithTabbarLabel:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor tag:(int)tag{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = font;
    label.text = text;
    label.textColor = textColor;
    return label;
}

-(void)updateTabbarView{
    
    footImgae = [[UIImageView alloc] initWithFrame:CGRectMake(0, kmainScreenHeigh - kfootViewHeigh, kmainScreenWidth, kfootViewHeigh)];
    footImgae.backgroundColor = KLightGrayColor2_0;
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.0, kmainScreenWidth, 0.5)];
    lineImg.backgroundColor = kLineColor2_0;
    [footImgae addSubview:lineImg];
    
    [self.view addSubview:footImgae];
    
    UIButton *btnTJ = [self loadWithTabbarButton:CGRectMake(0,kmainScreenHeigh - kfootViewHeigh, kmainScreenWidth/4, kfootViewHeigh) tag:0];
    
    UIButton *btnRW = [self loadWithTabbarButton:CGRectMake(kmainScreenWidth/4,kmainScreenHeigh-kfootViewHeigh, kmainScreenWidth/4, kfootViewHeigh) tag:1];
    
    UIButton *btnCom = [self loadWithTabbarButton:CGRectMake(kmainScreenWidth/4*2, kmainScreenHeigh-kfootViewHeigh, kmainScreenWidth/4, kfootViewHeigh)  tag:2];
    
    UIButton *btnUser = [self loadWithTabbarButton:CGRectMake(kmainScreenWidth/4*3,kmainScreenHeigh-kfootViewHeigh, kmainScreenWidth/4, kfootViewHeigh) tag:3];
    
    one = [self loadWithTabbarImage:CGRectMake(0, 0, klogowidth, klogoheigh) defaultImage:[UIImage imageNamed:@"1_1.png"] highlightedImage:[UIImage imageNamed:@"1_2.png"] isHighlighted:YES];
    [one setBackgroundColor:[UIColor clearColor]];
    
    two = [self loadWithTabbarImage:CGRectMake(kmainScreenWidth/4, 0, klogowidth, klogoheigh) defaultImage:[UIImage imageNamed:@"2_1.png"] highlightedImage:[UIImage imageNamed:@"2_2.png"] isHighlighted:NO];
    
    three = [self loadWithTabbarImage:CGRectMake(kmainScreenWidth/2, 0, klogowidth,klogoheigh) defaultImage:[UIImage imageNamed:@"3_1.png"] highlightedImage:[UIImage imageNamed:@"3_2.png"] isHighlighted:NO];
    
    four = [self loadWithTabbarImage:CGRectMake(kmainScreenWidth/4*3, 0, klogowidth, klogoheigh) defaultImage:[UIImage imageNamed:@"4_1.png"] highlightedImage:[UIImage imageNamed:@"4_2.png"] isHighlighted:NO];
    
    Lone = [self loadWithTabbarLabel:CGRectMake(0.0f, 34.0f, knamewidth, knameheigh) text:KLone font:tabbarFont textColor:tabbarHighlightedTextColor tag:0];
    
    Ltwo = [self loadWithTabbarLabel:CGRectMake(kmainScreenWidth/4, 34.0f, knamewidth, knameheigh) text:KLtwo font:tabbarFont textColor:tabbarDefaultTextColor tag:1];
    
    Lthree = [self loadWithTabbarLabel:CGRectMake(kmainScreenWidth/2, 34.0f, knamewidth, knameheigh) text:KLthree font:tabbarFont textColor:tabbarDefaultTextColor tag:2];
    
    Lfour = [self loadWithTabbarLabel:CGRectMake(kmainScreenWidth/4*3, 34.0f, knamewidth, knameheigh) text:KLfour font:tabbarFont textColor:tabbarDefaultTextColor tag:3];
    
    [footImgae addSubview:one];
    [footImgae addSubview:two];
    [footImgae addSubview:three];
    [footImgae addSubview:four];
    [footImgae addSubview:Lone];
    [footImgae addSubview:Ltwo];
    [footImgae addSubview:Lthree];
    [footImgae addSubview:Lfour];
    
    
    [self.view addSubview:btnTJ];
    [self.view addSubview:btnRW];
    [self.view addSubview:btnUser];
    [self.view addSubview:btnCom];
}

//当点击tabbar底部的按钮时，切换按钮和label的显示效果
-(void)changeButtonHighlighted:(BOOL)oneIsHighlighted twoIsHighlighted:(BOOL)twoIsHighlighted threeIsHighlighted:(BOOL)threeIsHighlighted fourIsHighlighted:(BOOL)fourIsHighlighted{
    if(one.highlighted != oneIsHighlighted){
        one.highlighted = oneIsHighlighted;
        if(one.highlighted)
            Lone.textColor = tabbarHighlightedTextColor;
        else
            Lone.textColor = tabbarDefaultTextColor;
    }
    if(two.highlighted != twoIsHighlighted){
        two.highlighted = twoIsHighlighted;
        if(two.highlighted)
            Ltwo.textColor = tabbarHighlightedTextColor;
        else
            Ltwo.textColor = tabbarDefaultTextColor;
    }
    if(three.highlighted != threeIsHighlighted){
        three.highlighted = threeIsHighlighted;
        if(three.highlighted)
            Lthree.textColor = tabbarHighlightedTextColor;
        else
            Lthree.textColor = tabbarDefaultTextColor;
    }
    if(four.highlighted != fourIsHighlighted){
        four.highlighted = fourIsHighlighted;
        if(four.highlighted)
            Lfour.textColor = tabbarHighlightedTextColor;
        else
            Lfour.textColor = tabbarDefaultTextColor;
    }
}

-(void)clickBtn:(UIButton*)btn {
    switch (btn.tag) {
        case 0:
        {
            [self changeButtonHighlighted:YES twoIsHighlighted:NO threeIsHighlighted:NO fourIsHighlighted:NO];
            //            [self showTaoJinView];
            [self showTaskView];
        }
            break;
        case 1:
        {
            [self changeButtonHighlighted:NO twoIsHighlighted:YES threeIsHighlighted:NO fourIsHighlighted:NO];
            //            [self showRewardView];
            [self showActivityCenter];
        }
            break;
        case 2:
        {
            [self changeButtonHighlighted:NO twoIsHighlighted:NO threeIsHighlighted:YES fourIsHighlighted:NO];
            [self showRewardView];
        }
            break;
        case 3:
        {
            [self changeButtonHighlighted:NO twoIsHighlighted:NO threeIsHighlighted:NO fourIsHighlighted:YES];
            [self showUserView];
        }
            break;
        default:
            break;
    }
    backView.frame = CGRectMake(backView.frame.size.width * btn.tag, 0, backView.frame.size.width, backView.frame.size.height);
    self.selectedViewController = [self.viewControllers objectAtIndex:btn.tag];
}

//显示【任务大厅】的界面
-(void)showTaskView{
    
    NSNumber *refrshTime = [[MyUserDefault standardUserDefaults] getDaTingRefreshTime];
    long long int nowTime = [NSDate getNowTime];
    
    //    if(!task.isRequesting && taojintype != TaskType ){
    //        [task initWithObjects];
    //        taojintype = TaskType;
    //    }
    NSNumber *freshTimeNum = [[MyUserDefault standardUserDefaults] getViewFreshTime];
    if(freshTimeNum == nil){
        freshTime = 30;
    }else{
        freshTime = [freshTimeNum intValue];
    }
    if(task.jifenAry.count == 0 || task.appAry.count == 0 || (taojintype != TaskType && task.isRequesting == NO && (refrshTime == nil || nowTime - [refrshTime longLongValue] >= freshTime))){
        [task initWithObjects];
    }else if(task.jifenAry.count == 0 || task.appAry.count == 0 || (nowTime - [refrshTime longLongValue] >= freshTime && task.isRequesting == YES)){
        task.isRequesting = NO;
        [task initWithObjects];
    }
    
    taojintype = TaskType;
    
    
    
    //测试
    
    taojintype = TaskType;
}

//显示【活动中心】界面
-(void)showActivityCenter{
    //    UINavigationController *ac = [self.viewControllers objectAtIndex:1];
    //    active = (ActivityCenterViewController *)ac.topViewController;
    
    //重置【天天参与】
    if(taojintype != ActivityType){
        if(!active.takePartTableView.isRequesting)
            [active.takePartTableView initObjects];
        //重置【晒单有奖】
        if(!active.showPostsTableView.isRequesting)
            [active.showPostsTableView initObjects];
        //重置【分享有奖】
        if(!active.shareTableView.isRequesting)
            [active.shareTableView initObjects];
    }
    taojintype = ActivityType;
}

//显示【奖品兑换】的界面
-(void)showRewardView{
    
    NSNumber *refrshTime = [[MyUserDefault standardUserDefaults] getRewordRefreshTime];
    long long int nowTime = [NSDate getNowTime];
    
    //重置【奖品兑换】
    //    if(!reward.isRequesting && taojintype != RewardType){
    //        [reward initWithObjects];
    //        taojintype = RewardType;
    //    }
    NSNumber *freshTimeNum = [[MyUserDefault standardUserDefaults] getViewFreshTime];
    if(freshTimeNum == nil){
        freshTime = 30;
    }else{
        freshTime = [freshTimeNum intValue];
    }
    if(reward.allGoodsAry.count == 0 || (reward.isRequesting == NO && taojintype != RewardType && (refrshTime == nil || nowTime - [refrshTime longLongValue] >= freshTime))){
        [reward initWithObjects];
    }else if(reward.allGoodsAry.count == 0 || (nowTime - [refrshTime longLongValue] >= freshTime && reward.isRequesting == YES)){
        reward.isRequesting = NO;
        [reward initWithObjects];
    }
    if(reward.isRequestingWithGold == NO){
        [reward requestForUserBeans];
    }
    taojintype = RewardType;
}


//显示【我的淘金】的界面
-(void)showUserView{
    //    UINavigationController* cv = [self.viewControllers objectAtIndex:3];
    //    user = (NewUserCenterController* )cv.topViewController;
    if(!user.isRequesting && taojintype != NewUser){
        [user initWithObjects];
    }
    taojintype = NewUser;
}


-(void)checkUpdate{
    
    [self showUpdateOrUserLockingTip];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //  升级提示
    if(alertView == updateTip)
    {
        if(buttonIndex==0)
        {
            //重要升级
            if (updatetype ==0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            }
            //普通升级
            else if (updatetype ==1){
                [updateTip dismissWithClickedButtonIndex:0 animated:YES];
                NSDictionary* updateDic =[[MyUserDefault standardUserDefaults]getUpdate];
                if (updateDic) {
                    NSString* appVersion =[updateDic objectForKey:@"Ver"];
                    [[MyUserDefault standardUserDefaults] setAppVersion:appVersion];   //点击取消 记录下版本号 下次登录不提示
                }
            }
        }
        else if(buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            
        }
    }
    
}
// 升级提示
-(void)showUpdateOrUserLockingTip{
    NSDictionary* di =[[MyUserDefault standardUserDefaults]getUpdate];
    if (di.allKeys.count !=0 ) {
        NSDictionary* dic =[[MyUserDefault standardUserDefaults]getUpdate];
        ver =[[MyUserDefault standardUserDefaults] getAppVersion];     //提示过但点击取消的版本 再次登录时不提示
        updatetype =[[di objectForKey:@"Type"]integerValue];
        //不提示升级
        if (updatetype ==2) {
            
        }else{
            
            NSString* content =[dic objectForKey:@"Content"];
            updateUrl =[dic objectForKey:@"Apk"];
            if (updatetype ==1) {
                if (!updateTip) {
                    updateTip =[[UIAlertView alloc]initWithTitle:knewVersion message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即更新", nil];
                }
                
            }else if (updatetype ==0){
                if (!updateTip) {
                    updateTip =[[UIAlertView alloc]initWithTitle:kupdateTip message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新", nil];
                }
                
            }
            
            double delay =[[dic objectForKey:@"Delay"]doubleValue];
            [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(showUpdateTip) userInfo:nil repeats:NO];
        }
    }
    
}

-(void)showUpdateTip{
    //不提示升级不显示  type=2
    
    NSDictionary* dic =[[MyUserDefault standardUserDefaults]getUpdate];
    NSString* ver2 =[dic objectForKey:@"Ver"];
    NSString* version = [[[NSBundle mainBundle]infoDictionary]objectForKey:(NSString* )kCFBundleVersionKey];
    if (updatetype !=2) {
        if (updatetype ==0) {   //强制升级
            if (![ver2 isEqualToString:version]) {
                [updateTip show];
            }
        }else if (updatetype ==1){  //提示升级
            if (![ver isEqualToString:ver2]) {
                [updateTip show];
            }
        }
        
    }
}

//设置默认的四个tabbar对应的主视图
-(void)setViews{
    
    //【淘金大厅】
    /*
     UINavigationController* nc;
     if(taojin == nil){
     taojin = [[TaoJinViewController alloc] initWithNibName:nil bundle:nil];
     nc = [[UINavigationController alloc] initWithRootViewController:taojin];
     [[NSNotificationCenter defaultCenter] addObserver:taojin selector:@selector(getPushAppDetails:) name:@"PushAppDetails" object:nil];
     }else{
     nc = [self.viewControllers objectAtIndex:0];
     }
     */
    
    
    /*
     //【刮奖】界面
     UINavigationController *nc;
     if(scratch == nil){
     scratch = [[ScratchViewController alloc] init];
     nc = [[UINavigationController alloc] initWithRootViewController:scratch];
     }else{
     nc = [self.viewControllers objectAtIndex:0];
     }
     */
    
    /*
     //抽奖界面
     UINavigationController *nc;
     if(lottery == nil){
     lottery = [[LuckyLotteryViewController alloc] init];
     nc = [[UINavigationController alloc] initWithRootViewController:lottery];
     }else{
     nc = [self.viewControllers objectAtIndex:0];
     }
     */
    
    
    //【任务大厅】
    
    UINavigationController *taskNav;
    if(task == nil){
        task = [[TaskViewController alloc] initWithNibName:nil bundle:nil];
        taskNav = [[UINavigationController alloc] initWithRootViewController:task];
    }else{
        task = [self.viewControllers objectAtIndex:0];
    }
    
    /*
     UINavigationController *taskNav;
     if(task2 == nil){
     task2 = [[TaskViewController2 alloc] init];
     taskNav = [[UINavigationController alloc] initWithRootViewController:task2];
     taskNav.navigationController.interactivePopGestureRecognizer.enabled = NO;
     }else{
     task2 = [self.viewControllers objectAtIndex:0];
     }
     */
    
    //【活动中心】
    UINavigationController *activeNav;
    if(active == nil){
        active = [[ActivityCenterViewController alloc] initWithNibName:nil bundle:nil];
        activeNav = [[UINavigationController alloc] initWithRootViewController:active];
        activeNav.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        active = [self.viewControllers objectAtIndex:1];
    }
    
    //【奖品兑换】
    UINavigationController *ncrw;
    if(reward == nil){
        reward = [[RewardViewController alloc] initWithNibName:nil bundle:nil];
        ncrw = [[UINavigationController alloc] initWithRootViewController:reward];
        ncrw.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [[NSNotificationCenter defaultCenter]addObserver:ncrw selector:@selector(getPushRewardGoods:) name:@"PushRewardGoods" object:nil];
    }else{
        ncrw = [self.viewControllers objectAtIndex:2];
    }
    
    /*
     //【社区话题】
     UINavigationController *nccom;
     if(community == nil){
     community = [[CommunityViewController alloc]initWithNibName:nil bundle:nil];
     nccom = [[UINavigationController alloc]initWithRootViewController:community];
     [[NSNotificationCenter defaultCenter]addObserver:community selector:@selector(getPushTopicDetails:) name:@"PushTopicDetails" object:nil];
     }else{
     nccom = [self.viewControllers objectAtIndex:2];
     }
     */
    
    //【我的淘金】
    UINavigationController* ncuser;
    if(user == nil){
        user =[[NewUserCenterController alloc] initWithNibName:nil bundle:nil];
        ncuser = [[UINavigationController alloc] initWithRootViewController:user];
        ncuser.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [[NSNotificationCenter defaultCenter]addObserver:user selector:@selector(getPushMessageCenter:) name:@"PushMessageCenter" object:nil];
    }else{
        ncuser = [self.viewControllers objectAtIndex:3];
    }
    //    self.viewControllers = @[nc,ncrw,nccom,ncuser];
    //    self.viewControllers = @[taskNav,ncrw,nccom,ncuser];
    self.viewControllers = @[taskNav,activeNav,ncrw,ncuser];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.selectedViewController beginAppearanceTransition:YES animated: animated];

//    [self requestWelcomeAndShow];
    
}
-(void)requestWelcomeAndShow{
    if (self.state == 1 ) {
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(requestForWelCome) userInfo:nil repeats:NO];
        self.state = 0;
    }
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
    
}
-(void)isNeedShowWelcome{

    NSDictionary *oldDic =[[MyUserDefault standardUserDefaults] getWelcomImgDic];
    if (oldDic) {
        long long int nowTime =[NSDate getNowTime] ;
        long long int beginTime = [[oldDic objectForKey:@"BeginTime"] longLongValue];
        long long int endTime = [[oldDic objectForKey:@"EndTime"] longLongValue];
        BOOL isInTime = nowTime >= beginTime && nowTime <=endTime ? YES : NO ;           //对比欢迎页展示的时间
        int state = [[oldDic objectForKey:@"State"] intValue] ;
        welcomeStay = [[oldDic objectForKey:@"Stay"] floatValue];
        NSLog(@"BT=%lld  NT=%lld  ET=%lld %d",beginTime ,nowTime ,endTime,isInTime);
        NSData *picData =[[MyUserDefault standardUserDefaults] getWelcomeImgData];
        if (picData && isInTime == YES && state == 0) {
             UIImageView *welcome =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
            welcome.tag = 90001;
            UIImage *image =[UIImage imageWithData:picData];
            welcome.image = image;
            [self.view addSubview:welcome];
           timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(countTime) userInfo:nil repeats:YES];


        }else{
            [self showDefaultImage];

        }
        
    }else{
        [self showDefaultImage];

    }
    [[MyUserDefault standardUserDefaults] setIsShowedWelcome:[NSNumber numberWithInt:1]];
}
/**
*  没有后台欢迎页展示默认图
*/
-(void)showDefaultImage{
    UIImageView *welcome =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
    welcome.tag = 90001;
    if (kmainScreenHeigh > 480.0 ) {
        UIImage *image = [UIImage imageNamed:@"Default-568h@2x"];
        welcome.image = image;
        [self.view addSubview:welcome];
    }else{
        UIImage *image =[UIImage imageNamed:@"Default"];
        welcome.image =image ;
        [self.view addSubview:welcome];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(countTime) userInfo:nil repeats:YES];

}
/**
*   欢迎页展示后开始计时
*/
-(void)countTime{
    timeCount += 0.5 ;
}
-(void)missWelcome{
    [[MyUserDefault standardUserDefaults] setIsShowedWelcome:[NSNumber numberWithInt:0]];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view viewWithTag:90001].alpha = 0;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:90001] removeFromSuperview];
        
    }];
}
-(void)requestForWelCome{
    NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:sid,@"sid", nil];
    NSString *url =[NSString stringWithFormat:kUrlPre,kOnlineWeb,@"GoldWashingUI",@"GetWelcomeLogo"];
    [AsynURLConnection requestWithURL:url dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *body =[dic objectForKey:@"body"];
            NSLog(@"请求欢迎页 = %@",dic);
            if ([[dic objectForKey:@"flag"] intValue] ==1) {
                NSArray *arr =[body objectForKey:@"Welcome"];
                if (arr.count >0) {
                    NSDictionary *welDic =[arr objectAtIndex:0];
                    if (welDic.allKeys.count >0) {
                        [[MyUserDefault standardUserDefaults] setWelcomeImgDic:welDic];
                        NSString * pic =[welDic objectForKey:@"Pic1"];
                        if (kmainScreenHeigh <= 480) {
                            pic =[welDic objectForKey:@"Pic"];
                        }
//                        NSString *oldPicUrl =[[MyUserDefault standardUserDefaults] getWelcomeImgUrl];
//                        if (![pic isEqualToString:oldPicUrl] && [[MyUserDefault standardUserDefaults] getWelcomeImgData]) {
                            [[MyUserDefault standardUserDefaults] setWelcomeImgUrl:pic];
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSData *picData =[NSData dataWithContentsOfURL:[NSURL URLWithString:pic]];
                                if (picData) {
                                    NSLog(@" GET WelCome %ld",(unsigned long)picData.length);
                                    [[MyUserDefault standardUserDefaults] setWelcomeImgData:picData];
                                }
                            });
//                        }
                    }
                }else{
                    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:nil,@"Welcome", nil];
                    [[MyUserDefault standardUserDefaults] setWelcomeImgDic:dic];
                }
            }
        });
    } fail:^(NSError *error) {
        
    }];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
