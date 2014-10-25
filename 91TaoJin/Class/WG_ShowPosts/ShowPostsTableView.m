//
//  ShowPostsTableView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-26.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowPostsTableView.h"
#import "MyUserDefault.h"
#import "ShowPostsCell.h"
#import "LoadingView.h"
#import "AsynURLConnection.h"
#import "UserShowPosts.h"
#import "UIImage+ColorChangeTo.h"
#import "ShowPostsDetailViewController.h"
#import "TablePullToLoadingView.h"
#import "TaoJinLabel.h"
#import "ViewTip.h"

#define MyShowPostsTip @"炫一炫您的宝贝\n让小伙伴羡慕嫉妒恨"

typedef enum {
    myPost = 0,
    allPost = 1
} ShowPostType;

@implementation ShowPostsTableView{
    BOOL _reloading;
    
    ShowPosts *_showPosts;                                           //晒单对象（全部）
    ShowPosts *_myShowPosts;                                         //晒单对象（我的）
    ShowPosts *_myOldPost;                                           //保存上一次的晒单对象（我的）
    
    ShowPosts *temporaryShowPosts;                                   //临时晒单对象（全部）
    ShowPosts *temporaryMyShowPosts;                                 //临时晒单对象（我的）
    
    
    int timeOutCount;                                               //超时次数
    int maxPage;                                                    //服务器的最大页数
    int currentId;                                                  //当前ID（用于判断是晒单广场还是我的晒单）
    
    
    int showGoldOne ;                                               //晒单奖励金豆数1
    int showGoldTwo ;                                               //晒单奖励金豆数2
    
    int pageNum;                                                    //当前的请求页数
    int temporaryLocalPageNumner;                                   //临时当前的请求页数
    BOOL isFrist;                                                   //标识是否第一次请求数据
    
    UserShowPosts *locaUser;
    
    int localRow;                                                   //加载到第几行
    
    ViewTip *tip;
    
    dispatch_queue_t queue;
}

