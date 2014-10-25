//
//  GuessViewController.m
//  91TaoJin
//
//  Created by keyrun on 14-5-24.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "GuessViewController.h"
#import "HeadToolBar.h"
#import "TaoJinLabel.h"
#import "TaoJinButton.h"
#import "UIImage+ColorChangeTo.h"
#import "UniversalTip.h"
#import "MyUserDefault.h"
#import "Guess.h"
#import "AsynURLConnection.h"
#import "LoadingView.h"
#import "StatusBar.h"
#import "UIImage+ColorChangeTo.h"
#import "MyUserDefault.h"

#define buttonWidth                                         46
#define buttonHeight                                        40

@interface GuessViewController (){
    TaoJinLabel *remainLab;                                 //提醒文案
    TaoJinLabel *timeLab;                                   //倒计时
    TaoJinLabel *joinNumLab;                                //参与人数
    TaoJinLabel *jindouNumLab;                              //投注池的金豆数量
    TaoJinButton *betsBtn;                                  //投注按钮
    NSMutableArray *btnAry;                                 //所有按钮
    int oldBtnTag;                                          //上一次选中的按钮标识
    UIImageView *winPrizeImgView;                           //提示中奖还未中奖
    
    
    BOOL isWin;                                             //是否获奖
    BOOL isFrist;                                           //是否第一次加载数据
    int timeOutCount;                                       //超时次数
    int localBetsNum;                                       //本地投注的号码
    Guess *guess;                                           //竞猜对象
    HeadToolBar *headView;
    
    NSMutableArray *tipAry;                                 //tip内容数组
    UniversalTip *tipView;
    
    MScrollVIew *ms;
}

@end

@implementation GuessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initWithObjects{
    oldBtnTag = -1;
    localBetsNum = -1;
    btnAry = [[NSMutableArray alloc] initWithCapacity:9];
    timeOutCount = 0;
    isWin = NO;
    isFrist = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithObjects];
