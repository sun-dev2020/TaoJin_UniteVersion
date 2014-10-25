//
//  ShakeViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-5-24.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShakeViewController.h"
#import "HeadToolBar.h"
#import "UniversalTip.h"
#import "TaoJinLabel.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "StatusBar.h"
#import "NSString+IsEmply.h"
#import "MyUserDefault.h"
#import "LoadingView.h"
#import <CoreMotion/CoreMotion.h>

#define localSpace                                                  60.0f
#define animationTime                                               0.5f
#define animationCount                                              4
#define LotteryWithoutCount                                         @"做任务可获得更多抽奖机会"

@interface ShakeViewController (){
    UIView *backgroundView2;                                        //背景下半部分图
    TaoJinLabel *jinDouLab;                                         //获得的金豆
    NSMutableArray *shakeImgAry;                                    //摇一摇所有图片
    NSMutableArray *tipAry;                                         //tip文案
    
    CMMotionManager *motionManager;                                 //加速度仪
    UIImageView *shakeImgView;                                      //摇一摇的动态图
    UIView *backgroundView1;                                        //背景上半部分图
    
    NSTimer *timer;
    int shakeImgCount;                                              //
    
    
    int lotteryCount;                                               //每天抽奖次数
    int extraLotteryCount;                                          //完成任务额外抽奖次数
    int timeoutCount;                                               //超时次数
    
    BOOL isFristToZero;                                             //判断是否第一次到了次数0
    
    HeadToolBar *headView;
    UniversalTip *tipView;                                          //tip
    
    MScrollVIew *ms;
}

@end

@implementation ShakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initWithObjects{
    isFristToZero = YES;
    shakeImgCount = 1;
    shakeImgAry = [[NSMutableArray alloc] initWithCapacity:3];
//    [self initWithMotionManager];
}

-(void)initWithMotionManager{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.01;
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData* accelerometerData,NSError* error){
        CMAccelerometerData *newestAccel = motionManager.accelerometerData;
        if (newestAccel.acceleration.x > 2.0 || newestAccel.acceleration.x < -2.0 || newestAccel.acceleration.y > 2.0 || newestAccel.acceleration.y < -2.0 || newestAccel.acceleration.z > 2.0 || newestAccel.acceleration.z < -2.0) {
            if (motionManager ) {
                motionManager = nil;
                [self requestToYaoYiYao];
            }
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithObjects];
    
//	HeadToolBar *headView = [[HeadToolBar alloc] initWithTitle:@"摇一摇抽奖" leftBtnTitle:@"返回" leftBtnImg:[UIImage imageNamed:@"back"] leftBtnHighlightedImg:[UIImage imageNamed:@"back_sel"] rightLabTitle:nil backgroundColor:KRedColor2_0];
    headView = [[HeadToolBar alloc] initWithTitle:@"摇一摇抽奖" leftBtnTitle:@"返回" leftBtnImg:[UIImage imageNamed:@"back"] leftBtnHighlightedImg:[UIImage imageNamed:@"back_sel"] rightLabTitle:@"抽奖次数：" backgroundColor:KRedColor2_0];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y + headView.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headView.frame.size.height - headView.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    ms.msDelegate = self;
    ms.bounces = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -kmainScreenHeigh, kmainScreenWidth, kmainScreenHeigh)];
    view.backgroundColor = KRedColor2_0;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    [ms addSubview:view];
    
    [self.view addSubview:headView];
    headView.leftBtn.tag = 1;
    [headView.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headView];
    //背景上半部分图
    backgroundView1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 213.0f - headView.frame.origin.y - headView.frame.size.height + localSpace)];
    backgroundView1.backgroundColor = KRedColor2_0;
    [ms addSubview:backgroundView1];
    
    float y = backgroundView1.frame.origin.y + backgroundView1.frame.size.height - localSpace;
    //测试数据
    jinDouLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, y , kmainScreenWidth, localSpace) text:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter numberLines:1];
    [ms addSubview:jinDouLab];
    
    //背景下半部分图
    backgroundView2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, y, kmainScreenWidth, kmainScreenHeigh - backgroundView1.frame.size.height)];
    backgroundView2.backgroundColor = [UIColor whiteColor];
    [ms addSubview:backgroundView2];
    //摇一摇Logo动态图
    UIImage *shakeImg = [UIImage imageNamed:@"shake1"];
    shakeImgView = [[UIImageView alloc] initWithImage:shakeImg];
    shakeImgView.tag = 101;
    shakeImgView.frame = CGRectMake(kmainScreenWidth/2 - shakeImg.size.width/2, 20.0f, shakeImg.size.width, shakeImg.size.height);
    [ms addSubview:shakeImgView];
    
    for (int i = 1; i < 4; i ++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"shake%d.png",i]];
        [shakeImgAry addObject:image];
        if(i == 3){
            for(int j = 2; j > 0; j --){
                UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"shake%d.png",j]];
                [shakeImgAry addObject:image];
            }
        }
    }
    shakeImgView.animationImages = shakeImgAry;
    shakeImgView.animationDuration = animationTime;
    
    tipAry = [@[@"1.每日有1次免费抽奖机会，可通过做任务获得更多抽奖机会（完成一个任务获得一次抽奖机会）；", @"2.部分游戏 /应用包含多个任务，可获得多次抽奖机会；", @"3.抽中金豆奖励（ - 金豆）将直接充值到用户账户中；",@"4.该抽奖活动与苹果公司无关。"] mutableCopy];
    tipView = [[UniversalTip alloc] initWithFrame:CGRectMake(Spacing2_0, 10.0f, kmainScreenWidth - 2 * Spacing2_0, 0.0f) andTips:tipAry andTipBackgrundColor:kPinkColor2_0 withTipFont:[UIFont systemFontOfSize:11] andTipImage:[UIImage imageNamed:@"dengpao_red"] andTipTitle:@"摇一摇抽奖说明：" andTextColor:KRedColor2_0];
    [backgroundView2 addSubview:tipView];

    [self.view addSubview:ms];
    
    [self requestToUserYaoYiYao];
    //本地判断当天是否已经摇过
