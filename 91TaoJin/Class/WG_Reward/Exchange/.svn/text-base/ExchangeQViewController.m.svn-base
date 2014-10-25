//
//  ExchangeQViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "ExchangeQViewController.h"
#import "RewardListViewController.h"
#import "TJViewController.h"
#import "StatusBar.h"
#import "LoadingView.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "CButton.h"
#import "UniversalTip.h"
//Q币支付
@interface ExchangeQViewController ()
{
    //    HeadView *headView;
    HeadToolBar *headBar;
    UIImageView *QQNumber;                          //qq号码输入框背景
    UILabel *Qcount ;
    UITextField *QQText;
    MScrollVIew *ms;
    
    int perRmb;
    
    int QBcount;                                    //q币数值
    
    int timeOutCount;                               //超时次数
    BOOL isFrist;                                   //标示是否第一次访问
    
    UIView *bgView;
    NSMutableArray *allBtns;
    NSArray *chooseArr;                             // Q币选择
    CButton *chagreBtn;                             //兑换按钮
    NSArray *coinCount;
    int selectBtnIndex;                             //标记选中的按钮
}
@end

@implementation ExchangeQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)hidKeyBoard{
    [QQText resignFirstResponder];
}

//初始化变量
-(void)initWithObjects{
    QBcount = 1;
    perRmb = 0;
    timeOutCount = 0;
    isFrist = YES;
    allBtns =[[NSMutableArray alloc] init];
    chooseArr =@[@"Q币1个",@"Q币10个",@"Q币30个",@"Q币50个"];
    coinCount =@[@"1",@"10",@"30",@"50"];
    selectBtnIndex =0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithObjects];
    
    //    if (IOS_Version >= 7.0) {
    //        UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 20)];
    //        view.backgroundColor = [UIColor blackColor];
    //        [self.view addSubview:view];
    //    }
    self.view.backgroundColor = [UIColor whiteColor];
    NSNumber *jdCount =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    
    headBar =[[HeadToolBar alloc] initWithTitle:@"Q币兑换" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:jdCount backgroundColor:KOrangeColor2_0];
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.size.height - headBar.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    ms.msDelegate = self;
    ms.bounces =YES;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    
    bgView =[[UIView alloc]init];
    bgView.backgroundColor =KRedColor2_0;
    
    [self loadViewChooseBtn];
    
    
    QQText =[ [UITextField alloc]initWithFrame:CGRectMake(18, 130, 300,15)];
    QQText.backgroundColor = [UIColor clearColor];
    QQText.font = [UIFont systemFontOfSize:14];
    QQText.delegate = self;
    [QQText setKeyboardType:UIKeyboardTypeNumberPad];
    QQText.placeholder = @"请输入您的QQ号码";
    QQText.textColor = KBlockColor2_0;
    QQText.text = [[MyUserDefault standardUserDefaults] getUserQNum];
    
    [self loadSperateLineWithFrame:CGRectMake(kOffX_float, QQText.frame.origin.y +QQText.frame.size.height+ 15, 320 -kOffX_float, 0.5f)];
    
    chagreBtn= [self loadBtnWithFrame:CGRectMake(kOffX_float, QQText.frame.origin.y +QQText.frame.size.height +25, 320 -2*(kOffX_float), 40) withTitle:@"立即兑换" andFont:[UIFont systemFontOfSize:16.0]];
    chagreBtn.tag =2;
    [chagreBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ms addSubview:chagreBtn];
    [self.view addSubview:ms];

    
    
    [self.view addSubview:ms];
    [ms addSubview:QQText];
    
    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,320 -2*(kOffX_float), 0)];
   [self performSelector:@selector(requestToGoodsInfo) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidKeyBoard) name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(qDidPopView) name:@"popview" object:nil];
}

-(CButton *)loadBtnWithFrame:(CGRect)rect withTitle:(NSString *)title andFont:(UIFont*) font{
    CButton *btn =[CButton buttonWithType:UIButtonTypeCustom];
    btn.frame =rect;
    btn.backgroundColor  =KGreenColor2_0;
    btn.nomalColor =KGreenColor2_0;
    btn.changeColor =kSelectGreen;
    btn.titleLabel.font =font;
    [btn setTitle:title forState:UIControlStateNormal];
    
    
    return btn;
}


