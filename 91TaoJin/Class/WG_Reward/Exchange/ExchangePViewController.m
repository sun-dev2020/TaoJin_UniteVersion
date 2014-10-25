//
//  ExchangePViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-28.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "ExchangePViewController.h"
#import "DidRewardView.h"
#import "TJViewController.h"
#import "StatusBar.h"
#import "LoadingView.h"
#import "RewardListViewController.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "UIAlertView+NetPrompt.h"
#import "HeadToolBar.h"
#import "CButton.h"
#import "UniversalTip.h"

//手机话费,支付宝兑换，财付通兑换
@interface ExchangePViewController ()
{
    MScrollVIew* ms;
    int arg1;
    int arg2;
    int arg3;
    int arg0;
    UIImageView *phoneNumber;
    NSArray* moneys2;
    NSArray* phMoneys2;
    
    
    UIButton* Btn10;
    //    HeadView* headView;
    HeadToolBar *headBar;
    
    NSArray *phoneMoneys;                                           //手机话费
    NSArray *zhiFuBaoMoneys;                                        //支付宝
    NSArray *caiFuTongMoneys;                                       //财付通
    int type;                                                       //标识是哪种支付手段 1：手机话费 2：支付宝 3：财付通
    NSMutableArray *allBtns;                                        //存放当前4个按钮
    int selectBtnIndex;                                             //标识当前选中是哪个按钮
    int timeOutCount;                                               //标识超时的次数
    BOOL isFrist;                                                   //标识是否第一次访问
    
    UIColor *btnTitleClr;                                           // 选择按钮上字体颜色
    UIView *bgView;                                                 //选择状态背景
    CButton *chagreBtn;
}
@end

@implementation ExchangePViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tag:(int )tag{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        type = tag;
    }
    return self;
}

-(void)hidKeyBoard{
    [phoneText resignFirstResponder];
}

//初始化变量
-(void)initWithObjects{
    phoneMoneys = @[@"10元话费",@"20元话费",@"30元话费",@"50元话费"];
    zhiFuBaoMoneys = @[@"兑换20元",@"兑换30元",@"兑换50元",@"兑换100元"];
    caiFuTongMoneys = @[@"兑换20元",@"兑换30元",@"兑换50元",@"兑换100元"];
    moneys2 =@[@"20",@"30",@"50",@"100"];
    phMoneys2 =@[@"10",@"20",@"30",@"50"];
    allBtns = [[NSMutableArray alloc] init];
    isFrist = YES;
    selectBtnIndex = 0;
    arg0 =0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWithObjects];
    
    
    //ios7 以上，更改状态栏的样式
    //    if (IOS_Version >= 7.0) {
    //        UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 20)];
    //        view.backgroundColor =[UIColor blackColor];
    //        [self.view addSubview:view];
    //    }
    NSString *back =@"返回";
    NSNumber *jdCount =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    if (self.isRecharge) {
        NSString *title =[NSString stringWithFormat:@"%@",self.rechargeType];
        
        headBar =[[HeadToolBar alloc] initWithTitle:title leftBtnTitle:back leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:jdCount backgroundColor:KOrangeColor2_0];
        if ([self.rechargeType isEqualToString:@"支付宝"]) {
            btnTitleClr =kBlueColor2_0;
        }else if ([self.rechargeType isEqualToString:@"财付通"]){
            btnTitleClr =kLightBlueColor2_0;
        }
    }else{
        headBar =[[HeadToolBar alloc] initWithTitle:@"话费兑换" leftBtnTitle:back leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightLabTitle:jdCount backgroundColor:KOrangeColor2_0];
        btnTitleClr =KPurpleColor2_0;
    }
    
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    ms = [[MScrollVIew alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y+headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh - headBar.frame.size.height - headBar.frame.origin.y) andWithPageCount:1 backgroundImg:nil];
    ms.msDelegate = self;
    ms.bounces =YES;
    [ms setContentSize:CGSizeMake(kmainScreenWidth, ms.frame.size.height+1)];
    
    bgView =[[UIView alloc]init];
    bgView.backgroundColor =btnTitleClr;
    
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
                [button setTitleColor:btnTitleClr forState:UIControlStateNormal];
            }
            button.titleLabel.font =[UIFont systemFontOfSize:14.0];
            [button addTarget:self action:@selector(onClickRewardPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
            NSString *titleBtn ;
            if(type == 1){
                titleBtn = [phoneMoneys objectAtIndex:button.tag];
            }else if(type == 2){
                titleBtn = [zhiFuBaoMoneys objectAtIndex:button.tag];
            }else if(type == 3){
                titleBtn = [caiFuTongMoneys objectAtIndex:button.tag];
            }
            [button setTitle:titleBtn forState:UIControlStateNormal];
            [self addLineForUi:button withRed:209.0 withGreen:209.0 withBlue:209.0];
            [allBtns addObject:button];
            [ms addSubview:button];
        }
    }
    phoneText = [[UITextField alloc]initWithFrame:CGRectMake(18, 130, 300,16)];
    phoneText.backgroundColor = [UIColor clearColor];
    phoneText.font = [UIFont systemFontOfSize:14];
    phoneText.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter ;
    phoneText.textColor = KBlockColor2_0;
    if(type == 1){
        phoneText.placeholder=@"请输入您的手机号码";
        phoneText.text = [[MyUserDefault standardUserDefaults] getUserPhoneNum];
        [phoneText setKeyboardType:UIKeyboardTypeNumberPad];
    }else if(type == 2){
        phoneText.placeholder=[NSString stringWithFormat:@"请输入您的支付宝账号(邮箱或手机)"];
        phoneText.text = [[MyUserDefault standardUserDefaults] getUserZFB];
        [phoneText setKeyboardType:UIKeyboardTypeEmailAddress];
        phoneText.returnKeyType =UIReturnKeyDone;
    }else if(type == 3){
        phoneText.placeholder=[NSString stringWithFormat:@"请输入您的财付通账号（QQ号）"];
        phoneText.text = [[MyUserDefault standardUserDefaults] getUserCFT];
        [phoneText setKeyboardType:UIKeyboardTypeNumberPad];
    }
    phoneText.delegate=self;
    
    [self loadSperateLineWithFrame:CGRectMake(kOffX_float, phoneText.frame.origin.y +phoneText.frame.size.height+ 15, 320 -kOffX_float, 0.5f)];
    
    chagreBtn= [self loadBtnWithFrame:CGRectMake(kOffX_float, phoneText.frame.origin.y +phoneText.frame.size.height +25, 320 -2*(kOffX_float), 40) withTitle:@"立即兑换" andFont:[UIFont systemFontOfSize:16.0]];
    chagreBtn.tag =6;
    [chagreBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [ms addSubview:chagreBtn];
    [self.view addSubview:ms];
    
    [ms addSubview:phoneText];
    
    [self loadUniversalTipWithFrame:CGRectMake(kOffX_float, chagreBtn.frame.origin.y +chagreBtn.frame.size.height +10,320 -2*(kOffX_float), 0)];
    [self performSelector:@selector(requestToCallsInfor) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidKeyBoard) name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didPopView) name:@"popview" object:nil];
}

