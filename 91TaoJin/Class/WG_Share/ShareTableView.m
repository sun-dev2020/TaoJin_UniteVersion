//
//  ShareTableView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShareTableView.h"
#import "ShareCell.h"
#import "AsynURLConnection.h"
#import "MyUserDefault.h"
#import "LoadingView.h"
#import "UIAlertView+NetPrompt.h"
#import "TablePullToLoadingView.h"
#import "StatusBar.h"
#import "ShareItem.h"
#import "NSString+md5Code.h"
#import "TJViewController.h"
#import "ActivityCenterViewController.h"
#import "AppDelegate.h"
#import "UniversalTip.h"
@implementation ShareTableView
{
    NSDictionary *dicTest;
    int timeOutCount;
    int maxPage;
    int curPage;
    int page;
    int temporaryLocalPageNumner;
    
    id <ISSShareActionSheetItem> sinaItem;
    
    dispatch_queue_t queue;
    
    NSMutableArray *temporaryAllShares;                                     //临时【分享有奖】数据
    int localRow;                                                           //加载到第几行
    
    TaoJinButton *markBtn;      //作标记使用
    UIAlertView *tipAlert ;
    id <ISSShareActionSheet> shareSheet;
    __block UniversalTip * tipView;
    
    int shareTimeOut ;
}
@synthesize allShares = _allShares;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.delaysContentTouches =NO;
        [self setSeparatorColor:[UIColor clearColor]];
        TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] init];
        self.tableFooterView = loadingView;
        self.tableFooterView.hidden = YES;
        
        self.sectionIndexColor = nil;
        
        self.isRequesting = NO;
        queue = dispatch_queue_create("com.91Taojin.ShareTableView", DISPATCH_QUEUE_SERIAL);
        [self initObjects];
        
        page =1;
        timeOutCount = 0;
        shareTimeOut = 0;
    }
    return self;
}

-(void)initObjects{
    page = 1;
    timeOutCount = 0;
    localRow = 0;
    if (!tipView) {
        NSArray *array =[[NSArray alloc] initWithObjects:@"1.分享成功后，需点击“返回91淘金”，才能确保获取金豆奖励；",@"2.分享内容请勿随意删除，如好友通过您的分享的内容安装并试玩91淘金，您将获得邀请奖励。", nil];
        tipView =[[UniversalTip alloc] initWithFrame:CGRectMake(10, 170, kmainScreenWidth -20, 0) andTips:array andTipBackgrundColor:[UIColor whiteColor] withTipFont:[UIFont systemFontOfSize:11.0] andTipImage:GetImage(@"dengpao_orange") andTipTitle:@"分享提示：" andTextColor:KOrangeColor2_0];
        [tipView uploadTipContent:array andFont:[UIFont systemFontOfSize:11.0] andTextColor:KOrangeColor2_0 needAdjustPosition:YES];
        if (kmainScreenHeigh == 480.0f) {
            tipView.frame =CGRectMake(10, 80, kmainScreenWidth -20, tipView.frame.size.height);
        }
        tipView.alpha = 0.0;
        tipView.layer.cornerRadius =10.0;
    }
    
    [self sendRequestForShare];
}

