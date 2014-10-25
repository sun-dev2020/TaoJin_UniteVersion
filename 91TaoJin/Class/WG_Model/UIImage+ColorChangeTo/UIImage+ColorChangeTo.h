//
//  UIImage+ColorChangeTo.h
//  91TaoJin
//
//  Created by keyrun on 14-5-16.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorChangeTo)
/**
 *  颜色转为Image
 *
 *  @param color 颜色值
 *
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