//	headView = [[HeadToolBar alloc] initWithTitle:@"乐透竞猜" leftBtnTitle:@"返回" leftBtnImg:[UIImage imageNamed:@"back"] leftBtnHighlightedImg:[UIImage imageNamed:@"back_sel"] rightLabTitle:@"上轮开奖：" backgroundColor:KOrangeColor2_0];
    headView = [[HeadToolBar alloc] initWithTitle:@"乐透竞猜" leftBtnTitle:@"返回" leftBtnImg:[UIImage imageNamed:@"back"] leftBtnHighlightedImg:[UIImage imageNamed:@"back_sel"] rightBtnTitle:@"上轮开奖：" rightBtnImg:nil rightBtnHighlightedImg:[UIImage createImageWithColor:KLightOrangeColor2_0] backgroundColor:KOrangeColor2_0];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y + headView.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headView.frame.size.height - headView.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    ms.msDelegate = self;
    ms.bounces = YES;
    ms.scrollEnabled = YES;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, -kmainScreenHeigh, kmainScreenWidth, kmainScreenHeigh)];
    view.backgroundColor = KOrangeColor2_0;
    [ms addSubview:view];
    
    [headView.rightBtn addTarget:self action:@selector(showAlertView:) forControlEvents:UIControlEventTouchUpInside];
    headView.leftBtn.tag = 1;
    [headView.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headView];
    //背景上半部分图
    UIView *backgroundView1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 213.0f - headView.frame.origin.y - headView.frame.size.height)];
    backgroundView1.backgroundColor = KOrangeColor2_0;
    [ms addSubview:backgroundView1];
    //球
    UIImage *ballImg = [UIImage imageNamed:@"ball"];
    UIImageView *ballImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kmainScreenWidth/2 - ballImg.size.width/2, 0.0f , ballImg.size.width, ballImg.size.height)];
    ballImgView.image = ballImg;
    [ms addSubview:ballImgView];
    //提示上轮是否已经中奖
    UIImage *winPrizeImg = [UIImage imageNamed:@"prize_defult"];
    winPrizeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kmainScreenWidth - Spacing2_0 - winPrizeImg.size.width, ballImgView.frame.origin.y, winPrizeImg.size.width, winPrizeImg.size.height)];
    winPrizeImgView.userInteractionEnabled = YES;
    winPrizeImgView.image = winPrizeImg;
    [ms addSubview:winPrizeImgView];
    
    //单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertView:)];
    tap.numberOfTouchesRequired = 1; // 单击
    tap.numberOfTapsRequired = 1;
    [winPrizeImgView addGestureRecognizer:tap];
    
    //金豆数量
    jindouNumLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(ballImgView.frame.origin.x, ballImgView.frame.origin.y + ballImgView.frame.size.height/2 - 15.0f, ballImgView.frame.size.width, 24.0f) text:@"" font:[UIFont boldSystemFontOfSize:20.0f] textColor:kDrakRedColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1];
    [ms addSubview:jindouNumLab];
    TaoJinLabel *jindouLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(ballImgView.frame.origin.x, jindouNumLab.frame.origin.y + jindouNumLab.frame.size.height, ballImgView.frame.size.width, 24.0f) text:@"金豆" font:[UIFont systemFontOfSize:20] textColor:kDrakRedColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1];
    [ms addSubview:jindouLab];
    //底座
    UIImage *baseImg = [UIImage imageNamed:@"base"];
    UIImageView *baseImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kmainScreenWidth/2 - baseImg.size.width/2, ballImgView.frame.origin.y + ballImgView.frame.size.height , baseImg.size.width, baseImg.size.height)];
    baseImgView.image = baseImg;
    [ms addSubview:baseImgView];
    //提示文案（距离本轮竞猜结束）
    remainLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, baseImgView.frame.origin.y + baseImgView.frame.size.height + 10.0f, 180.0f, 15.0f) text:@"距离本轮竞猜结束" font:[UIFont boldSystemFontOfSize:11] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentRight numberLines:1];
    [ms addSubview:remainLab];
    //倒计时时间
    timeLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(remainLab.frame.origin.x + remainLab.frame.size.width + 3.0f, remainLab.frame.origin.y, 100.0f, remainLab.frame.size.height) text:@"" font:[UIFont boldSystemFontOfSize:11] textColor:KRedColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
    [ms addSubview:timeLab];
    //参与人数
    joinNumLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, remainLab.frame.origin.y + remainLab.frame.size.height + 3.0f, kmainScreenWidth, 15.0f) text:@"" font:[UIFont boldSystemFontOfSize:11] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1];
    [ms addSubview:joinNumLab];
    //10个数字按钮
    for(int i = 0 ; i < 2; i ++){
        for(int j = 0 ; j < 5; j ++){
            int index = 5 * i + j;
            TaoJinButton *button = [[TaoJinButton alloc] initWithFrame:CGRectMake(32.0f + buttonWidth * j + Spacing2_0 * j, joinNumLab.frame.origin.y + joinNumLab.frame.size.height + 9.0 + buttonHeight * i + 6.0 * i, buttonWidth, buttonHeight) titleStr:[NSString stringWithFormat:@"%d",index] titleColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:26] logoImg:nil backgroundImg:[UIImage imageNamed:@"guessNum_normal"]];
            [button setBackgroundImage:[UIImage imageNamed:@"guessNum_normal"] forState:UIControlStateDisabled];
            [button setBackgroundImage:[UIImage imageNamed:@"guessNum_selected"] forState:UIControlStateHighlighted];
            [button setTitleColor:KBlockColor2_0 forState:UIControlStateHighlighted];
            button.tag = index;
            button.enabled = NO;
            [button addTarget:self action:@selector(chooseNumAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(chooseNumAction2:) forControlEvents:UIControlEventTouchUpOutside];
            [btnAry addObject:button];
            [ms addSubview:button];
        }
    }
    //投注按钮
    betsBtn= [[TaoJinButton alloc] initWithFrame:CGRectMake(Spacing2_0, joinNumLab.frame.origin.y + joinNumLab.frame.size.height + 9.0 + buttonHeight * 2 + 6.0 + 9.0, kmainScreenWidth - 2 * Spacing2_0, 40.0f) titleStr:@"请选择投注号码" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] logoImg:nil backgroundImg:[UIImage createImageWithColor:KGreenColor2_0]];
    [betsBtn setBackgroundImage:[UIImage createImageWithColor:KGreenColor2_0] forState:UIControlStateDisabled];
    [betsBtn addTarget:self action:@selector(betsAction:) forControlEvents:UIControlEventTouchUpInside];
    [betsBtn setBackgroundImage:[UIImage createImageWithColor:KLightGreenColor2_0] forState:UIControlStateHighlighted];
    betsBtn.enabled = NO;
    [ms addSubview:betsBtn];
    //Tip
    tipAry = [@[@"1.账户金豆余额大于  即可参与竞猜；",@"2.每轮从0-9之间选一个号码进行押注，押注需花费  金豆；",@"3.开奖号码为当天福彩3D开奖的最后一位；",@"猜中奖金=奖池金豆/2/中奖人数；",@"4.该竞猜活动与苹果公司无关。"] mutableCopy];
    tipView = [[UniversalTip alloc] initWithFrame:CGRectMake(Spacing2_0, betsBtn.frame.origin.y + betsBtn.frame.size.height + 10.0f, kmainScreenWidth - 2 * Spacing2_0, 0.0f) andTips:tipAry andTipBackgrundColor:kLightYellow2_0 withTipFont:[UIFont systemFontOfSize:11] andTipImage:[UIImage imageNamed:@"dengpao_orange"] andTipTitle:@"竞猜说明：" andTextColor:KOrangeColor2_0];
    [ms addSubview:tipView];
    [self.view addSubview:ms];
    
    [self requestToGetGuessMessage];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [remainLab removeFromSuperview];
    remainLab = nil;
    [timeLab removeFromSuperview];
    timeLab = nil;
    [joinNumLab removeFromSuperview];
    joinNumLab = nil;
    [jindouNumLab removeFromSuperview];
    jindouNumLab = nil;
    [betsBtn removeFromSuperview];
    betsBtn = nil;
    [btnAry removeAllObjects];
    btnAry = nil;
    [winPrizeImgView removeFromSuperview];
    winPrizeImgView = nil;
    [headView removeFromSuperview];
    headView = nil;
    [tipAry removeAllObjects];
    tipAry = nil;
    [tipView removeFromSuperview];
    tipView  = nil;
    [ms removeFromSuperview];
    ms = nil;
    
    guess = nil;
}