-(void)sendRequestForShare{
    _isRequesting = YES;
    if (_allShares == nil || _allShares.count == 0) {
        [[LoadingView showLoadingView] actViewStartAnimation];
    }
    NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
    NSString *url =[NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"GetShareReward"];
    int randNum =arc4random()/10000;
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:sid,@"sid",[NSNumber numberWithInt:page],@"PageNum", [NSNumber numberWithInt:randNum],@"randNum",nil];
    [AsynURLConnection requestWithURL:url dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary * dataDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@" dataDIc  %@" ,dataDic);
            if ([[dataDic objectForKey:@"flag"]integerValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                maxPage =[[body objectForKey:@"MaxPage"] intValue];
                curPage =[[body objectForKey:@"CurPage"] intValue];
                if (body) {
                    NSArray *shareArr =[body objectForKey:@"Shares"];
                    if (shareArr.count !=0) {
                        if (page == 1 ) {
                            if(_allShares == nil){
                                _allShares =[[NSMutableArray alloc] initWithArray:shareArr];
                            }else{
                                [_allShares removeAllObjects];
                                [_allShares insertObjects:shareArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, shareArr.count)]];
                            }
                        }else{
                            [_allShares insertObjects:shareArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_allShares.count, shareArr.count)]];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(temporaryAllShares == nil){
                                //第一次空白加载
                                temporaryAllShares = [[NSMutableArray alloc] initWithArray:_allShares];
                                [self reloadData];
                            }else{
                                if(localRow == 0){
                                    //切换加载
                                    [temporaryAllShares removeAllObjects];
                                    [temporaryAllShares insertObjects:_allShares atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _allShares.count)]];
                                    [self reloadData];
                                }else{
                                    //向下加载
                                    NSMutableArray *paths = [[NSMutableArray alloc] init];
                                    for (int i = localRow; i < _allShares.count; i++) {
                                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                        [paths addObject:indexPath];
                                        [temporaryAllShares insertObject:[_allShares objectAtIndex:i] atIndex:temporaryAllShares.count];
                                    }
                                    [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationFade];
                                    NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:localRow inSection:0];
                                    [UIView animateWithDuration:0.5f animations:^{
                                        //                                        [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                                    }];
                                }
                            }
                            page ++;
                            temporaryLocalPageNumner = page;
                            localRow = temporaryAllShares.count;
                            _isRequesting = NO;
                            self.tableFooterView.hidden = YES;
                        });
                    }
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    self.tableFooterView.hidden = YES;
                    _isRequesting = NO;
                });
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView showLoadingView] actViewStopAnimation];
                _isRequesting = NO;
            });
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(timeOutCount < 2){
                timeOutCount ++;
                [self sendRequestForShare];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                timeOutCount = 0;
                self.tableFooterView.hidden = YES;
                if(![UIAlertView isInit]){
                    UIAlertView *alertView = [UIAlertView showNetAlert];
                    alertView.tag = kTimeOutTag;
                    alertView.delegate = self;
                    [alertView show];
                }
            }
        }else{
            [[LoadingView showLoadingView] actViewStopAnimation];
            self.tableFooterView.hidden = YES;
        }
        _isRequesting = NO;
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return temporaryAllShares.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ShareCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.shareContent =[[SharkContent alloc] initWithShareDictionary:[temporaryAllShares objectAtIndex:indexPath.row]];
    cell.tag =indexPath.row;
    [cell showShareCellContent];
    [cell.praiseBtn addTarget:self action:@selector(onClickedPraise:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.tag =cell.tag;
    [cell.shareBtn addTarget:self action:@selector(onClickedShare:) forControlEvents:UIControlEventTouchUpInside];
    for (UIView *currentView in cell.subviews)
    {
        if([currentView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShareCell *cell =(ShareCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell getShareCellHeight];
}
-(void)onClickedShare:(TaoJinButton *)btn{   // 分享
    SharkContent *shareObj =[[SharkContent alloc] initWithShareDictionary:[_allShares objectAtIndex:btn.tag]];
    NSString *shareContent = shareObj.share_content;
    NSString *shareHead =shareObj.share_headContent;
    NSString *imageUrl =shareObj.share_imageUrl;
    NSString *webUrl =shareObj.share_shareUrl;
    id <ISSContent> publishContent =[ShareSDK content:shareContent defaultContent:shareContent image:[ShareSDK imageWithUrl:imageUrl] title:kShareTitle url:webUrl description:shareContent mediaType:SSPublishContentMediaTypeText];
    [ShareSDK ssoEnabled:YES];
    
    //qq zone
    [publishContent addQQSpaceUnitWithTitle:kShareTitle url:webUrl site:nil fromUrl:nil comment:nil summary:shareContent image:[ShareSDK imageWithUrl:imageUrl] type:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews] playUrl:nil nswb:[NSNumber numberWithInteger:1]];
    
    //qq 好友
    [publishContent addQQUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews] content:shareContent title:kShareTitle url:webUrl image:[ShareSDK imageWithUrl:imageUrl]];
    
    shareContent =[shareHead stringByAppendingString:shareContent];   // 一下4个平台需要 拼接前缀
    // 微信 好友 内容单元
    [publishContent addWeixinSessionUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText] content:shareContent title:kShareTitle url:webUrl image:[ShareSDK imageWithUrl:imageUrl] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    
    // 微信 朋友圈 内容单元
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeText] content:shareContent title:kShareTitle url:webUrl image:[ShareSDK imageWithUrl:imageUrl] musicFileUrl:nil extInfo:nil fileData:nil emoticonData:nil];
    
    // 腾讯微博
    [publishContent addTencentWeiboUnitWithContent:shareContent image:[ShareSDK imageWithUrl:imageUrl]];
    
    // 新浪微博    控制字数
    //    NSLog(@"  shareContent %@ %d",shareContent ,shareContent.length);
    if (shareContent.length > 140) {
        shareContent =[shareContent substringToIndex:140];
    }
    if ([imageUrl hasPrefix:@"http"]) {
        [publishContent addSinaWeiboUnitWithContent:shareContent image:[ShareSDK imageWithUrl:imageUrl]];     //sina 发布微博高级接口传入的为图片url地址
    }else{
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"shareAA" ofType:@".png"];
        [publishContent addSinaWeiboUnitWithContent:shareContent image:[ShareSDK imageWithPath:imagePath]];   // sina 发布微博普通接口传入的为image
    }
    
    
    ActivityCenterViewController *tj =[[ActivityCenterViewController alloc] init];
    id <ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:tj];
    //    id <ISSViewDelegate>
    id <ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:SSAuthViewStyleFullScreenPopup viewDelegate:nil authManagerViewDelegate:nil];
    [authOptions setPowerByHidden:YES]; //隐藏logo
    
    NSMutableArray * items =[[NSMutableArray alloc] init];
    NSArray *shareImgs =[NSArray arrayWithObjects:GetImage(@"sina"),GetImage(@"tencent"),GetImage(@"qzone"),GetImage(@"qq"),GetImage(@"wechat"),GetImage(@"timeLine"), nil];
    NSArray *types =[NSArray arrayWithObjects:SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),SHARE_TYPE_NUMBER(ShareTypeQQSpace),SHARE_TYPE_NUMBER(ShareTypeQQ),SHARE_TYPE_NUMBER(ShareTypeWeixiSession),SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline), nil];
    for (int i=0; i <shareObj.share_list.count; i++) {
        id <ISSShareActionSheetItem> item;
        UIImage *logoImg =[shareImgs objectAtIndex:i];
        ShareItem *shareItem =[[ShareItem alloc] initWithShareItem:[shareObj.share_list objectAtIndex:i]];
        
        //根据这2个id生成一个标记，区分不同分享活动的不同分享平台的是否分享状态
        NSString *markTag =[NSString stringWithFormat:@"%@%d",shareObj.share_ID ,shareItem.shareItem_itemId];
        
        if (shareItem.shareItem_isShared ==1 || [[[NSUserDefaults standardUserDefaults] objectForKey:markTag] intValue] ==1) {
            item =[ShareSDK shareActionSheetItemWithTitle:@"已分享" icon:logoImg clickHandler:^{
                [self clickHandlerWithShareContent:publishContent type:[[types objectAtIndex:i] intValue] andAuthOptions:authOptions andShareMark:markTag shareContentId:shareObj.share_ID andShareId:[NSString stringWithFormat:@"%d",shareItem.shareItem_itemId]];
            }];
            
        }else {
            NSString *shareGold =[NSString stringWithFormat:@"+%@",shareItem.shareItem_gold];
            item =[ShareSDK shareActionSheetItemWithTitle:shareGold icon:logoImg clickHandler:^{
                [self clickHandlerWithShareContent:publishContent type:[[types objectAtIndex:i] intValue] andAuthOptions:authOptions andShareMark:markTag shareContentId:shareObj.share_ID andShareId:[NSString stringWithFormat:@"%d",shareItem.shareItem_itemId]];
            }];
            
        }
        [items addObject:item];
    }
    
    
    shareSheet = [ShareSDK showShareActionSheet:container shareList:items content:publishContent statusBarTips:YES authOptions:authOptions shareOptions:nil result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSResponseStateCancel) {
            [UIView animateWithDuration:0.5f animations:^{
                tipView.alpha = 0.0;
            }];
        }
    }];
    UIWindow *win =[[UIApplication sharedApplication].windows lastObject];
    [UIView animateWithDuration:0.5f animations:^{
        tipView.alpha =1.0 ;
        [win addSubview:tipView];
    }];
    
    
}
-(void)showView{
}
-(void)sendShareState:(int) shareState andShareType:(int) type andShareMark:(NSString *)shareMark shareContentId:(NSString *)shareCntId andShareId:(NSString *) shareId{
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
    [self requestToSetInviteShare:typeStr shareState:shareState andShareMark:shareMark shareContentId:shareCntId andShareId:shareId];
}

