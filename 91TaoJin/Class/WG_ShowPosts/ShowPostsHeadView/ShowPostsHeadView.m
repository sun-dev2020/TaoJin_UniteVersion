//
//  ShowPostsHeadView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-26.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ShowPostsHeadView.h"
#import "TaoJinLabel.h"
#import "MyUserDefault.h"
#import "UIImage+ColorChangeTo.h"

#define FLIP_ANIMATION_DURATION                                                 0.2f
#define offsetY                                                                 34.0f

@interface ShowPostsHeadView ()

@end



@implementation ShowPostsHeadView{

}

@synthesize delegate = _delegate;
@synthesize joinShowPostsBtn = _joinShowPostsBtn;
@synthesize postType = _postType;
@synthesize showTextLab = _showTextLab;
@synthesize state = _state;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
        /*
        //初始化下拉显示的文案
        _showTextLab = [[[TaoJinLabel alloc] initWithFrame:CGRectZero text:@"" font:[UIFont boldSystemFontOfSize:11.0f] textColor:KGreenColor2_0 textAlignment:NSTextAlignmentCenter numberLines:1] autorelease];
            [self addSubview:_showTextLab];
         */
        //初始化晒单按钮
        _joinShowPostsBtn = [[TaoJinButton alloc] initWithFrame:CGRectMake(Spacing2_0, 12.5f, kmainScreenWidth - 2 * Spacing2_0, 40.0f) titleStr:@"请兑换实物奖品后参与晒单" titleColor:KGreenColor2_0 font:[UIFont systemFontOfSize:16] logoImg:nil backgroundImg:[UIImage createImageWithColor:kBlockBackground2_0]];
//        [_joinShowPostsBtn addTarget:self action:@selector(showPostsAction:) forControlEvents:UIControlEventTouchUpInside];
        _joinShowPostsBtn.userInteractionEnabled = YES;
        [self addSubview:_joinShowPostsBtn];
        
        /*
		CALayer *arrowLay = [CALayer layer];
        UIImage *arrowImg = [UIImage imageNamed:@"down_arrow"];
//        arrowLay.frame = CGRectMake(25.0f, frame.size.height , 30.0f, 55.0f);
		arrowLay.frame = CGRectMake(0.0f, frame.size.height, arrowImg.size.width, arrowImg.size.height);
		arrowLay.contentsGravity = kCAGravityResizeAspect;
		arrowLay.contents = (id)arrowImg.CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			arrowLay.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:arrowLay];
		_arrowImage = arrowLay;

//		_activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        _activityView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_loding1"]];
        NSMutableArray *_activityAry = [[NSMutableArray alloc] initWithCapacity:8];
        for(int i = 1 ; i <= 8 ; i ++){
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"arrow_loding%d",i]];
            [_activityAry addObject:image];
        }
        _activityView.animationImages = _activityAry;
        _activityView.animationDuration = 0.5f;
        _activityView.frame = CGRectZero;
		[self addSubview:_activityView];
		
		[self setState:ShowPostsPullRefreshNormal];
         */
    }
    return self;
}

-(void)showPostsAction:(id)sender{
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	if ([_delegate respondsToSelector:@selector(showPostsRefreshTableHeaderDataSourceLastUpdated:)]) {

	} else {
		
	}
    
}

- (void)setState:(ShowPostsPullRefreshState)aState{
	
	switch (aState) {
		case ShowPostsPullRefreshPulling:
			_showTextLab.text = @"释放立即加载";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
            BOOL isHavePullShowPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullShowPosts] boolValue];
            BOOL isHavePullMyPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullMyPosts] boolValue];
            float y = - offsetY/2;
            if(!isHavePullShowPosts || !isHavePullMyPosts){
                y = 9.0;
            }
			_arrowImage.frame = CGRectMake(_showTextLab.frame.origin.x - _arrowImage.frame.size.width - Spacing2_0, y , _arrowImage.frame.size.width, _arrowImage.frame.size.height);
			break;
		case ShowPostsPullRefreshNormal:
			
			if (_state == ShowPostsPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            if(_postType == WILLMyPosts){
                _showTextLab.text = @"下拉进入 [我的晒单]";
                [_showTextLab sizeToFit];
                BOOL isHavePullShowPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullShowPosts] boolValue];
                float y = - offsetY/2;
                if(!isHavePullShowPosts){
                    y = 9.0;
                }else{
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    _joinShowPostsBtn.frame = CGRectMake(_joinShowPostsBtn.frame.origin.x, 15.0f, _joinShowPostsBtn.frame.size.width, _joinShowPostsBtn.frame.size.height);
                    [UIView commitAnimations];
                }
                _showTextLab.frame = CGRectMake(kmainScreenWidth/2 - _showTextLab.frame.size.width/2, y, _showTextLab.frame.size.width, _showTextLab.frame.size.height);
                _arrowImage.frame = CGRectMake(_showTextLab.frame.origin.x - _arrowImage.frame.size.width - Spacing2_0, y - 2.0f, _arrowImage.frame.size.width, _arrowImage.frame.size.height);
                
                [_activityView stopAnimating];
                _activityView.hidden = YES;
