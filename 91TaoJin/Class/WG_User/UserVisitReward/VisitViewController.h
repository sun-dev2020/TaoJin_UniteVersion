//
//  VisitViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VisitMethodView.h"
#import "TMAlertView.h"
#import "MScrollVIew.h"
#import <ShareSDK/ShareSDK.h>
#import <ZBarSDK.h> 
#import "User.h"
@interface VisitViewController : UIViewController<MScrollVIewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate ,TMAlertViewDelegate>
@property(nonatomic, assign)int inviteCount;
@property(nonatomic, strong) User *player;
@end