//    if([self judgeIsHaveYaoYiYao]){
//        backgroundView2.frame = CGRectMake(backgroundView2.frame.origin.x, backgroundView2.frame.origin.y + localSpace/2, backgroundView2.frame.size.width, backgroundView2.frame.size.height);
//        jinDouLab.frame = CGRectMake(jinDouLab.frame.origin.x, jinDouLab.frame.origin.y - localSpace/2, jinDouLab.frame.size.width, jinDouLab.frame.size.height);
//        jinDouLab.text = LotteryWithoutCount;
//    }
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [motionManager stopAccelerometerUpdates];
    motionManager = nil;
    
    [backgroundView2 removeFromSuperview];
    backgroundView2 = nil;
    [jinDouLab removeFromSuperview];
    jinDouLab = nil;
    [shakeImgAry removeAllObjects];
    shakeImgAry = nil;
    [tipAry removeAllObjects];
    tipAry = nil;
    [shakeImgView removeFromSuperview];
    shakeImgView = nil;
    [backgroundView1 removeFromSuperview];
    backgroundView1 = nil;
    [timer invalidate];
    timer = nil;
    [headView removeFromSuperview];
    headView = nil;
    [tipView removeFromSuperview];
    tipView = nil;
    [ms removeFromSuperview];
    ms = nil;
}

/**
 *  定时计算动画运行的次数
 */
-(void)shakeImgTimer{
    shakeImgCount ++;
    if(shakeImgCount >= animationCount){
        [shakeImgView stopAnimating];
        [timer invalidate];
    }
}

/**
 *  开始摇一摇的动画效果
 */
-(void)startImageAnimation{
    [shakeImgView startAnimating];
    timer = [NSTimer scheduledTimerWithTimeInterval:animationTime target:self selector:@selector(shakeImgTimer) userInfo:nil repeats:YES];
}

/**
 *  显示摇一摇的结果
 */
-(void)startShowResultWithDelay:(float)delay{
    [UIView animateWithDuration:0.8f
                          delay:delay
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         backgroundView2.frame = CGRectMake(backgroundView2.frame.origin.x, backgroundView2.frame.origin.y + localSpace, backgroundView2.frame.size.width, backgroundView2.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if(finished){
                             [UIView animateWithDuration:0.8f
                                                   delay:0
                                                 options:(UIViewAnimationOptionAllowUserInteraction|
                                                          UIViewAnimationOptionBeginFromCurrentState)
                                              animations:^(void) {
                                                  backgroundView2.frame = CGRectMake(backgroundView2.frame.origin.x, backgroundView2.frame.origin.y - localSpace/2, backgroundView2.frame.size.width, backgroundView2.frame.size.height);
                                                  jinDouLab.frame = CGRectMake(jinDouLab.frame.origin.x, jinDouLab.frame.origin.y - localSpace/2, jinDouLab.frame.size.width, jinDouLab.frame.size.height);
                                              }
                                              completion:^(BOOL finished) {
                                                  if(finished){
                                                      if(lotteryCount + extraLotteryCount > 0){
                                                           [self initWithMotionManager];
                                                      }else{
                                                          if(isFristToZero){
                                                              //当次数由1变为0时，可以摇多一次效果，之后就没有
                                                              [self initWithMotionManager];
                                                              isFristToZero = NO;
                                                          }
                                                      }
                                                  }
                                              }];
                         }
                     }];
}