@synthesize block = _block;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self setSeparatorColor:[UIColor clearColor]];
        [self refrushView];
        [self initObjects];
        TablePullToLoadingView *loadingView = [[TablePullToLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kTableLoadingViewHeight2_0)];
        self.tableFooterView = loadingView;
        self.tableFooterView.hidden = YES;
        self.isRequesting = NO;
        queue = dispatch_queue_create("com.91Taojin.ShowPostsTableView", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

/**
 *  点击跳转到晒单内容
 */
-(void)onClickedJoinShow{
//    [self.sptDelegate pushToCommentVCWithGold:showGoldOne goldTwo:showGoldTwo];
    
    CommentViewController *cvc = [[CommentViewController alloc] initWithNibName:nil bundle:nil];
    cvc.delegate = self;
    cvc.commentType = CommentTypeShow;
    cvc.showGoldOne = showGoldOne;
    cvc.showGoldTwo = showGoldTwo;
    UINavigationController *nc = (UINavigationController* )[UIApplication sharedApplication].keyWindow.rootViewController;
    [nc presentViewController:cvc animated:YES completion:^{
        
    }];
}

/**
 *  发表晒单成功后的回调
 *
 */
-(void)reloadView:(id)object{
    currentId = [[[MyUserDefault standardUserDefaults] getUserId] intValue];
    temporaryShowPosts = nil;
    pageNum = 1;
    if(tip){
        [tip removeFromSuperview];
        tip = nil;
    }
    if(_myShowPosts != nil){
        _myShowPosts = _myOldPost;
        _myShowPosts.showPosts_showNum --;            //晒单次数减一
        temporaryMyShowPosts = [_myShowPosts mutableCopy];
        /*
        self.showPostsHeadView.postType = WILLShowPosts;
        self.showPostsHeadView.showTextLab.text = @"下拉返回 [晒单广场]";
         */
        [self setButtonStatus];
        [self reloadData];
        [self performSelector:@selector(reloadTableData:) withObject:object afterDelay:0.5];
    }else{
        NSDictionary *dic = @{@"currentId":[NSNumber numberWithInt:currentId], @"Object":object};
        [self requestToGetShowPosts:dic];
    }
}

-(void)initObjects{
    pageNum = 1;
    showGoldOne =0;
    showGoldTwo =0;
    localRow = 1;
    isFrist = YES;
    _myShowPosts = nil;
    _myOldPost = nil;
    NSNumber *type = [[MyUserDefault standardUserDefaults] getShowPostsType];
    if(type == nil)
        currentId = 0;
    else{
        currentId = [type intValue];
    }
    NSDictionary *dic;
    dic = @{@"currentId":[NSNumber numberWithInt:currentId], @"Object":[[NSNull alloc] init]};
    /*
    if(currentId != 0){
//        self.showPostsHeadView.showTextLab.text = @"下拉显示 [晒单广场]";
        self.showPostsHeadView.postType = WILLShowPosts;
    }else{
//        self.showPostsHeadView.showTextLab.text = @"下拉显示 [我的晒单]";
        self.showPostsHeadView.postType = WILLMyPosts;
    }
     */
    [self requestToGetShowPosts:dic];
}

-(void)changeShowPostType:(int)typeId{
    pageNum = 1;
    showGoldOne =0;
    showGoldTwo =0;
    localRow = 1;
    isFrist = YES;
    _myShowPosts = nil;
    _myOldPost = nil;
    NSDictionary *dic;
    dic = @{@"currentId":[NSNumber numberWithInt:typeId], @"Object":[[NSNull alloc] init]};
    /*
    if(currentId != 0){
        //        self.showPostsHeadView.showTextLab.text = @"下拉显示 [晒单广场]";
        self.showPostsHeadView.postType = WILLShowPosts;
    }else{
        //        self.showPostsHeadView.showTextLab.text = @"下拉显示 [我的晒单]";
        self.showPostsHeadView.postType = WILLMyPosts;
    }
     */
    [self requestToGetShowPosts:dic];
}

-(void)refrushView{
    self.showPostsHeadView = [[ShowPostsHeadView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, 70.0f)];
    /*
    self.showPostsHeadView.delegate = self;
     */
    [self.showPostsHeadView.joinShowPostsBtn addTarget:self action:@selector(onClickedJoinShow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showPostsHeadView];
    /*
    [self.showPostsHeadView refreshLastUpdatedDate];
     */
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(currentId == 0){
        return [temporaryShowPosts.showPosts_shinesAry count] + 1;
    }else{
        return [temporaryMyShowPosts.showPosts_shinesAry count] + 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        static NSString *ShowPostsCellIdentifier = @"ShowPostsCell";
        ShowPostsCell *cell = [tableView dequeueReusableCellWithIdentifier:ShowPostsCellIdentifier];
        if(cell == nil){
            cell = [[ShowPostsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShowPostsCellIdentifier];
        }
        if(currentId == 0){
            if(indexPath.row - 1 < temporaryShowPosts.showPosts_shinesAry.count){
                [cell showCellContent:[temporaryShowPosts.showPosts_shinesAry objectAtIndex:indexPath.row - 1]];
            }
        }else{
            if(indexPath.row - 1  < temporaryMyShowPosts.showPosts_shinesAry.count){
                [cell showCellContent:[temporaryMyShowPosts.showPosts_shinesAry objectAtIndex:indexPath.row - 1]];
            }
        }
        return cell;
    }
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        /*
        BOOL isHavePullShowPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullShowPosts] boolValue];
        BOOL isHavePullMyPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullMyPosts] boolValue];
        if(isHavePullMyPosts && isHavePullShowPosts)
            return 55.0f;
        return 72.0f;
         */
        return 55.0f;
    }
    UserShowPosts *userShowPosts;
    if(currentId == 0){
        userShowPosts = [temporaryShowPosts.showPosts_shinesAry objectAtIndex:indexPath.row - 1];
    }else{
        userShowPosts = [temporaryMyShowPosts.showPosts_shinesAry objectAtIndex:indexPath.row - 1];
    }
    CGSize size = [userShowPosts.user_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kmainScreenWidth - 2 * Spacing2_0, 34.0f) lineBreakMode:NSLineBreakByTruncatingTail];
    return size.height + 146.5f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    UserShowPosts *user;
    if(currentId == 0){
        user = [temporaryShowPosts.showPosts_shinesAry objectAtIndex:indexPath.row - 1];
    }else{
        user = [temporaryMyShowPosts.showPosts_shinesAry objectAtIndex:indexPath.row - 1];
    }
    ShowPostsDetailViewController *detail = [[ShowPostsDetailViewController alloc] initWithDetail:user];
    UINavigationController *nc = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nc pushViewController:detail animated:YES];
}

