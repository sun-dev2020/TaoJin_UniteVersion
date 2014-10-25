//
//  ShowPostsDetailViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "UserShowPosts.h"

@interface ShowPostsDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, HPGrowingTextViewDelegate>
@property(nonatomic ,assign) BOOL isPush;
@property(nonatomic ,assign) int showId;
-(id)initWithDetail:(UserShowPosts *)user;

-(void)requestToGetShowPostsDetail:(int)showId;
@end
