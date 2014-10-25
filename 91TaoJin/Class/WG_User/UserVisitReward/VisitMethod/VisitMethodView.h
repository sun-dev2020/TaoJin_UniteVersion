//
//  VisitMethodView.h
//  TJiphone
//
//  Created by keyrun on 13-10-9.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define  kLabelOneText  @"邀请好友说明"
#define kFront  [UIFont systemFontOfSize:13.0]

typedef void(^shareCallBack)(NSString *,NSString *,NSString *);

@interface VisitMethodView : UIView<UIWebViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) shareCallBack shareCallBack;

@property (nonatomic ,strong) NSString *codeUrl ;   // 生成二维码的

@end