/**
 *  请求获取晒单列表
 *
 *  @param showPostsId 获取晒单的用户ID，为0表示获取所有晒单
 */
-(void)requestToGetShowPosts:(NSDictionary *)localDic{
    _isRequesting = YES;
    int showPostsId = [[localDic objectForKey:@"currentId"] intValue];
    NSString *urlStr = [NSString stringWithFormat:kUrlPre,kOnlineWeb,@"ActivityUI",@"GetShowOrderList"];
    NSString *sid = [[MyUserDefault standardUserDefaults] getSid];
    NSDictionary *dic = @{@"sid": sid, @"PageNum":[NSString stringWithFormat:@"%d",pageNum], @"Uid":[NSString stringWithFormat:@"%d",showPostsId]};
    NSLog(@"获取晒单列表【urlStr】 = %@",urlStr);
    NSLog(@"获取晒单列表【request】 = %@",dic);
    [AsynURLConnection requestWithURL:urlStr dataDic:dic timeOut:httpTimeout success:^(NSData *data) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            timeOutCount = 0;
            NSLog(@"获取晒单列表【response】 = %@",dataDic);
            int flag = [[dataDic objectForKey:@"flag"] intValue];
            if(flag == 1){
                NSDictionary *body = [dataDic objectForKey:@"body"];
                maxPage = [[body objectForKey:@"MaxPage"] intValue];
                showGoldOne =[[body objectForKey:@"Gold1"] intValue];
                showGoldTwo =[[body objectForKey:@"Gold2"] intValue];
                int curNum = [[body objectForKey:@"CurNum"] intValue];
                if(pageNum == 1){
                    if(showPostsId == 0){
                        _showPosts = [[ShowPosts alloc] initWithShowPostId:[body objectForKey:@"Uid"] showNum:[[body objectForKey:@"ShowNum"] intValue] golds1:[[body objectForKey:@"Gold1"] intValue] golds2:[[body objectForKey:@"Gold2"] intValue] shinesAry:[body objectForKey:@"Shines"]];
                    }else{
                        _myShowPosts = [[ShowPosts alloc] initWithShowPostId:[body objectForKey:@"Uid"] showNum:[[body objectForKey:@"ShowNum"] intValue] golds1:[[body objectForKey:@"Gold1"] intValue] golds2:[[body objectForKey:@"Gold2"] intValue] shinesAry:[body objectForKey:@"Shines"]];
                        _myOldPost = _myShowPosts;
                    }
                    
                }else{
                    if(showPostsId == 0){
                        [_showPosts insertShinesAry:[body objectForKey:@"Shines"]];
                    }else{
                        [_myShowPosts insertShinesAry:[body objectForKey:@"Shines"]];
                        _myOldPost = _myShowPosts;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(pageNum == 1){
                        if(curNum == 0 && showPostsId != 0){
                            tip = [[ViewTip alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kmainScreenHeigh)];
                            [tip setViewTipByImage:[UIImage imageNamed:@"a3.png"]];
                            [tip setViewTipByContent:MyShowPostsTip];
                            [self insertSubview:tip atIndex:0];
                        }else {
                            if(tip != nil){
                                [tip removeFromSuperview];
                                tip = nil;
                            }
                        }
                        currentId = showPostsId;
                        //复制一份临时对象
                        if(currentId == 0){
                            temporaryShowPosts = [_showPosts mutableCopy];
                            localRow = _showPosts.showPosts_shinesAry.count;
                        }else{
                            temporaryMyShowPosts = [_myShowPosts mutableCopy];
                            localRow = _myShowPosts.showPosts_shinesAry.count;
                        }
                        [self reloadData];
                        isFrist = NO;
                    }else{
                        [self reloadTableData:nil];
                    }
                    _isRequesting = NO;
                    self.tableFooterView.hidden = YES;
                    [self setButtonStatus];
                    pageNum ++;
                    temporaryLocalPageNumner = pageNum;
                    [[MyUserDefault standardUserDefaults] setShowPostsType:currentId];
                    /*
                    [self.showPostsHeadView setState:ShowPostsPullRefreshNormal];
                     */
                    [[LoadingView showLoadingView] actViewStopAnimation];
                    
                    if(self.block){
                        self.block();
                    }
                });
            }
        });
    } fail:^(NSError *error) {
        NSLog(@"获取晒单列表【error】 = %@",error);
        if(error.code == timeOutErrorCode){
            //连接超时
            if(timeOutCount < 2){
                timeOutCount ++;
                [self requestToGetShowPosts:localDic];
            }else{
                timeOutCount = 0;
                _isRequesting = NO;
                [[LoadingView showLoadingView] actViewStopAnimation];
            }
        }
    }];
}

