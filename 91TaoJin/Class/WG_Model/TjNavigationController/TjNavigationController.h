//
//  TjNavigationController.h
//  91TaoJin
//
//  Created by keyrun on 14-3-6.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TjNavigationController : UINavigationController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController* currentShowVC;
@end
