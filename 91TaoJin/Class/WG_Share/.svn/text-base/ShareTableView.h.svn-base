//
//  ShareTableView.h
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
@interface ShareTableView : UITableView<UITableViewDelegate,UITableViewDataSource ,UIAlertViewDelegate >

@property (nonatomic, retain) NSMutableArray *allShares;
@property (nonatomic, assign) BOOL isRequesting;                            //标示是否正在网络请求或者正在刷新界面

-(void)initObjects;
-(void)sendRequestForShare;
@end