//请求发送分享统计
-(void)requestToSetInviteShare:(NSString *)typeStr shareState:(int)shareState andShareMark:(NSString *)shareMark shareContentId:(NSString *)shareCntId andShareId:(NSString *) shareId{
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSString *sign =[NSString stringWithFormat:@"%@%@%@",sid,shareCntId, shareId];
    sign =[NSString md5Code:sign];
    // 加一个随机数  防止返回数据重复
    int randNum = arc4random() /10000;
    NSDictionary *dic = @{@"sid": sid, @"Shid":shareCntId, @"ShareId":shareId, @"Sign":sign ,@"timeRan":[NSNumber numberWithInt:randNum]};
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"GetShareRewardGold"];
    NSLog(@"请求发送分享统计【urlStr】 = %@",dic);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求发送分享统计【response】 = %@",dic);
            if ([[dic objectForKey:@"flag"] intValue] ==1) {
                if (shareMark!=nil) {
                    NSDictionary *body =[dic objectForKey:@"body"];
                    if ([[body objectForKey:@"Gold"]intValue]!= 0) {
                        NSString *gold =[NSString stringWithFormat:@"+%@",[[body objectForKey:@"Gold"] stringValue]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [StatusBar showTipMessageWithStatus:@"分享成功" andImage:GetImage(@"icon_yes.png") andCoin:gold andSecImage:GetImage(@"tipBean.png") andTipIsBottom:YES];
                        });
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [StatusBar showTipMessageWithStatus:@"分享成功" andImage:GetImage(@"icon_yes.png") andTipIsBottom:YES];
                        });
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:shareMark];
                }
                
            }
        });
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)clickHandlerWithShareContent:(id<ISSContent>)publishContent type:(ShareType)type andAuthOptions:(id<ISSAuthOptions>)authOptions andShareMark:(NSString *)shareMark shareContentId:(NSString *)shareCntId andShareId:(NSString *) shareId{
    NSLog(@"   分享平台id ==%@ ",shareId);
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:authOptions
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        NSLog(@"  分享响应  %d %d",state ,type);
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                            [self sendShareState:state andShareType:type andShareMark:shareMark shareContentId:shareCntId andShareId:shareId];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                        }else if (state ==SSPublishContentStateBegan){
                            
                        }
                    }];
    
}