-(void)loadUniversalTipWithFrame:(CGRect)rect {
    NSNumber *number =[[MyUserDefault standardUserDefaults] getUserBeanNum];
    int count =0;
    int per =0;
    if (arg0 !=0) {
        if (self.isRecharge) {
            per =arg0 /20;
        }else{
            per =arg0 /10;
        }
        
        count =[number intValue] /per;
    }
    NSString *first;
    NSString *second;
    if (!self.isRecharge) {
        first =[NSString stringWithFormat:@"1.%d金豆=10元，%d金豆=20元，%d金豆=30元，%d金豆=50元；",arg0 ,arg1,arg2 ,arg3];
        second =[NSString stringWithFormat:@"2.您的账户现在有：%@金豆，最多可兑换%d元话费；",number,count];
    }else{
        first =[NSString stringWithFormat:@"1.%d金豆=20元，%d金豆=30元，%d金豆=50元，%d金豆=100元；",arg0,arg1,arg2,arg3];
        second =[NSString stringWithFormat:@"2.您的账户现在有：%@金豆，最多可兑换%d元；",number,count];
    }
    NSString *name;
    NSString *style;
    
    if (!self.isRecharge) {
        name =@"话费";
        style =@"手机";
        [second stringByAppendingString:name];
    }
    else {
        style =self.rechargeType;
    }
    NSString *thrid =[NSString stringWithFormat:@"3.请确保您的%@号码是正确的，否则将无法兑换成功；",style];
    NSString *four =[NSString stringWithFormat:@"4.兑换后需1~2个工作日的审核时间，审核成功后会自动为您的%@号充值，请注意查收；",style];
    NSString *five =[NSString stringWithFormat:@"5.该奖品由91淘金提供，与苹果公司无关。"];
    NSArray *arraytip =[NSArray arrayWithObjects:first,second,thrid,four, five,nil];
    UniversalTip *tip =[[UniversalTip alloc]initWithFrame:rect andTips:arraytip andTipBackgrundColor:KTipBackground2_0 withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImage(@"tips_3.png") andTipTitle:@"兑换说明：" andTextColor:KOrangeColor2_0];
    [ms addSubview:tip];
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

-(void)viewDidAppear:(BOOL)animated{

}

-(void)viewDisappear:(BOOL)animated{
    [phoneText removeFromSuperview];
    phoneText = nil;
    [phoneNumber removeFromSuperview];
    phoneNumber = nil;
    [ms removeFromSuperview];
    ms = nil;
    //    [headView removeFromSuperview];
    //    headView = nil;
    [allBtns removeAllObjects];
    allBtns = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidAllKeyBoard" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popview" object:nil];
}

