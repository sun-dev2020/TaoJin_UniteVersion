//
//  ShowPostsHeadView.h
//  91TaoJin
//
//  Created by keyrun on 14-5-26.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TaoJinButton.h"

typedef enum{
	ShowPostsPullRefreshPulling = 0,
	ShowPostsPullRefreshNormal,
	ShowPostsPullRefreshLoading,
} ShowPostsPullRefreshState;

typedef enum{
    WILLMyPosts = 0,
    WILLShowPosts,
}PostsType;             //即将显示类型

@protocol ShowPostsRefreshTableHeaderDelegate;
@interface ShowPostsHeadView : UIView {
    
	
    
	UILabel *_showTextLab;
	CALayer *_arrowImage;
//	UIActivityIndicatorView *_activityView;
    UIImageView *_activityView;
}

@property (nonatomic,assign) id <ShowPostsRefreshTableHeaderDelegate> delegate;
@property (nonatomic, strong) TaoJinButton *joinShowPostsBtn;
@property (nonatomic, assign) PostsType postType;
@property (nonatomic, strong) UILabel *showTextLab;
@property (nonatomic, assign) ShowPostsPullRefreshState state;

- (void)refreshLastUpdatedDate;
- (void)showPostsRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)showPostsRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)showPostsRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
- (void)setState:(ShowPostsPullRefreshState)aState;

@end
@protocol ShowPostsRefreshTableHeaderDelegate
- (void)showPostsRefreshTableHeaderDidTriggerRefresh:(ShowPostsHeadView *)view;
- (BOOL)showPostsRefreshTableHeaderDataSourceIsLoading:(ShowPostsHeadView *)view;
- (void)showPostsBeginToRequestData;
@optional

- (NSDate *)showPostsRefreshTableHeaderDataSourceLastUpdated:(ShowPostsHeadView *)view;

@end
