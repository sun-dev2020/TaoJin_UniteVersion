//
//  VisitViewController.m
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import "VisitViewController.h"
#import "TJViewController.h"
#import "MyUserDefault.h"
#import "MyUserDefault.h"
#import "AsynURLConnection.h"
#import "HeadToolBar.h"
#import "SDImageView+SDWebCache.h"
#import "TaoJinScrollView.h"
//邀请奖励
#import "LoadingView.h"
#import "QRCodeGenerator.h"
#import "StatusBar.h"
#import "UniversalTip.h"
#define kCodeImageSize  160.0
#define kVisitAdress  @"http://www.91taojin.com.cn/index.php?d=admin&c=page&m=detail&id=6"
@interface VisitViewController ()
{
    
    UIImageView* image;
    //    HeadView* headView;
    
    HeadToolBar *headBar;
    UIScrollView* scrollView;
    VisitMethodView *vm;
    UIImage *oriCodeImg;
    UIScrollView *visitSV;
    
    id <ISSShareActionSheetItem> sinaItem;
    
    BOOL webViewReload;
    
    TaoJinScrollView *tjView;
    UIWebView *_webView;
    int webErrorCount;
    
    __block UniversalTip *tipView ;
}
@end

@implementation VisitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[MyUserDefault standardUserDefaults] setUserInviteCount:self.inviteCount];
    
    
    headBar = [[HeadToolBar alloc] initWithTitle:@"邀请奖励" leftBtnTitle:@"返回" leftBtnImg:GetImage(@"back.png") leftBtnHighlightedImg:GetImage(@"back_sel.png") rightBtnTitle:@"二维码" rightBtnImg:GetImage(@"icon_code1.png") rightBtnHighlightedImg:GetImage(@"icon_code2.png") backgroundColor:KOrangeColor2_0];
    headBar.rightBtn.tag =2;
    headBar.leftBtn.tag =1;
    [headBar.leftBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headBar.rightBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBar];
    
    if (IOS_Version >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    /*
    if (!tipView) {
        NSArray *array =[[NSArray alloc] initWithObjects:@"1.分享成功后，需点击“返回91淘金”，才能确保获取金豆奖励；",@"2.分享内容请勿随意删除，如好友通过您的分享的内容安装并适玩91淘金，你将获得邀请奖励。", nil];
        tipView =[[UniversalTip alloc] initWithFrame:CGRectMake(10, 170, kmainScreenWidth -20, 0) andTips:array andTipBackgrundColor:[UIColor whiteColor] withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImage(@"dengpao_orange") andTipTitle:@"分享提示：" andTextColor:KOrangeColor2_0];
        [tipView uploadTipContent:array andFont:[UIFont systemFontOfSize:11.0] andTextColor:KOrangeColor2_0 needAdjustPosition:YES];
        if (kmainScreenHeigh == 480.0f) {
            tipView.frame =CGRectMake(10, 80, kmainScreenWidth -20, tipView.frame.size.height);
        }
        tipView.alpha = 0.0;
        tipView.layer.cornerRadius =10.0;
    }
    */
    
    [self initVisitMethodView];
    [self initVisitHistoryTable];
    [self initScrollView];
}


