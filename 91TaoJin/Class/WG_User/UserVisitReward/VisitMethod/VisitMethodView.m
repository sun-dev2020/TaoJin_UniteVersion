//
//  VisitMethodView.m
//  TJiphone
//
//  Created by keyrun on 13-10-9.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "VisitMethodView.h"
#import "LoadingView.h"
#import "StatusBar.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "NSString+IsEmply.h"
#import "UIAlertView+NetPrompt.h"
#import "CButton.h"
#import "UniversalTip.h"


@implementation VisitMethodView{
    NSString *infor;
    NSString *method;
    LoadingView *loadView;
    
    UIScrollView *scrollView;
    UILabel *text2;
    
    int visitPeople;                                                   //邀请人数
    int visitJD;                                                       //获得的金豆数

    int methodIndex;
    NSString *chooseImageUrl;
    NSString *chooseWebUrl;
    NSMutableArray *btns;
    UIView *whiteView;
    
    int timeOutCount;
    
    NSArray *visitMethods;                                              //邀请方法
    UILabel *commentLabel;                                              //公共内容
    CButton *copyBtn;                                            //复制按钮
    CButton *shareBtn;                                           //分享按钮
    UILabel *shareLab;                                                  //分享的内容
    UILabel *tipLab;                                                    //提示邀请几位的文案
    
    BOOL isFrist;                                                       //标识是否第一次访问
    UniversalTip *tip;                                           //邀请说明
    float xShareLab ;
    float yShareLab ;
    
    int yGold;                                           // 邀请奖励金豆数
    int tGold;                                           // 完成第一个任务奖励金豆数
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        btns = [[NSMutableArray alloc]init];
        chooseImageUrl = [[NSString alloc]init];
        timeOutCount = 0;
        isFrist = YES;
        
        yGold = 0;
        tGold = 0;
//        [self initViewContent];

//        [self performSelectorOnMainThread:@selector(requestToGetVisitMethod) withObject:nil waitUntilDone:NO];
        [self performSelector:@selector(requestToGetVisitMethod) onThread:[NSThread currentThread] withObject:nil waitUntilDone:NO];
//        [self requestToGetVisitMethod];

    }
    return self;
}

-(BOOL)isPureInt:(NSString*)string{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//初始化内容Label
-(UILabel *)loadWithLabel:(CGRect )frame attributedText:(NSMutableAttributedString *)attributedText text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.numberOfLines = 0;
    if([NSString isEmply:text]){
        label.attributedText = attributedText;
    }else{
        label.text = text;
        label.textColor = textColor;
    }
    label.font = font;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = textAlignment;
    label.userInteractionEnabled = NO;
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [label sizeToFit];
    return label;
}