//                [CATransaction begin];
//                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = NO;
                _arrowImage.transform = CATransform3DIdentity;
//                [CATransaction commit];
			}else if(_postType == WILLShowPosts){
                _showTextLab.text = @"下拉返回 [晒单广场]";
                [_showTextLab sizeToFit];
                BOOL isHavePullMyPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullMyPosts] boolValue];
                float y = - offsetY/2;
                if(!isHavePullMyPosts){
                    y = 9.0;
                }else{
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.3];
                    _joinShowPostsBtn.frame = CGRectMake(_joinShowPostsBtn.frame.origin.x, 15.0f, _joinShowPostsBtn.frame.size.width, _joinShowPostsBtn.frame.size.height);
                    [UIView commitAnimations];
                }
                _showTextLab.frame = CGRectMake(kmainScreenWidth/2 - _showTextLab.frame.size.width/2, y, _showTextLab.frame.size.width, _showTextLab.frame.size.height);
                _arrowImage.frame = CGRectMake(_showTextLab.frame.origin.x - _arrowImage.frame.size.width - Spacing2_0, y - 2.0f, _arrowImage.frame.size.width, _arrowImage.frame.size.height);
                [_activityView stopAnimating];
//                [CATransaction begin];
//                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _activityView.hidden = YES;
                _arrowImage.hidden = NO;
                _arrowImage.transform = CATransform3DIdentity;
//                [CATransaction commit];
            }
			[self refreshLastUpdatedDate];
			
			break;
		case ShowPostsPullRefreshLoading:
			_activityView.alpha = 1.0f;
			_showTextLab.text = @"正在加载中";
            _activityView.frame = CGRectMake(_arrowImage.frame.origin.x, _arrowImage.frame.origin.y - 2.0f, _arrowImage.frame.size.width, _arrowImage.frame.size.height);
            
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _activityView.hidden = NO;
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)showPostsRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == ShowPostsPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        BOOL isHavePullShowPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullShowPosts] boolValue];
        BOOL isHavePullMyPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullMyPosts] boolValue];
        if((!isHavePullMyPosts && _postType == WILLShowPosts) || (!isHavePullShowPosts && _postType == WILLMyPosts))
            offset = MIN(offset, 0);
        else
            offset = MIN(offset, offsetY);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate showPostsRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == ShowPostsPullRefreshPulling && scrollView.contentOffset.y > -55.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:ShowPostsPullRefreshNormal];
		} else if (_state == ShowPostsPullRefreshNormal && scrollView.contentOffset.y < -55.0f && !_loading) {
			[self setState:ShowPostsPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)showPostsRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(showPostsRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate showPostsRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 55.0f && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(showPostsRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate showPostsRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:ShowPostsPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        BOOL isHavePullShowPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullShowPosts] boolValue];
        BOOL isHavePullMyPosts = [[[MyUserDefault standardUserDefaults] getIsHavePullMyPosts] boolValue];
        if((!isHavePullMyPosts && _postType == WILLShowPosts) || (!isHavePullShowPosts && _postType == WILLMyPosts))
            scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        else
            scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)showPostsRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.3f
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction|
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void) {
                         _showTextLab.alpha -= 1.0f;
                         _activityView.alpha -= 1.0f;
                    }
                     completion:^(BOOL finished) {
                         if(finished){
                             [UIView animateWithDuration:0.4f
                                                   delay:0
                                                 options:(UIViewAnimationOptionAllowUserInteraction|
                                                          UIViewAnimationOptionBeginFromCurrentState)
                                              animations:^(void) {
                                                  [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
                                              }
                                              completion:^(BOOL finished) {
                                                  if(finished){
//                                                      [self setState:ShowPostsPullRefreshNormal];
                                                      _showTextLab.alpha += 1.0f;
                                                      [self.delegate showPostsBeginToRequestData];
//                                                      _activityView.alpha += 1.0f;
                                                  }
                                              }];
                         }
                     }];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_arrowImage = nil;
    [super dealloc];
}


@end