/**
 *  数字按钮的点击事件
 *
 */
-(void)chooseNumAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    localBetsNum = button.tag;
    [self performSelector:@selector(setButtonHight:) withObject:button afterDelay:0.0];
}

-(void)chooseNumAction2:(id)sender{
    localBetsNum = -1;
    for(UIButton *btn in btnAry){
        if(btn.highlighted){
            localBetsNum = btn.tag;
            break;
        }
    }
    if(localBetsNum == -1){
        [betsBtn setTitle:@"请选择投注号码" forState:UIControlStateNormal];
    }
}

/**
 *  设置按钮高亮
 *
 */
-(void)setButtonHight:(UIButton *)button{
    if(oldBtnTag != button.tag){
        if(oldBtnTag > -1){
            UIButton *oldBtn = [btnAry objectAtIndex:oldBtnTag];
            [oldBtn setHighlighted:NO];
        }
        oldBtnTag = button.tag;
    }
    [betsBtn setTitle:@"选择该号码进行投注" forState:UIControlStateNormal];
    [button setHighlighted:YES];
}

/**
 *  设置投注号码高亮且所有按钮没有点击效果
 *
 *  @param betsNum 投注的号码
 */
-(void)setButtonUnEnableWithoutBetsButton:(int)betsNum{
    for(int i = 0 ; i < btnAry.count ; i ++){
        UIButton *button = [btnAry objectAtIndex:i];
        [button setEnabled:NO];
        if(i == betsNum){
            [button setBackgroundImage:[UIImage imageNamed:@"guessNum_selected"] forState:UIControlStateDisabled];
            [button setTitleColor:KBlockColor2_0 forState:UIControlStateDisabled];
        }
    }
}

/**
 *  倒计时
 *
 *  @param time 距离时间（服务器）
 */
-(void)timeToCountdown:(NSTimeInterval)time{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束
            dispatch_source_cancel(_timer);
//            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                remainLab.text = @"已截止投注，";
                remainLab.frame = CGRectMake(remainLab.frame.origin.x, remainLab.frame.origin.y, remainLab.frame.size.width - 10.0f, remainLab.frame.size.height);
                timeLab.text = @"等待开奖";
                timeLab.frame = CGRectMake(remainLab.frame.origin.x + remainLab.frame.size.width, timeLab.frame.origin.y, timeLab.frame.size.width, timeLab.frame.size.height);
                if(guess.guess_betsNum == -1){
                    [betsBtn setTitle:@"本轮未投注" forState:UIControlStateDisabled];
                    [betsBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateDisabled];
                    [betsBtn setTitleColor:KGreenColor2_0 forState:UIControlStateDisabled];
                    [self setButtonUnEnableWithoutBetsButton:-1];
                }
                betsBtn.enabled = NO;
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                int hour = timeout / 3600;
                int minutes = (timeout % 3600) / 60;
                int seconds = (timeout % 3600) % 60;
                NSString *hoursStr = hour < 10 ? [NSString stringWithFormat:@"0%d",hour] : [NSString stringWithFormat:@"%d",hour];
                NSString *minutesStr = minutes < 10 ? [NSString stringWithFormat:@"0%d",minutes] : [NSString stringWithFormat:@"%d",minutes];
                NSString *secondsStr = seconds < 10 ? [NSString stringWithFormat:@"0%d",seconds] : [NSString stringWithFormat:@"%d",seconds];
                timeLab.text = [NSString stringWithFormat:@"%@:%@:%@",hoursStr, minutesStr, secondsStr];
            });
            timeout --;
        }  
    });  
    dispatch_resume(_timer);
}