/**
 *  设置晒单按钮的状态
 */
-(void)setButtonStatus{
    if(temporaryShowPosts.showPosts_showNum > 0 || _myShowPosts.showPosts_showNum > 0){
        if(currentId == 0){
            [self.showPostsHeadView.joinShowPostsBtn setTitle:[NSString stringWithFormat:@"您有%d次晒单机会",temporaryShowPosts.showPosts_showNum] forState:UIControlStateNormal];
        }else{
            [self.showPostsHeadView.joinShowPostsBtn setTitle:[NSString stringWithFormat:@"您有%d次晒单机会",_myShowPosts.showPosts_showNum] forState:UIControlStateNormal];
        }
        [self.showPostsHeadView.joinShowPostsBtn setBackgroundImage:[UIImage createImageWithColor:KGreenColor2_0] forState:UIControlStateNormal];
        [self.showPostsHeadView.joinShowPostsBtn setBackgroundImage:[UIImage createImageWithColor:KLightGreenColor2_0] forState:UIControlStateHighlighted];
        [self.showPostsHeadView.joinShowPostsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.showPostsHeadView.joinShowPostsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.showPostsHeadView.joinShowPostsBtn setEnabled:YES];
    }else{
        [self.showPostsHeadView.joinShowPostsBtn setTitle:@"请兑换实物奖品后参与晒单" forState:UIControlStateDisabled];
        [self.showPostsHeadView.joinShowPostsBtn setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateDisabled];
        [self.showPostsHeadView.joinShowPostsBtn setTitleColor:KGreenColor2_0 forState:UIControlStateDisabled];
        [self.showPostsHeadView.joinShowPostsBtn setEnabled:NO];
    }
}

- (void)reloadTableViewDataSource{
    _reloading = YES;
    isFrist = NO;
    pageNum = 1;
    if(currentId != 0){
        _showPosts = nil;
    }else{
        _myShowPosts = nil;
    }
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    if(self.showPostsHeadView.postType == WILLMyPosts){
        self.showPostsHeadView.postType = WILLShowPosts;
        BOOL isHavePullShowPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullShowPosts] boolValue];
        if(!isHavePullShowPosts){
//            [[MyUserDefault standardUserDefaults] setIsHavePullShowPosts:[NSNumber numberWithBool:YES]];
            [[MyUserDefault standardUserDefaults] setIsHavePullShowPosts:[NSNumber numberWithBool:NO]];
        }
    }else{
        self.showPostsHeadView.postType = WILLMyPosts;
        BOOL isHavePullMyPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullMyPosts] boolValue];
        if(!isHavePullMyPosts){
//            [[MyUserDefault standardUserDefaults] setIsHavePullMyPosts:[NSNumber numberWithBool:YES]];
            [[MyUserDefault standardUserDefaults] setIsHavePullMyPosts:[NSNumber numberWithBool:NO]];
        }
    }
    [self.showPostsHeadView showPostsRefreshScrollViewDataSourceDidFinishedLoading:self];
}

