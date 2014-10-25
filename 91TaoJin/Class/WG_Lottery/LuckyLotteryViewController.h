//
//  LuckyLotteryViewController.h
//  91TaoJin
//
//  Created by keyrun on 14-5-8.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialAnimationQueue.h"
#import "MScrollVIew.h"
@interface LuckyLotteryViewController : UIViewController<MScrollVIewDelegate ,UIAlertViewDelegate>

@property (nonatomic, strong) SerialAnimationQueue *queue;
@end
