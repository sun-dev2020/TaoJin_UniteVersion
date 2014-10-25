//
//  UIImage+ColorChangeTo.m
//  91TaoJin
//
//  Created by keyrun on 14-5-16.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "UIImage+ColorChangeTo.h"

@implementation UIImage (ColorChangeTo)

/**
 *  颜色转为Image
 *
 *  @param color 颜色值
 *
 */
+ (UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImg;
}


@end