-(void)onClickedPraise:(TaoJinButton *)btn{   // 点赞
    markBtn =btn;
    SharkContent *shareCnt =[[SharkContent alloc] initWithShareDictionary:[temporaryAllShares objectAtIndex:btn.tag]];
    UIImage *bgImage =[btn imageForState:UIControlStateNormal];
    if (shareCnt.share_isPra ==1 || [bgImage isEqual:GetImage(@"praise_select")]) {
        tipAlert =[[UIAlertView alloc] initWithTitle:@"分享获取更多金豆" message:@"您已经点赞过了，分享内容可获得更多金豆奖励" delegate:self cancelButtonTitle:@"赚够了" otherButtonTitles:@"分享", nil];
        
        [tipAlert show];
    }else if ([bgImage isEqual:GetImage(@"praise_unSelect")] && shareCnt.share_isPra ==0){
        
        // 本地改变数据里的点赞数
        NSDictionary *dic =[temporaryAllShares objectAtIndex:btn.tag];
        int praiseNum =[shareCnt.share_pariseNum intValue] +1;
        [dic setValue:[NSString stringWithFormat:@"%d",praiseNum] forKey:@"PraiseNum"];
        [temporaryAllShares replaceObjectAtIndex:btn.tag withObject:dic];
        
        //改变数据状态
        [dic setValue:[NSString stringWithFormat:@"1"] forKey:@"IsPra"];
        [temporaryAllShares replaceObjectAtIndex:markBtn.tag withObject:dic];
        
        [btn setImage:GetImage(@"praise_select") forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"%d",praiseNum] forState:UIControlStateNormal];
        
        // 发送点赞请求
        [self performSelector:@selector(sendRequestForPraiseWithId:) onThread:[NSThread currentThread] withObject:shareCnt.share_ID waitUntilDone:NO];
        
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==1) {
        [tipAlert dismissWithClickedButtonIndex:1 animated:NO];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==1 && [alertView isEqual:tipAlert]) {
        [self onClickedShare:markBtn];
    }
}