- (void)onClickBackBtn:(UIButton* )btn{
    switch (btn.tag) {
            //返回按钮
        case 1:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

/**
 *  请求用户摇一摇的初始信息
 */
-(void)requestToUserYaoYiYao{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"GetYaoInfo"];
    NSLog(@"请求用户摇一摇的初始信息【url】= %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求用户摇一摇的初始信息【response】= %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            timeoutCount = 0;
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                //每天抽奖次数
                lotteryCount = [[body objectForKey:@"FNum"] intValue];
                //完成任务额外抽奖次数
                extraLotteryCount = [[body objectForKey:@"MNum"] intValue];
                //奖金范围
                NSString *goldRange = [body objectForKey:@"GoldRange"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    [headView setRightLabText:[NSString stringWithFormat:@"抽奖次数：%d",(lotteryCount + extraLotteryCount)]];
                    [tipAry replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"3.抽中金豆奖励（%@金豆）将直接充值到用户账户中；",goldRange]];
                    [tipView uploadTipContent:tipAry andFont:[UIFont systemFontOfSize:11] andTextColor:KRedColor2_0 needAdjustPosition:NO];
                    if(lotteryCount + extraLotteryCount > 0){
                        [self initWithMotionManager];
                    }else{
                        isFristToZero = NO;
                        jinDouLab.text = LotteryWithoutCount;
                        [self startShowResultWithDelay:0.0f];
                    }
                    
                    float height = ms.frame.size.height + tipView.frame.size.height - (ms.frame.size.height - tipView.frame.origin.y) + 10.0f + (64.0f - ms.frame.origin.y);
                    height = height > ms.frame.size.height ? height : ms.frame.size.height + 1;
                    [ms setContentSize:CGSizeMake(kmainScreenWidth, height)];
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeoutCount <= 2){
                timeoutCount ++;
                [self requestToUserYaoYiYao];
            }else{
                [StatusBar showTipMessageWithStatus:@"网络异常，请稍后再试！" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
            }
        }
    }];
}

//请求发送摇一摇（new）
-(void)requestToYaoYiYao{
    shakeImgCount = 1;
    int y = backgroundView1.frame.origin.y + backgroundView1.frame.size.height - localSpace;
    backgroundView2.frame = CGRectMake(0.0f, y, kmainScreenWidth, kmainScreenHeigh - backgroundView1.frame.size.height);
    jinDouLab.frame = CGRectMake(0.0f, y , kmainScreenWidth, localSpace);
    jinDouLab.text = @"";
    [self startImageAnimation];
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    int random = arc4random() % 100000;
    NSDictionary *dic = @{@"sid": sid, @"time": [NSNumber numberWithInt:random]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"JoinYaoyao"];
    NSLog(@"请求摇一摇【url】= %@",urlStr);
    NSLog(@"shakeImgCount = %d",shakeImgCount);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求摇一摇【response】= %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                //每天抽奖次数
                lotteryCount = [[body objectForKey:@"FNum"] intValue];
                //完成任务额外抽奖次数
                extraLotteryCount = [[body objectForKey:@"MNum"] intValue];
                //奖励金豆
                int gold = [[body objectForKey:@"Gold"] intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[MyUserDefault standardUserDefaults] setYaoYiYaoDateStr:[self getNowDate]];
                    [headView setRightLabText:[NSString stringWithFormat:@"抽奖次数：%d",(lotteryCount + extraLotteryCount)]];
                    if(gold > 0){
                        jinDouLab.text = [NSString stringWithFormat:@"恭喜摇中 %d金豆",gold];
                    }else {
                        jinDouLab.text = LotteryWithoutCount;
                    }
                    if(shakeImgCount >= animationCount){
                        [self startShowResultWithDelay:0.0f];
                    }else{
                        [self startShowResultWithDelay:(animationCount - shakeImgCount) * animationTime];
                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    jinDouLab.text = LotteryWithoutCount;
                    if(shakeImgCount >= animationCount){
                        [self startShowResultWithDelay:0.0f];
                    }else{
                        [self startShowResultWithDelay:(animationCount - shakeImgCount) * animationTime];
                    }
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            //连接超时
            [StatusBar showTipMessageWithStatus:@"网络异常，请稍后再试！" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
            [shakeImgView stopAnimating];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

/**
 *  判断当天是否已经摇过
 *
 */
-(BOOL)judgeIsHaveYaoYiYao{
    NSString *nowDate = [self getNowDate];
    NSString *yaoYiYaoDateStr = [[MyUserDefault standardUserDefaults] getYaoYiYaoDateStr];
    if([NSString isEmply:yaoYiYaoDateStr])
        return NO;
    if(![nowDate isEqualToString:yaoYiYaoDateStr]){
        return NO;
    }else{
        return YES;
    }
}

/**
 *  获取当前日期
 *
 */
-(NSString *)getNowDate{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [motionManager stopAccelerometerUpdates];
}

@end
