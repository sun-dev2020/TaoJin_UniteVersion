//
//  IncomeViewController.h
//  TJiphone
//
//  Created by keyrun on 13-9-30.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MScrollVIew.h"

@interface IncomeViewController : UIViewController<MScrollVIewDelegate,UIGestureRecognizerDelegate>

//收支差
@property(nonatomic,assign) int userLog;

@end
