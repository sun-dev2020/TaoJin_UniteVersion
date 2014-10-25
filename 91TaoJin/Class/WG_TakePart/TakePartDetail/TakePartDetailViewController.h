//
//  TakePartDetailViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"
#import "TakePart.h"
@interface TakePartDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ReloadViewDelegate ,UIWebViewDelegate,UIGestureRecognizerDelegate>

- (id)initWithTakePartId:(NSString *)takePartId andTakePartItem:(TakePart *)takePartItem;

@property (nonatomic ,assign) BOOL isNeedReload;
@property (nonatomic ,assign) BOOL isPush;
-(void)requestToGetTakePartDetail:(NSString*) tpID;
@end