-(void)sendRequestForPraiseWithId:(NSString *)shareID{
    [[LoadingView showLoadingView] actViewStartAnimation];
    NSString *sid =[[MyUserDefault standardUserDefaults] getSid];
    NSString *url =[NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"PutShareRewardUp"];
    NSString *sign =[self md5CodeString:sid andStr:shareID];
    int rand =arc4random() /10000;
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:sid,@"sid",shareID,@"Shid",sign ,@"Sign",[NSNumber numberWithInt:rand] ,@"randNum",nil];
    [AsynURLConnection requestWithURL:url dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"  点赞 ==%@" ,dataDic);
            if ([[dataDic objectForKey:@"flag"] intValue] ==1) {
                NSDictionary *body =[dataDic objectForKey:@"body"];
                //改变数据状态
                NSDictionary* dic = [temporaryAllShares objectAtIndex:markBtn.tag];
                [dic setValue:[NSString stringWithFormat:@"1"] forKey:@"IsPra"];
                [temporaryAllShares replaceObjectAtIndex:markBtn.tag withObject:dic];
                if (body) {
                    if ([[body objectForKey:@"Status"]intValue] ==0) {
                        int rewardGld = [[body objectForKey:@"Gold"]intValue];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            tipAlert =[[UIAlertView alloc] initWithTitle:@"分享获取更多金豆" message:[NSString stringWithFormat:@"通过点赞获取%d 金豆奖励，分享内容可获取更多金豆奖励",rewardGld] delegate:self cancelButtonTitle:@"赚够了" otherButtonTitles:@"分享", nil];
                            [tipAlert show];
                        });
                        
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[LoadingView showLoadingView] actViewStopAnimation];
            });
        });
    } fail:^(NSError *error) {
        if(error.code == timeOutErrorCode){
            if(shareTimeOut < 2){
                shareTimeOut ++;
                [self sendRequestForPraiseWithId:shareID];
            }else{
                [[LoadingView showLoadingView] actViewStopAnimation];
                shareTimeOut = 0;
                self.tableFooterView.hidden = YES;
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
-(NSString *)md5CodeString:(NSString *)sid andStr:(NSString *)shareId{
    NSString *token =[shareId stringByAppendingString:sid];
    const char *cStr = [token UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float y_float = self.contentOffset.y;
    if (y_float < 0)
        return;
    
    if (temporaryAllShares.count != 0 && temporaryLocalPageNumner <= maxPage && self.tableFooterView.hidden == YES) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        if(y > h - 1) {
            self.tableFooterView.hidden = NO;
            [self sendRequestForShare];
        }else{
            self.tableFooterView.hidden = YES;
        }
    }else{
        self.tableFooterView.hidden =YES;
    }
}

@end





