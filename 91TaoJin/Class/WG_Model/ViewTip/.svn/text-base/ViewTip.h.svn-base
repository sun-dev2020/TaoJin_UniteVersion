//
//  ViewTip.h
//  91淘金
//
//  Created by keyrun on 13-11-15.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewTip : UIView
{
    UIImageView* imageView;
    UILabel* labelOne;
}
-(void)setViewTipByImage:(UIImage* )image;
-(void)setViewTipByStringOne:(NSString* )string;
-(void)setViewTipByStringTwo:(NSString* )string;
-(void)newImageViewFrame:(CGRect)rect;

/**
 *  设置文案显示
 *
 *  @param content 文案（可包括换行符）
 */
-(void)setViewTipByContent:(NSString *)content;

/**
 *  设置图像的位置及显示
 *
 *  @param size 图像所在区域的大小，即superView的size
 *  @param image 图像
 */
-(void)setImageViewWithSize:(CGSize )size image:(UIImage* )image;
@end
