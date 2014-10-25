//
//  TaskViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-5-7.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMAlertView.h"

#import <StoreKit/SKStoreProductViewController.h>
#import <WapsOffer/AppConnect.h>
#import <Escore/YJFUserMessage.h>
#import <Escore/YJFInitServer.h>
#import <Escore/YJFIntegralWall.h>
#import <immobSDK/immobView.h>
#import "DianRuAdWall.h"
#import "MiidiManager.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "DMOfferWallViewController.h"
#import "MobiSageOfferWallViewController.h"
#import "MobiSageSDK.h"
#import "YouMiView.h"
#import "UploadViewController.h"
#import "DMAdView.h"
#import "TaskTableView.h"

//test
@interface TaskViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, TMAlertViewDelegate, DianRuAdWallDelegate,MiidiAdWallShowAppOffersDelegate,DMOfferWallDelegate,immobViewDelegate,MobiSageOfferWallDelegate ,SKStoreProductViewControllerDelegate,UploadImageSuccessDelegate, YouMiDelegate ,DMAdViewDelegate, TaskTableViewDelegate,NSURLConnectionDataDelegate ,NSURLConnectionDelegate>

@property (nonatomic,strong) MobiSageOfferWallViewController *mobisage;
@property (nonatomic, assign) BOOL isRequesting;                                    //标识是否正在网络请求或刷新数据
@property (nonatomic, strong) NSMutableArray *jifenAry;                               //积分墙数据
@property (nonatomic, strong) NSMutableArray *appAry;                                 //所有app数据（包括未参与，已参与，已完成）


- (void)initWithObjects;
@end