-(void)loadSperateLineWithFrame:(CGRect)rect{
    UIView *line =[[UIView alloc]initWithFrame:rect];
    line.backgroundColor =kGrayLineColor2_0;
    [ms addSubview:line];
}

-(void)loadViewChooseBtn{
    for(int i = 0 ; i < 2 ; i ++){
        for(int j = 0 ; j < 2 ; j ++){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kOffX_float + j * 150 + j * 6, 52.5 * i + 7.5, 150, 45);
            button.tag = 2 * i + j;
            
            if (button.tag == 0) {
                
                bgView.frame =button.frame;
                [ms addSubview:bgView];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }else{
                [button setTitleColor:KRedColor2_0 forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(onClickRewardCoinBtn:) forControlEvents:UIControlEventTouchUpInside];
            NSString *titleBtn = [chooseArr objectAtIndex:button.tag];
            [button setTitle:titleBtn forState:UIControlStateNormal];
            button.titleLabel.font =[UIFont systemFontOfSize:14.0];
            [self addLineForUi:button withRed:209.0 withGreen:209.0 withBlue:209.0];
            [allBtns addObject:button];
            [ms addSubview:button];
        }
    }
    
}
-(void)onClickRewardCoinBtn:(UIButton *)btn{
    bgView.frame =btn.frame;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectBtnIndex =btn.tag;
    for (UIButton *button in allBtns) {
        if (button.tag != btn.tag) {
            
            [button setTitleColor:KRedColor2_0 forState:UIControlStateNormal];
            
        }
    }
    
}
// 按钮四边线
-(void)addLineForUi:(UIView *)obj withRed:(float)red withGreen:(float)green withBlue:(float)blue{
    CGFloat r = red/255.0;
    CGFloat g = green/255.0;
    CGFloat b = blue/255.0;;
    CGFloat a = 1;
    CGFloat com[4] = {r,g,b,a};
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = (__bridge CGColorRef)(__bridge id)CGColorCreate(colorspace, com);
    [obj.layer setBorderColor:color];
    [obj.layer setBorderWidth:.5f];
    CGColorRelease(color);
    CGColorSpaceRelease(colorspace);
    
}

-(void)viewDisappear:(BOOL)animated{
    [QQText removeFromSuperview];
    QQText = nil;
    [QQNumber removeFromSuperview];
    QQNumber = nil;
    [Qcount removeFromSuperview];
    Qcount = nil;
    [ms removeFromSuperview];
    ms = nil;
    //    [headView removeFromSuperview];
    //    headView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popview" object:nil];
}

-(void)initContentText:(NSString *)content{
  /*
    UIWebView *web = [[UIWebView alloc]init];
    [web loadHTMLString:content baseURL:nil];
    web.frame = CGRectMake(5, QQNumber.frame.origin.y + QQNumber.frame.size.height + 5, 310, 0);
    web.delegate = self;
    web.backgroundColor = [UIColor clearColor];
    web.scrollView.backgroundColor = [UIColor clearColor];
    [web setScalesPageToFit:NO];
    web.userInteractionEnabled =NO;
    [ms addSubview:web];
   */
    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,320 -2*(kOffX_float), 0)];
}

-(void)loadUniversalTipWithFrame:(CGRect)rect {
     NSNumber *number = [[MyUserDefault standardUserDefaults] getUserBeanNum];
    int count =0;
    if (perRmb !=0) {
        count =[number intValue] /perRmb;
    }
    NSString *first =[NSString stringWithFormat:@"1.%d金豆=1Q币，%d金豆=10Q币，%d金豆=30Q币，%d金豆=50Q币；",perRmb,perRmb*10,perRmb *30,perRmb*50];
    NSString *second =[NSString stringWithFormat:@"2.您的账户现在有：%@金豆，最多可兑换%d个Q币；",number,count];
    NSString *thrid =[NSString stringWithFormat:@"3.请确保您的QQ号码是正确的，否则将无法兑换成功；"];
    NSString *four =[NSString stringWithFormat:@"4.兑换后需1~2个工作日的审核时间，审核成功后会自动为您的QQ充值，请注意查收；"];
    NSString *five =[NSString stringWithFormat:@"5.该奖品由91淘金提供，与苹果公司无关。"];
    NSArray *arraytip =[NSArray arrayWithObjects:first,second,thrid,four, five,nil];
    UniversalTip *tip =[[UniversalTip alloc]initWithFrame:rect andTips:arraytip andTipBackgrundColor:KTipBackground2_0 withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImage(@"tips_3.png") andTipTitle:@"兑换说明：" andTextColor:KOrangeColor2_0];
    [ms addSubview:tip];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [[LoadingView showLoadingView] actViewStopAnimation];
}