-(void)initViewContent{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kmainScreenHeigh - kOriginY - kHeadViewHeigh)];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView setContentSize:CGSizeMake(320, kmainScreenHeigh)];
    
    //显示内容文案
    NSArray *oldStrAry = [infor componentsSeparatedByString:@"<red>"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    for(NSString *str in oldStrAry){
        NSMutableAttributedString *oneStr = [[NSMutableAttributedString alloc] initWithString:str];
        if ([self isPureInt:str] || [str hasPrefix:@"("]) {
            [oneStr addAttribute:NSForegroundColorAttributeName value:KOrangeColor2_0 range:NSMakeRange(0, str.length)];
        }else{
            [oneStr addAttribute:NSForegroundColorAttributeName value:KBlockColor2_0 range:NSMakeRange(0, str.length)];
        }
        [attStr appendAttributedString:oneStr];
    }
    commentLabel = [self loadWithLabel:CGRectMake(kOffX_float, 10.0f, kmainScreenWidth - 16.0f, 0.0f) attributedText:attStr text:@"" font:[UIFont systemFontOfSize:14.0f] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft];
    [self addSubview:commentLabel];
    
    NSString *firstTip =[NSString stringWithFormat:@"1.邀请好友安装91淘金即送%d金豆；",yGold];
    NSString *secTip =[NSString stringWithFormat:@"2.好友试玩任一淘金任务，再送%d金豆；",tGold];
    NSArray *tipArr =[[NSArray alloc]initWithObjects:firstTip, secTip,@"3.该邀请活动与苹果公司无关。",nil];
    tip =[[UniversalTip alloc]initWithFrame:CGRectMake(kOffX_float, commentLabel.frame.origin.y +commentLabel.frame.size.height +10, 320 -2* kOffX_float, 0) andTips:tipArr andTipBackgrundColor:kLightYellow2_0 withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImage(@"tips_3.png") andTipTitle:@"邀请说明:" andTextColor:KOrangeColor2_0];
    [self addSubview:tip];
    
    /*
<<<<<<< .mine
//    [self addSubview:text1];

    if (visitMethods.count !=0) {
        for (int i=0; i <visitMethods.count; i++) {
            UIButton* methodButton =[UIButton buttonWithType:UIButtonTypeCustom];
            methodButton.frame =CGRectMake(5+i*74+4.7*i, commentLabel.frame.origin.y+commentLabel.frame.size.height+14, 74, 23);
            methodButton.backgroundColor =kJFQBGColor;
            [methodButton setTitleColor:kSilverColor forState:UIControlStateNormal];
            switch (i) {
                case 0:{
                    [methodButton setTitle:@"内容一" forState:UIControlStateNormal];
                    NSDictionary* dic =[visitMethods objectAtIndex:0];
                    if ([dic objectForKey:@"Pic"]) {
                        chooseImageUrl =[dic objectForKey:@"Pic"];
                    }else{
                        chooseImageUrl =nil;
                    }
                    
                    chooseWebUrl =[dic objectForKey:@"Url"];
                    methodButton.frame =CGRectMake(5+i*74+4.7*i, commentLabel.frame.origin.y+commentLabel.frame.size.height+14, 74, 26);
                    methodButton.backgroundColor =[UIColor whiteColor];
                    [methodButton setTitleColor:kcolor forState:UIControlStateNormal];
                    whiteView =[[UIView alloc]initWithFrame:CGRectMake(methodButton.frame.origin.x+0.5, methodButton.frame.origin.y+methodButton.frame.size.height-0.5, 73, 1)];
                    whiteView.backgroundColor =[UIColor whiteColor];
                    
                    
=======
     */
    
    for (int i = 0 ; i < visitMethods.count ; i++) {
        UIButton *methodButton = [UIButton buttonWithType:UIButtonTypeCustom];
        methodButton.frame = CGRectMake(kOffX_float + i * 73 + 4 * i, tip.frame.origin.y + tip.frame.size.height + 10, 73, 24);
        if(i == 0){
//            xShareLab = methodButton.frame.origin.x;
//            yShareLab = methodButton.frame.origin.y + methodButton.frame.size.height;
        }
        methodButton.backgroundColor = kJFQBGColor;
        [methodButton setTitleColor:KBlockColor2_0 forState:UIControlStateNormal];
        methodButton.tag = i;
        methodButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        [methodButton addTarget:self action:@selector(onClickMethodBtn:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:{
                [methodButton setTitle:@"内容一" forState:UIControlStateNormal];
                NSDictionary *dic = [visitMethods objectAtIndex:0];
                if ([dic objectForKey:@"Pic"]) {
                    chooseImageUrl = [dic objectForKey:@"Pic"];
                }else{
                    chooseImageUrl = nil;
//>>>>>>> .r3368
                }
                chooseWebUrl = [dic objectForKey:@"Url"];
                methodButton.frame = CGRectMake(kOffX_float + i * 73 + 4 * i, tip.frame.origin.y + tip.frame.size.height + 10, 73, 26);
                methodButton.backgroundColor = [UIColor whiteColor];
                xShareLab = methodButton.frame.origin.x;
                yShareLab = methodButton.frame.origin.y + methodButton.frame.size.height;
                [methodButton setTitleColor:kBlueColor2_0 forState:UIControlStateNormal];
                [methodButton setTitleColor:kBlueColor2_0 forState:UIControlStateHighlighted];
                whiteView = [[UIView alloc] initWithFrame:CGRectMake(methodButton.frame.origin.x + 0.5, methodButton.frame.origin.y + methodButton.frame.size.height - 0.5, 72, 1)];
                whiteView.backgroundColor = [UIColor whiteColor];
            }
                break;
            case 1:
                [methodButton setTitle:@"内容二" forState:UIControlStateNormal];
                [methodButton setTitleColor:KPurpleColor2_0 forState:UIControlStateHighlighted];
                break;
            case 2:
                [methodButton setTitle:@"内容三" forState:UIControlStateNormal];
                [methodButton setTitleColor:KOrangeColor2_0 forState:UIControlStateHighlighted];
                break;
            case 3:
                [methodButton setTitle:@"内容四" forState:UIControlStateNormal];
                [methodButton setTitleColor:KRedColor2_0 forState:UIControlStateHighlighted];
                break;
            default:
                break;
        }
        if (i == 0) {
            
            [self setLayerBounce:methodButton withWidth:0.5f];
        }
        [btns addObject:methodButton];
        [self addSubview:methodButton];
    }
    //分享内容
    NSDictionary *dic = [visitMethods objectAtIndex:0];
    shareLab = [self loadWithLabel:CGRectMake(kOffX_float + 5.0f, yShareLab +8.0f, 290, 13) attributedText:nil text:[dic objectForKey:@"Output"] font:[UIFont systemFontOfSize:14.0f] textColor:kBlueColor2_0 textAlignment:NSTextAlignmentLeft];

    text2 = [[UILabel alloc]initWithFrame:CGRectMake(kOffX_float, yShareLab , 304, shareLab.frame.size.height +16)];
    text2.backgroundColor = [UIColor whiteColor];
    
    CGFloat r = 173.0/255.0;
    CGFloat g = 173.0/255.0;
    CGFloat b = 173.0/255.0;;
    CGFloat a = 1;
    CGFloat com[4] = {r,g,b,a};
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = (__bridge CGColorRef)(__bridge id)CGColorCreate(colorspace, com);
    [text2.layer setBorderColor:color];
    [text2.layer setBorderWidth:.5f];
    CGColorRelease(color);
    CGColorSpaceRelease(colorspace);
    
    [self addSubview:text2];
    [self addSubview:shareLab];
    [self addSubview:whiteView];
    
    //复制按钮
    copyBtn =[self loadBtnWithFrame:CGRectMake(kOffX_float, text2.frame.origin.y + text2.frame.size.height + 10, 151, 40) andTitle:@"复制" andBackgrundColor:KGreenColor2_0 andChangeColor:kSelectGreen];
    [copyBtn addTarget:self action:@selector(onClickCopyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:copyBtn];
    //分享按钮
    shareBtn =[self loadBtnWithFrame:CGRectMake(copyBtn.frame.origin.x +copyBtn.frame.size.width +2, copyBtn.frame.origin.y , 151, 40) andTitle:@"分享" andBackgrundColor:KGreenColor2_0 andChangeColor:kSelectGreen];
    [shareBtn addTarget:self action:@selector(onClickShareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    
    //底部提示已邀请多少位好友
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您已邀请%d位好友，共获得%d金豆",visitPeople,visitJD]];
    NSString *oneStr =[NSString stringWithFormat:@"%d",visitPeople];
    NSString *twolength =[NSString stringWithFormat:@"%d",visitJD];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [attString addAttribute:NSForegroundColorAttributeName value:KOrangeColor2_0 range:NSMakeRange(4 ,oneStr.length+1)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(4+oneStr.length+1, 6)];
    [attString addAttribute:NSForegroundColorAttributeName value:KOrangeColor2_0 range:NSMakeRange(4+oneStr.length+7, twolength.length+2)];
    tipLab = [self loadWithLabel:CGRectMake(0, shareBtn.frame.origin.y + shareBtn.frame.size.height + 25, kmainScreenWidth, 0) attributedText:attString text:@"" font:[UIFont systemFontOfSize:14.0] textColor:nil textAlignment:NSTextAlignmentCenter];
    tipLab.frame = CGRectMake(tipLab.frame.origin.x, tipLab.frame.origin.y, kmainScreenWidth, tipLab.frame.size.height);
    [self addSubview:tipLab];
}

-(void)setLayerBounce:(UIView *)view withWidth:(float) width{
    CGFloat r = 173.0/255.0;
    CGFloat g = 173.0/255.0;
    CGFloat b = 173.0/255.0;;
    CGFloat a = 1;
    CGFloat com[4] = {r,g,b,a};
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color =(__bridge CGColorRef)(__bridge id)CGColorCreate(colorspace, com);
    [view.layer setBorderColor:color];
    [view.layer setBorderWidth:width];
}
-(CButton *)loadBtnWithFrame:(CGRect) frame andTitle:(NSString *)title andBackgrundColor:(UIColor *)nomalColor andChangeColor:(UIColor *)changeColor{
    CButton *btn =[[CButton alloc]initWithFrame:frame];
    btn.backgroundColor =nomalColor;
    btn.nomalColor =nomalColor;
    btn.changeColor =changeColor;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font =[UIFont systemFontOfSize:16.0];
    return btn;
}
//点击不同的tab显示不同的内容
-(void)onClickMethodBtn:(UIButton*)mbtn{
    methodIndex = mbtn.tag;
    [mbtn setTitleColor:[mbtn titleColorForState:UIControlStateHighlighted] forState:UIControlStateNormal];
    shareLab.textColor =[mbtn titleColorForState:UIControlStateHighlighted];
    
    NSDictionary *dic = [visitMethods objectAtIndex:methodIndex];
    if (visitMethods.count != 0) {
        NSDictionary *dic = [visitMethods objectAtIndex:methodIndex];
        shareLab.text = [dic objectForKey:@"Output"];
    }
    [shareLab sizeToFit];
    shareLab.frame = CGRectMake(kOffX_float +5.0f, yShareLab+8.0f, 290, shareLab.frame.size.height);
    text2.frame = CGRectMake(kOffX_float, yShareLab, 304, shareLab.frame.size.height+16);

    if ([dic objectForKey:@"Pic"]) {
        chooseImageUrl =[dic objectForKey:@"Pic"];
    }else{
        chooseImageUrl =nil;
    }
    
    chooseWebUrl =[dic objectForKey:@"Url"];
    for (UIButton* btn in btns) {
        if (btn.tag == methodIndex) {
            btn.frame = CGRectMake(kOffX_float+methodIndex*73+4*methodIndex, tip.frame.origin.y+tip.frame.size.height+10, 73, 26);
            btn.backgroundColor =[UIColor whiteColor];
            whiteView.frame = CGRectMake(btn.frame.origin.x+0.5, btn.frame.origin.y+btn.frame.size.height-0.5, 72, 1);
            [self setLayerBounce:btn withWidth:0.5f];
            [self addSubview:whiteView];
        }else{
            btn.frame =CGRectMake(kOffX_float+btn.tag*73+4*btn.tag, tip.frame.origin.y+tip.frame.size.height+10, 73, 24);
            btn.backgroundColor =KLightGrayColor2_0;
            [btn setTitleColor:KBlockColor2_0 forState:UIControlStateNormal];
            [self setLayerBounce:btn withWidth:0.0f];
            
        }
    }
    
    copyBtn.frame = CGRectMake(kOffX_float, text2.frame.origin.y + text2.frame.size.height+10, 151, 40);
    shareBtn.frame = CGRectMake(copyBtn.frame.origin.x + copyBtn.frame.size.width+2, copyBtn.frame.origin.y, 151, 40);
    tipLab.frame = CGRectMake(0, copyBtn.frame.origin.y + copyBtn.frame.size.height+50, kmainScreenWidth, tipLab.frame.size.height);
}

// 【分享按钮】事件
-(void)onClickShareBtn:(id)sender{
    if(self.shareCallBack){
        self.shareCallBack(shareLab.text,chooseImageUrl,chooseWebUrl);
    }

    
}

//【复制按钮】事件
-(void)onClickCopyBtn:(id)sender{
    
    
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    if (visitMethods.count != 0) {
        NSDictionary* dic = [visitMethods objectAtIndex:methodIndex];
        NSString *string =[dic objectForKey:@"Output"];
        if (string) {
            [pasteboard setValue:string forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
            [StatusBar showTipMessageWithStatus:@"复制成功" andImage:[UIImage imageNamed:@"laba.png"]andTipIsBottom:YES];
        }
    }
    
}

//请求获取邀请方法文案
-(void)requestToGetVisitMethod{
    if(isFrist){
        if (![[LoadingView showLoadingView] actViewIsAnimation]) {
            [[LoadingView showLoadingView] actViewStartAnimation];
        }
        isFrist = YES;
    }
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"GetInviteInfo"];
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        NSLog(@"   邀请方法 url= %@ ",urlStr);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"  邀请方法 data =%@",dic);
            timeOutCount = 0;
            int flag = [[dic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dic objectForKey:@"body"];
                infor = [body objectForKey:@"Info"];
                visitMethods = [body objectForKey:@"Method"];
                if (visitMethods.count > 0 ) {
                    NSDictionary *methodDic =[visitMethods objectAtIndex:0];
                    if ([methodDic objectForKey:@"Url"]) {
                        self.codeUrl =[methodDic objectForKey:@"Url"];
                    }
                }
                visitJD = [[body objectForKey:@"FriendGold"] intValue];
                visitPeople = [[body objectForKey:@"FriendNum"] intValue];
                yGold =[[body objectForKey:@"YGold"] intValue];
                tGold =[[body objectForKey:@"TGold"] intValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    [self initViewContent];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                });
            }
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToGetVisitMethod];
            }else{
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
        [self requestToGetVisitMethod];
    }
}

@end