-(void)viewDidDisappear:(BOOL)animated{
    [headBar removeFromSuperview];
    headBar = nil;
    [image removeFromSuperview];
    image = nil;
    [vm removeFromSuperview];
    vm = nil;
    [visitSV removeFromSuperview];
    visitSV = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView setDelegate:nil];
    [_webView removeFromSuperview];
    _webView = nil;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [scrollView removeFromSuperview];
    scrollView = nil;
    [tjView removeFromSuperview];
    tjView = nil;
    
    oriCodeImg = nil;
    sinaItem = nil;
    if (IOS_Version >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(void)initScrollView{
    NSArray *array =[[NSArray alloc] initWithObjects:@"邀请方法",@"邀请攻略", nil];
    NSArray *arrayView =[[NSArray alloc] initWithObjects:visitSV,scrollView, nil];
    tjView =[[TaoJinScrollView alloc] initWithFrame:CGRectMake(0, headBar.frame.origin.y +headBar.frame.size.height, kmainScreenWidth, kmainScreenHeigh -headBar.frame.origin.y -headBar.frame.size.height) btnAry:array btnAction:^(UIButton *button) {
        
        if (button.tag ==2 && webViewReload ==NO) {
            [self startReloadWeb];   // 加载邀请攻略
        }
    } slidColor:KOrangeColor2_0 viewAry:arrayView];
    tjView.scrollView.delaysContentTouches =NO;
    [self.view addSubview:tjView];
    
}
//初始化【邀请方法】界面
-(void)initVisitMethodView{
    visitSV =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y-headBar.frame.size.height)];
    if (kmainScreenHeigh < 568.0f) {
        [visitSV setContentSize:CGSizeMake(kmainScreenWidth, visitSV.frame.size.height+45)];
    }
    vm = [[VisitMethodView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y-headBar.frame.size.height)];
    
    [visitSV addSubview:vm];
    vm.shareCallBack = ^(NSString *shareContent, NSString *imageUrl, NSString *webUrl){
        
        
        id <ISSContent> publishContent =[ShareSDK content:shareContent defaultContent:shareContent image:[ShareSDK imageWithUrl:imageUrl] title:kShareTitle url:webUrl description:shareContent mediaType:SSPublishContentMediaTypeText];
        [ShareSDK ssoEnabled:YES];
        
        // 微信 好友 内容单元
        [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText] content:shareContent title:kShareTitle url:webUrl image:[ShareSDK imageWithUrl:imageUrl] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
        
        // 微信 朋友圈 内容单元
        [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText] content:shareContent title:kShareTitle url:webUrl image:[ShareSDK imageWithUrl:imageUrl] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
        
        // 新浪微博
        if ([imageUrl hasPrefix:@"http"]) {
            [publishContent addSinaWeiboUnitWithContent:shareContent image:[ShareSDK imageWithUrl:imageUrl]];     //sina 发布微博高级接口传入的为图片url地址
        }else{
            NSLog(@"   no pic");
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share" ofType:@".png"];
            [publishContent addSinaWeiboUnitWithContent:shareContent image:[ShareSDK imageWithPath:imagePath]];   // sina 发布微博普通接口传入的为image
        }
        
        //qq zone
        [publishContent addQQSpaceUnitWithTitle:kShareTitle url:webUrl site:nil fromUrl:nil comment:nil summary:shareContent image:[ShareSDK imageWithUrl:imageUrl] type:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews] playUrl:nil nswb:[NSNumber numberWithInteger:1]];
        
        //qq 好友
        [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews] content:shareContent title:kShareTitle url:webUrl image:[ShareSDK imageWithUrl:imageUrl]];
        
        // 腾讯微博
        [publishContent addTencentWeiboUnitWithContent:shareContent image:[ShareSDK imageWithUrl:imageUrl]];
        
        
        id <ISSContainer> container = [ShareSDK container];
        [container setIPhoneContainerWithViewController:self];
        
        id <ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
        [authOptions setPowerByHidden:YES]; //隐藏logo
        
        
        /*
         sinaItem =[ShareSDK shareActionSheetItemWithTitle:@"+100金豆" icon:GetImage(@"sina") clickHandler:^{
         [self clickHandlerWithShareContent:publishContent type:ShareTypeSinaWeibo andAuthOptions:authOptions];
         }];
         id <ISSShareActionSheetItem> txWBItem =[ShareSDK shareActionSheetItemWithTitle:@"+200金豆" icon:GetImage(@"tencent") clickHandler:^{
         [self clickHandlerWithShareContent:publishContent type:ShareTypeTencentWeibo andAuthOptions:authOptions];
         }];
         id <ISSShareActionSheetItem> wxFriendItem =[ShareSDK shareActionSheetItemWithTitle:@"100金豆" icon:GetImage(@"wechat") clickHandler:^{
         [self clickHandlerWithShareContent:publishContent type:ShareTypeWeixiSession andAuthOptions:authOptions];
         }];
         id <ISSShareActionSheetItem> wxTimeLineItem =[ShareSDK shareActionSheetItemWithTitle:@"100金豆" icon:GetImage(@"timeLine") clickHandler:^{
         [self clickHandlerWithShareContent:publishContent type:ShareTypeWeixiTimeline andAuthOptions:authOptions];
         }];
         id <ISSShareActionSheetItem> qqItem =[ShareSDK shareActionSheetItemWithTitle:@"100金豆" icon:GetImage(@"qq") clickHandler:^{
         [self clickHandlerWithShareContent:publishContent type:ShareTypeQQ andAuthOptions:authOptions];
         }];
         id <ISSShareActionSheetItem> qqZoneItem =[ShareSDK shareActionSheetItemWithTitle:@"100金豆" icon:GetImage(@"qzone") clickHandler:^{
         [self clickHandlerWithShareContent:publishContent type:ShareTypeQQSpace andAuthOptions:authOptions];
         }];
         NSArray *lists =[ShareSDK customShareListWithType:sinaItem,txWBItem,wxFriendItem,wxTimeLineItem,qqItem,qqZoneItem, nil];
         */
        
        [ShareSDK showShareActionSheet:container shareList:nil content:publishContent statusBarTips:YES authOptions:authOptions shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
            //            NSLog(@"  分享响应  %d %d",state ,type);
            if (state == SSResponseStateSuccess) {
                NSLog(@"   分享成功");
                //                [sinaItem title]
                [self sendShareState:state andShareType:type];     //发送分享统计
            }else if (state == SSResponseStateFail){
                NSLog(@"   share fail %@",[error errorDescription]);
            }else if (state == SSResponseStateBegan){
                [self sendShareState:state andShareType:type];
            }else if (state == SSResponseStateCancel){
               
            }
        }];
        
    };
    
}
-(void)clickHandlerWithShareContent:(id<ISSContent>)publishContent type:(ShareType)type andAuthOptions:(id<ISSAuthOptions>)authOptions{
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        NSLog(@"  分享响应  %d %d",state ,type);
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                            NSLog(@"  sharesid %@" ,statusInfo.sid);
                            sinaItem =[ShareSDK shareActionSheetItemWithTitle:@"已分享" icon:GetImage(@"sina") clickHandler:^{
                                [self clickHandlerWithShareContent:publishContent type:type andAuthOptions:authOptions];
                            }];
                            [self sendShareState:state andShareType:type];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                        }else if (state ==SSPublishContentStateBegan){
                            [self sendShareState:state andShareType:type];
                        }
                    }];
    
}
-(void)sendShareState:(int) shareState andShareType:(int) type{
    NSString* typeStr ;
    switch (type) {
        case 1: //新浪微博
            typeStr = @"sinaweibo";
            break;
        case 2: //腾讯微博
            typeStr = @"tencentweibo";
            break;
        case 6:  //qq zone
            typeStr = @"qqzone";
            break;
        case 22:  //微信 好友
            typeStr = @"weixinfriend";
            break;
        case 23:   //微信 朋友圈
            typeStr = @"weixintimeline";
            break;
        case 24:   // qq 好友
            typeStr = @"qqfriend";
            break;
        default:
            break;
    }
    [self requestToSetInviteShare:typeStr shareState:shareState];
}