-(void)reloadTableData:(id)object{
    if(object != nil){
        NSDictionary *dic = (NSDictionary *)object;
        [_myShowPosts insertShinesDic:dic];
        [temporaryMyShowPosts insertShinesDic:dic];
        [self performSelector:@selector(insertMyShowPosts) withObject:nil afterDelay:0.2];
    }else{
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        if(currentId == 0){
            for (int i = localRow; i < _showPosts.showPosts_shinesAry.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+1 inSection:0];
                [paths addObject:indexPath];
                [temporaryShowPosts.showPosts_shinesAry insertObject:[_showPosts.showPosts_shinesAry objectAtIndex:i] atIndex:temporaryShowPosts.showPosts_shinesAry.count];
            }
            NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:localRow+1 inSection:0];
            localRow = temporaryShowPosts.showPosts_shinesAry.count;
            [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationFade];
            [UIView animateWithDuration:0.5f animations:^{
//                [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }];
        }else{
            for (int i = localRow; i < _myShowPosts.showPosts_shinesAry.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+1 inSection:0];
                [paths addObject:indexPath];
                [temporaryMyShowPosts.showPosts_shinesAry insertObject:[_myShowPosts.showPosts_shinesAry objectAtIndex:i] atIndex:temporaryMyShowPosts.showPosts_shinesAry.count];
            }
            NSIndexPath *localIndexPath = [NSIndexPath indexPathForRow:localRow+1 inSection:0];
            localRow = temporaryMyShowPosts.showPosts_shinesAry.count;
            [self insertRowsAtIndexPaths:[NSArray arrayWithArray:paths] withRowAnimation:UITableViewRowAnimationFade];
            [UIView animateWithDuration:0.5f animations:^{
//                [self scrollToRowAtIndexPath:localIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }];
        }
//        [self reloadData];
    }
}

-(void)insertMyShowPosts{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [UIView animateWithDuration:0.3f animations:^{
        if(temporaryMyShowPosts.showPosts_shinesAry.count > 1){
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }completion:^(BOOL finished) {
        if(finished){
            if(tip != nil){
                [tip removeFromSuperview];
                tip = nil;
            }
            if(temporaryMyShowPosts.showPosts_shinesAry.count > 1){
                [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            }else{
                [self reloadData];
            }
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(self.showPostsHeadView.state == ShowPostsPullRefreshNormal){
        [self.showPostsHeadView showPostsRefreshScrollViewDidScroll:scrollView];
        self.tableFooterView.hidden = YES;
//    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float y_float = self.contentOffset.y;
    if (y_float < 0)
        return;

    int count = 0;
    if(currentId == 0){
        count = temporaryShowPosts.showPosts_shinesAry.count;
    }else{
        count = temporaryMyShowPosts.showPosts_shinesAry.count;
    }
    if(count != 0 && temporaryLocalPageNumner <= maxPage && self.tableFooterView.hidden == YES){
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        if(y > h - 1) {
            self.tableFooterView.hidden = NO;
            NSDictionary *dic = @{@"currentId":[NSNumber numberWithInt:currentId], @"Object":[[NSNull alloc] init]};
            [self requestToGetShowPosts:dic];
        }else{
            self.tableFooterView.hidden = YES;
        }
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.showPostsHeadView showPostsRefreshScrollViewDidEndDragging:scrollView];
}


-(void)showPostsRefreshTableHeaderDidTriggerRefresh:(ShowPostsHeadView *)view{
    if(self.showPostsHeadView.state == ShowPostsPullRefreshPulling){
        if(currentId == 0){
            currentId = [[[MyUserDefault standardUserDefaults] getUserId] intValue];
        }else{
            currentId = 0;
        }
        [[MyUserDefault standardUserDefaults] setShowPostsType:currentId];
        localRow = 1;
        [self reloadTableViewDataSource];
        [self doneLoadingTableViewData];
    }
}

- (BOOL)showPostsRefreshTableHeaderDataSourceIsLoading:(ShowPostsHeadView *)view{
    return _reloading;
}


- (void)showPostsBeginToRequestData{
    NSDictionary *dic = @{@"currentId": [NSNumber numberWithInt:currentId], @"Object":[[NSNull alloc] init]};
    [self performSelector:@selector(requestToGetShowPosts:) withObject:dic afterDelay:1.0];
}
@end