/**
 *  改变中奖图片
 *
 *  @param lastBets   上一轮的投注号码
 *  @param lastResult 上一轮的开奖结果
 */
-(void)changePrizeImg:(int)lastBets lastResult:(int)lastResult{
    if(lastBets == -1)
        isWin = NO;
    else{
        if(lastBets == lastResult)
            isWin = YES;
        else
            isWin = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        winPrizeImgView.alpha -= 1.0;
    } completion:^(BOOL finished) {
        if(finished){
            if(!isWin){
                winPrizeImgView.image = [UIImage imageNamed:@"prize_unwin"];
            }else {
                winPrizeImgView.image = [UIImage imageNamed:@"prize_win"];
            }
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.5];
            winPrizeImgView.alpha = 1.0;
            [UIView commitAnimations];
        }
    }];
}

/**
 *  查看中奖详情
 *
 */
-(void)showAlertView:(UITapGestureRecognizer *)sender{
    NSString *text = [NSString stringWithFormat:@"开奖号码：%@\n您的竞猜：%@\n共发金豆：%@（%@人平分）\n您获金豆：%@",
            [guess.guess_lastMessageDic objectForKey:@"LResult"],
            [[guess.guess_lastMessageDic objectForKey:@"LBets"] intValue] == -1 ? @"-" : [guess.guess_lastMessageDic objectForKey:@"LBets"],
            [guess.guess_lastMessageDic objectForKey:@"LGold"],
            [guess.guess_lastMessageDic objectForKey:@"LNum"],
            [[guess.guess_lastMessageDic objectForKey:@"LWinGold"] intValue] == 0 ? @"-" : [guess.guess_lastMessageDic objectForKey:@"LWinGold"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"上期竞猜详情" message:text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
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
 *  请求获取竞猜信息
 */
-(void)requestToGetGuessMessage{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"GetGuessGoldInfo"];
    NSLog(@"请求获取竞猜信息【urlStr】 = %@",urlStr);
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid":sid};
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"请求获取竞猜信息【response】 = %@   %@",dataDic ,str);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            timeOutCount = 0;
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                guess = [[Guess alloc] initWithLastMessage:[body objectForKey:@"LastLty"] goldLimit:[[body objectForKey:@"GoldLimit"] intValue] goldNum:[[body objectForKey:@"BetsGold"] intValue] goldAllNum:[[body objectForKey:@"Gold"] intValue] personNum:[[body objectForKey:@"Num"] intValue] time:[[body objectForKey:@"Time"] intValue] betsNum:[[body objectForKey:@"Bets"] intValue]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    [self timeToCountdown:guess.guess_time];
                    jindouNumLab.text = [NSString stringWithFormat:@"%d",guess.guess_goldAllNum];
                    joinNumLab.text = [NSString stringWithFormat:@"%d人参与",guess.guess_personNum];
//                    [headView setRightLabText:[NSString stringWithFormat:@"上轮开奖：%@",[guess.guess_lastMessageDic objectForKey:@"LResult"]]];
                    [headView.rightBtn setTitle:[NSString stringWithFormat:@"上轮开奖：%@",[guess.guess_lastMessageDic objectForKey:@"LResult"]] forState:UIControlStateNormal];
                    [headView.rightBtn sizeToFit];
                    headView.rightBtn.frame = CGRectMake(kmainScreenWidth - headView.rightBtn.frame.size.width - 10 - Spacing2_0, headView.rightBtn.frame.origin.y, headView.rightBtn.frame.size.width + 10, kHeadViewHeigh);
                    [self changePrizeImg:[[guess.guess_lastMessageDic objectForKey:@"LBets"] intValue] lastResult:[[guess.guess_lastMessageDic objectForKey:@"LResult"] intValue]];
                    if(guess.guess_betsNum != -1){
                        [self setButtonUnEnableWithoutBetsButton:guess.guess_betsNum];
                        betsBtn.enabled = NO;
                        [betsBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateDisabled];
                        [betsBtn setTitleColor:KGreenColor2_0 forState:UIControlStateDisabled];
                        [betsBtn setTitle:[NSString stringWithFormat:@"您本轮投注的号码：%d",guess.guess_betsNum] forState:UIControlStateDisabled];
                    }else{
                        for (UIButton *button in btnAry) {
                            button.enabled = YES;
                        }
                        betsBtn.enabled = YES;
                    }
//                    tipAry = [@[@"1.账户金豆余额大于  即可参与竞猜；",@"2.每轮从0-9之间选一个号码进行押注，押注需花费  金豆；",@"3.开奖号码为当天福彩3D开奖的最后一位；",@"猜中奖金=奖池金豆/2/中奖人数。"] mutableCopy];
                    [tipAry replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"1.账户金豆余额大于%d即可参与竞猜；",[[body objectForKey:@"GoldLimit"] intValue]]];
                    [tipAry replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"2.每轮从0-9之间选一个号码进行押注，押注需花费%d金豆；",[[body objectForKey:@"BetsGold"] intValue]]];
                    [tipView uploadTipContent:tipAry andFont:[UIFont systemFontOfSize:11] andTextColor:KOrangeColor2_0 needAdjustPosition:NO];
                    
                    float height = ms.frame.size.height + tipView.frame.size.height - (ms.frame.size.height - tipView.frame.origin.y) + 10.0f + (64.0f - ms.frame.origin.y);
                    height = height > ms.frame.size.height ? height : ms.frame.size.height + 1;
                    [ms setContentSize:CGSizeMake(kmainScreenWidth, height)];
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"请求获取竞猜信息【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToGetGuessMessage];
            }else{
                timeOutCount = 0;
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}