//请求获取四种支付手段的详细信息（new）
-(void)requestToGoodsInfo{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"Type":@"0"};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardFullInfoByType"];
    NSLog(@"获取四种支付手段的详细信息【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        [[LoadingView showLoadingView] actViewStopAnimation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"获取四种支付手段的详细信息【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                perRmb = [[body objectForKey:@"Arg0"] intValue];
                long bean =[[body objectForKey:@"Residue"] longLongValue];
                [[MyUserDefault standardUserDefaults] setUserBeanNum:bean];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,320 -2*(kOffX_float), 0)];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"获取四种支付手段的详细信息【erroe】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                [self requestToGoodsInfo];
            }else{
                timeOutCount = 0;
                [[LoadingView showLoadingView] actViewStopAnimation];
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    alertView = nil;
                }
            }
        }
    }];
}

-(void)onClickAddQCoinBtn:(UIButton* )btn{
    btn.highlighted = YES;
    switch (btn.tag) {
            //Q币数减少
        case 3:
        {
            if (QBcount==1) {
                return;
            }else{
                QBcount--;
                Qcount.text = [NSString stringWithFormat:@"%dQ币",QBcount];
            }
        }
            break;
            //Q币数增加
        case 4:
        {
            QBcount++;
            Qcount.text = [NSString stringWithFormat:@"%dQ币",QBcount];
        }
            break;
        default:
            break;
    }
}

-(void)onClickBackBtn:(UIButton* )btn{
    switch (btn.tag) {
            //返回按钮
        case 1:
        {
            [[LoadingView showLoadingView] actViewStopAnimation];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            // 兑换确认
        case 2:
        {
            [QQText resignFirstResponder];
            DidRewardView* view = [[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
            view.drDelegate = self;
            view.type = 101;
            view.rewardType = 1;
            view.arg0 = perRmb;
            view.QNumber = QQText.text;
            view.getCoins= [coinCount objectAtIndex:selectBtnIndex];
            view.QCount = [[coinCount objectAtIndex:selectBtnIndex]intValue];
            view.chargeStyle =[chooseArr objectAtIndex:selectBtnIndex];
            
            int getcoin = [[coinCount objectAtIndex:selectBtnIndex]intValue];
            int dou = getcoin * perRmb;
            long num = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
            
            if ([self isPureInt:QQText.text] && QQText.text.length > 4 && QQText.text.length < 12 ) {
                if (num < dou) {
                    [self showNotEnough];
                }else{
                    [view setBasicView];
                    [self.view addSubview:view];
                }
            }else{
                [StatusBar showTipMessageWithStatus:@"请输入正确的QQ号码" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
            }
        }
            break;
        default:
            break;
    }
    
}

-(void)qDidPopView{
    [[MyUserDefault standardUserDefaults] setUserQNum:QQText.text];
    RewardListViewController *re = [[RewardListViewController alloc]initWithNibName:nil bundle:nil];
    re.isRootPush =YES;
    [self.navigationController pushViewController:re animated:YES];
}

-(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [QQText resignFirstResponder];
}

//滑动收起键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [QQText resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

-(void)showNotEnough{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"报告金主，金豆不足，是否现在做任务赚取金豆？" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚金豆", nil];
    alertView.tag = 1;
    [alertView show];
    alertView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        if(buttonIndex == 0){
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
            [UIAlertView resetNetAlertNil];
            [[LoadingView showLoadingView] actViewStartAnimation];
            [self requestToGoodsInfo];
        }
    }else if(alertView.tag == 1){
        if (buttonIndex == 0) {
            [alertView dismissWithClickedButtonIndex:0 animated:YES];
        }else{
            [alertView dismissWithClickedButtonIndex:0 animated:NO];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"goBackToTaojin" object:nil userInfo:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