//请求发送分享统计
-(void)requestToSetInviteShare:(NSString *)typeStr shareState:(int)shareState {
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    int time = arc4random()/1000000;
    NSNumber *arcNum = [NSNumber numberWithInteger:time];
    NSDictionary *dic = @{@"sid": sid, @"Type":typeStr, @"ShareState":[NSNumber numberWithInteger:shareState], @"arcNum":arcNum};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"MyCenterUI",@"SetInviteShare"];
    NSLog(@"请求发送分享统计【urlStr】 = %@",urlStr);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求发送分享统计【response】 = %@",dic);
    } fail:^(NSError *error) {
        
    }];
}

//初始化【邀请攻略】
-(void)initVisitHistoryTable{
    if (!scrollView) {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, kmainScreenHeigh - headBar.frame.origin.y - headBar.frame.size.height)];
        if (IOS_Version < 7.0) {
            scrollView.frame =CGRectMake(kmainScreenWidth, 0, kmainScreenWidth, scrollView.frame.size.height -20);
        }
    }
    
}
-(void)startReloadWeb{
    [[LoadingView showLoadingView] actViewStopAnimation];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, 0)];
    NSURL *url = [NSURL URLWithString:kVisitAdress];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest:request];
    
    webErrorCount =0;
    _webView.delegate = self;
    _webView.userInteractionEnabled =NO;
    _webView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [(UIScrollView* )[[_webView subviews]objectAtIndex:0]setBounces:NO];
    _webView.scalesPageToFit =NO;
    [scrollView addSubview:_webView];
    
    webViewReload = YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if (![[LoadingView showLoadingView] actViewIsAnimation]) {
        [[LoadingView showLoadingView] actViewStartAnimation];
    }
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if (webErrorCount < 3) {
        NSURL *url = [NSURL URLWithString:kVisitAdress];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [_webView loadRequest:request];
        webErrorCount ++;
    }
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [scrollView setContentSize:CGSizeMake(320, webView.frame.size.height +20)];
    
    if (webView.frame.size.height >1) {
        [[LoadingView showLoadingView] actViewStopAnimation];
    }else{
        NSURL *url = [NSURL URLWithString:kVisitAdress];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [_webView loadRequest:request];
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSURLCache sharedURLCache] setMemoryCapacity: 0];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