/**
 *  发送投注的按钮事件
 *
 */
-(void)betsAction:(UIButton *)button{
    
    if(localBetsNum == -1){
        //还没选择投注号码
        [StatusBar showTipMessageWithStatus:@"请先选择投注号码" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
    }else{
        //发送投注
        int userGoldNum = [[[MyUserDefault standardUserDefaults] getUserBeanNum] intValue];
        if(userGoldNum < guess.guess_goldLimit){
//            [StatusBar showTipMessageWithStatus:[NSString stringWithFormat:@"金豆需大于%d才能投注",guess.guess_goldLimit] andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"账户金豆大于%d即可参与竞猜",guess.guess_goldLimit] message:[NSString stringWithFormat:@"您的账户金豆为%d；\n可通过做任务、邀请好友、参与活动等方式赚取金豆；\n是否立即做任务赚金豆？",userGoldNum] delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚金豆", nil];
            [alertView show];
        }else{
            [self requestToBets:localBetsNum];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"goBackToTaojin" object:nil userInfo:nil];
    }
}

/**
 *  请求发送投注信息
 *
 *  @param betsNum 投注号码
 */
-(void)requestToBets:(int )betsNum{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"JoinGuessGold"];
    NSLog(@"请求发送投注信息【urlStr】 = %@",urlStr);
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid":sid, @"Bets":[NSString stringWithFormat:@"%d",betsNum]};
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求发送投注信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                int status = [[body objectForKey:@"status"] intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    if(status == 0){
                        //投注失败，重新同步竞猜信息
                        [self requestToGetGuessMessage];
                        localBetsNum = -1;
                        [StatusBar showTipMessageWithStatus:@"投注失败" andImage:[UIImage imageNamed:@"laba.png"] andTipIsBottom:YES];
                    }else{
                        //投注成功
                        [self setButtonUnEnableWithoutBetsButton:betsNum];
                        guess.guess_betsNum = betsNum;
                        betsBtn.enabled = NO;
                        int personNum = guess.guess_personNum + 1;
                        joinNumLab.text = [NSString stringWithFormat:@"%d人参与",personNum];
                        [betsBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateDisabled];
                        [betsBtn setTitleColor:KGreenColor2_0 forState:UIControlStateDisabled];
                        [betsBtn setTitle:[NSString stringWithFormat:@"您本轮投注的号码：%d",betsNum] forState:UIControlStateDisabled];
                    }
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"请求发送投注信息【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToBets:betsNum];
            }else{
                timeOutCount = 0;
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end










