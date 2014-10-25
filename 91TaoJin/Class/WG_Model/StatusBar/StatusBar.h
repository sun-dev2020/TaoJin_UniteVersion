//
//  StatusBar.h
//  TJiphone
//
//  Created by keyrun on 13-10-23.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface StatusBar : UIView


+(void)showTipMessageWithStatus:(NSString* )message andImage:(UIImage* )image andTipIsBottom:(BOOL)isBottom;
+(void)showTipMessageWithStatus:(NSString* )message andImage:(UIImage* )image andCoin:(NSString*)coin andSecImage:(UIImage*)secImage andTipIsBottom:(BOOL)isBottom;


@end