-(void)onClickBackBtn:(UIButton *)btn{
    if (btn.tag ==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{    // 生成并显示2维码
        NSString *codeStr =vm.codeUrl;
        oriCodeImg =[QRCodeGenerator qrImageForString:codeStr imageSize:kCodeImageSize];
        TMAlertView *alertView =[[TMAlertView alloc] initWithTitle:@"我的二维码" andUserPic:[[MyUserDefault standardUserDefaults] getUserPic] andProduceImg:oriCodeImg andIntroduce:@"扫描上方二维码，进入91淘金官网，即可下载专属安装包" okBtnTitle:@"保存" cancleTitle:@"取消"];
        alertView.TMAlertDelegate =self;
        [alertView showCodeView];
    }
}
-(void)onClickedSaveCodeImage{
    
    UIImageView *codeBgImage =[[UIImageView alloc] initWithImage:GetImage(@"codeBg@2x.png")];
    codeBgImage.frame =CGRectMake(0, 0, codeBgImage.image.size.width, codeBgImage.image.size.height);
    
    UIImageView *addImage =[[UIImageView alloc] initWithImage:oriCodeImg];
    addImage.frame =CGRectMake(40, 175, 320, 320);
    [codeBgImage addSubview:addImage];
    
    UIImageView *userImg =[[UIImageView alloc] initWithFrame:CGRectMake(175, 305, 50.0 , 50.0 )];
    UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(userImg.frame.origin.x -4, userImg.frame.origin.y -4, userImg.frame.size.width +8, userImg.frame.size.height +8)];
    backView.backgroundColor =[UIColor whiteColor];
    
    if ([[MyUserDefault standardUserDefaults] getUserPic]) {
        userImg.image =[UIImage imageWithData:[[MyUserDefault standardUserDefaults] getUserPic]];
    }else{
        NSString *userIconUrl =[[MyUserDefault standardUserDefaults] getUserIconUrl];
        [userImg setImageWithURL:[NSURL URLWithString:userIconUrl] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage imageNamed:@"touxiang2.png"]];
    }
    
    [codeBgImage addSubview:backView];
    [codeBgImage addSubview:userImg];
    
    UIImage *resultImg = [self getResultImageFrom:codeBgImage];
    UIImageWriteToSavedPhotosAlbum(resultImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}
-(UIImage *)getResultImageFrom:(UIImageView *)imageView {
    UIGraphicsBeginImageContext(CGSizeMake(imageView.bounds.size.width , imageView.bounds.size.height ));
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data =UIImagePNGRepresentation(result);
    result =[UIImage imageWithData:data];
    return result;
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error != NULL) {
        NSLog(@"  save fail ");
    }else{
        [StatusBar showTipMessageWithStatus:@"已成功保存到相册" andImage:GetImage(@"icon_yes.png") andTipIsBottom:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