//请求获取话费信息（new）
-(void)requestToCallsInfor{
    if(isFrist){
        [[LoadingView showLoadingView] actViewStartAnimation];
        isFrist = NO;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"Type":[NSNumber numberWithInt:type]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"AwardUI",@"GetAwardFullInfoByType"];
    NSLog(@"请求获取话费信息【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        [[LoadingView showLoadingView] actViewStopAnimation];
        timeOutCount = 0;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求获取话费信息【response】 = %@",dataDic);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                arg0 =[[body objectForKey:@"Arg0"]integerValue];
                arg1 =[[body objectForKey:@"Arg1"]integerValue];
                arg2 =[[body objectForKey:@"Arg2"]integerValue];
                arg3 =[[body objectForKey:@"Arg3"]integerValue];
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
        NSLog(@"请求获取话费信息【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                [self requestToCallsInfor];
            }else{
                timeOutCount = 0;
                [[LoadingView showLoadingView] actViewStopAnimation];
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.delegate = self;
                    alertView.tag = kTimeOutTag;
                    [alertView show];
                }
            }
        }
    }];
}


-(void)initContentText:(NSString *)content{
    UIWebView *web = [[UIWebView alloc]init];
    [web loadHTMLString:content baseURL:nil];
    web.delegate = self;
    web.frame = CGRectMake(5, phoneNumber.frame.origin.y + phoneNumber.frame.size .height + 5, 310,0);
    web.backgroundColor = [UIColor clearColor];
    web.scrollView.backgroundColor= [UIColor clearColor];
    [web setScalesPageToFit:NO];
    web.userInteractionEnabled =NO;
    [ms addSubview:web];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [[LoadingView showLoadingView] actViewStopAnimation];
}

- (void)highlightButton:(UIButton *)btn {
    [btn setHighlighted:YES];
}

