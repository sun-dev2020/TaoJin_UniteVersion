//
//  AppDelegate.h
//  TJiphone
//
//  Created by keyrun on 13-9-26.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>
#import <Security/Security.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
#import "SSKeychain.h"
#import "OpenUDID.h"
#import "MobClick.h"
#import "sys/utsname.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign) BOOL didRequest;


@end
