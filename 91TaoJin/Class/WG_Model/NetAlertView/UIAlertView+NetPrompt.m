//
//  UIAlertView+NetPrompt.m
//  91TaoJin
//
//  Created by keyrun on 14-5-6.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "UIAlertView+NetPrompt.h"

@implementation UIAlertView (NetPrompt)

static id alertView = nil;

+(id)showNetAlert{
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
    if(alertView == nil)
        alertView = [[self alloc] initWithTitle:@"提示" message:@"网络不给力，请再试试吧" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"点击刷新", nil];
//    });
    return alertView;
}

//判断弹窗是否已经实例化
+(BOOL)isInit{
    if(alertView == nil)
        return NO;
    return YES;
}

//重置网络弹窗为空
+(void)resetNetAlertNil{
    if(alertView != nil)
        alertView = nil;
}
@end