-(void)onClickRewardPhoneBtn:(UIButton* )btn{
    bgView.frame =btn.frame;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectBtnIndex =btn.tag;
    for (UIButton *button in allBtns) {
        if (button.tag != btn.tag) {
            
            [button setTitleColor:btnTitleClr forState:UIControlStateNormal];
            
        }
    }
}
-(void)onClickBackBtn:(UIButton* )btn{
    
    switch (btn.tag) {
        case 1:
        {
            [[LoadingView showLoadingView] actViewStopAnimation];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 6:
        {
            //获取当前账号的淘金豆
            long userBeanNum = [[[MyUserDefault standardUserDefaults] getUserBeanNum] longValue];
            
            [phoneText resignFirstResponder];
            
            DidRewardView *view = [[DidRewardView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh)];
            view.phoneNumber = phoneText.text;
            view.type = 102;
            view.rewardType = 2;
            view.chargeStyle =[phoneMoneys objectAtIndex:selectBtnIndex];
            if (self.isRecharge==YES) {
                view.isRecharge=YES;
                view.getHfInt =[[phMoneys2 objectAtIndex:selectBtnIndex]integerValue];
                if ([self.rechargeType isEqualToString:@"支付宝"]) {
                    view.rechargeType=self.rechargeType;
                    view.rewardType =6;
                    view.arg0= arg0;
                    view.phoneNumber =phoneText.text;
                    view.getHfInt =[[moneys2 objectAtIndex:selectBtnIndex]integerValue];
                    view.chargeStyle =[zhiFuBaoMoneys objectAtIndex:selectBtnIndex];
                    switch (selectBtnIndex) {
                        case 0:
                            view.arg0 =arg0;
                            break;
                            
                        case 1:
                            view.arg0 =arg1;
                            break;
                            
                        case 2:
                            view.arg0 =arg2;
                            break;
                            
                        case 3:
                            view.arg0 =arg3;
                            break;
                    }
                    //[Sun] 2014.03.15 支付宝可以为手机号
                    BOOL isPhoneNum = [self isPureInt:phoneText.text] && phoneText.text.length ==11;
                    if ([self isEmailAdress:phoneText.text] || isPhoneNum ==YES) {
                        if (userBeanNum < view.arg0) {
                            [self showNotEnough];
                        }else{
                            [view setBasicView];
                            [self.view addSubview:view];
                        }
                    }else{
                        [StatusBar showTipMessageWithStatus:@"请输入正确的支付宝账号" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
                    }
                }else if ([self.rechargeType isEqualToString:@"财付通"]){
                    view.rechargeType=self.rechargeType;
                    view.rewardType =7;
                    view.arg0 =arg0;
                    view.phoneNumber =phoneText.text;
                    view.getHfInt=[[moneys2 objectAtIndex:selectBtnIndex]integerValue];
                    view.chargeStyle =[caiFuTongMoneys objectAtIndex:selectBtnIndex];
                    switch (selectBtnIndex) {
                        case 0:
                            view.arg0 =arg0;
                            break;
                            
                        case 1:
                            view.arg0 =arg1;
                            break;
                            
                        case 2:
                            view.arg0 =arg2;
                            break;
                            
                        case 3:
                            view.arg0 =arg3;
                            break;
                    }
                    
                    if ([self isPureInt:phoneText.text] && phoneText.text.length >4 && phoneText.text.length <12) {
                        if (userBeanNum <view.arg0) {
                            [self showNotEnough];
                        }else{
                            [view setBasicView];
                            [self.view addSubview:view];
                        }
                    }else{
                        [StatusBar showTipMessageWithStatus:@"请输入正确的财付通号码" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
                    }
                    
                }
                
            }else{
                view.getHfInt =[[phMoneys2 objectAtIndex:selectBtnIndex]integerValue];
                view.getHF =[phoneMoneys objectAtIndex:selectBtnIndex];
                
                switch (selectBtnIndex) {
                    case 0:
                        view.arg0 =arg0;
                        break;
                        
                    case 1:
                        view.arg0 =arg1;
                        break;
                        
                    case 2:
                        view.arg0 =arg2;
                        break;
                        
                    case 3:
                        view.arg0 =arg3;
                        break;
                }
                
                
                if ([self isPureInt:phoneText.text] && phoneText.text.length ==11) {
                    if (userBeanNum < view.arg0) {
                        [self showNotEnough];
                    }else{
                        [view setBasicView];
                        [self.view addSubview:view];
                    }
                }else{
                    [StatusBar showTipMessageWithStatus:@"请输入正确的手机号码" andImage:[UIImage imageNamed:@"icon_no.png"]andTipIsBottom:YES];
                }
            }
        }
            break;
    }
    
}

-(BOOL)isEmailAdress:(NSString*)email{
    if((0 != [email rangeOfString:@"@"].length) && (0 != [email rangeOfString:@"."].length)){
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet]; NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy]; [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        //使用compare option 来设定比较规则,如 //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数,而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@"options:NSCaseInsensitiveSearch];
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray = [userNameString componentsSeparatedByString:@"."];
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        NSString *domainString = [email substringFromIndex:range1.location+1]; NSArray *domainArray = [domainString componentsSeparatedByString:@"."];
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet]; if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        return YES;
    }else // no ''@'' or ''.''present
        return NO;
}
-(BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [phoneText resignFirstResponder];
}

-(void)didPopView{
    if(type == 1){
        //话费充值
        [[MyUserDefault standardUserDefaults] setUserPhoneNum:phoneText.text];
    }else if(type == 2){
        //支付宝
        [[MyUserDefault standardUserDefaults] setUserZFB:phoneText.text];
    }else if(type == 3){
        //财付通充值
        [[MyUserDefault standardUserDefaults] setUserCFT:phoneText.text];
    }
    RewardListViewController *re = [[RewardListViewController alloc] initWithNibName:nil bundle:nil];
    re.isRootPush =YES;
    [self.navigationController pushViewController:re animated:YES];
    
}
//滑动收起键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.rechargeType isEqualToString:@"支付宝"]) {
        
    }else{
        [phoneText resignFirstResponder];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

// [Sun] 2014.03.18 修改金豆不足提示
-(void)showNotEnough{
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"金豆余额不足" message:@"报告金主，您的金豆余额不足，可通过做任务、邀请好友、参与活动等方式赚取金豆" delegate:self cancelButtonTitle:@"算了" otherButtonTitles:@"赚金豆", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kTimeOutTag){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [UIAlertView resetNetAlertNil];
        [[LoadingView showLoadingView] actViewStartAnimation];
        [self requestToCallsInfor];
    }else if(alertView.tag == 1){
        if (buttonIndex ==0) {
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
