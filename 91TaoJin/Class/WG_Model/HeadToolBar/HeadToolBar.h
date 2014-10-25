//
//  HeadToolBar.h
//  91TaoJin
//
//  Created by keyrun on 14-5-7.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadToolBar : UIView

@property (nonatomic, strong) UIButton *leftBtn;                    //左侧按钮
@property (nonatomic, strong) UIButton *rightBtn;                   //右侧按钮

@property (nonatomic, strong) UILabel *rightLab;                    //右侧文案

/**
 *  初始化只有title的顶部横栏
 *
 *  @param titleStr         title文案
 *  @param backgroundColor  背景颜色（目前只有三种：KOrangeColor2_0，KRedColor2_0，KPurpleColor2_0）
 *
 */
- (id)initWithTitle:(NSString *)titleStr backgroundColor:(UIColor *)backgroundColor;

/**
 *  初始化左右有按钮的顶部横栏
 *
 *  @param titleStr                         横栏的title
 *  @param leftBtnTitle                     左边按钮的title文案
 *  @param leftBtnImg                       左边按钮的图标
 *  @param leftBtnHighlightedImg            左边按钮的高亮图标
 *  @param rightBtnTitle                    右边按钮的title文案
 *  @param rightBtnImg                      右边按钮的图标
 *  @param rightBtnHighlightedImg           右边按钮的高亮图标
 *  @param backgroundColor                  背景颜色（目前只有三种：KOrangeColor2_0，KRedColor2_0，KPurpleColor2_0）
 *
 */
- (id)initWithTitle:(NSString *)titleStr leftBtnTitle:(NSString *)leftBtnTitle leftBtnImg:(UIImage *)leftBtnImg leftBtnHighlightedImg:(UIImage *)leftBtnHighlightedImg rightBtnTitle:(NSString *)rightBtnTitle rightBtnImg:(UIImage *)rightBtnImg rightBtnHighlightedImg:(UIImage *)rightBtnHighlightedImg backgroundColor:(UIColor *)backgroundColor;

/**
 *  初始化左边是按钮，右边是文本内容的顶部横栏
 *
 *  @param titleStr                         横栏的title
 *  @param leftBtnTitle                     左边按钮的title文案
 *  @param leftBtnImg                       左边按钮的图标
 *  @param leftBtnHighlightedImg            左边按钮的高亮图标
 *  @param rightLabTitle                    右边文本的文案
 *  @param backgroundColor                  背景颜色（目前只有三种：KOrangeColor2_0，KRedColor2_0，KPurpleColor2_0）
 *
 */
- (id)initWithTitle:(NSString *)titleStr leftBtnTitle:(NSString *)leftBtnTitle leftBtnImg:(UIImage *)leftBtnImg leftBtnHighlightedImg:(UIImage *)leftBtnHighlightedImg rightLabTitle:(id)rightLabTitle backgroundColor:(UIColor *)backgroundColor;

/**
 *  设置右边Label文字的显示文字位置
 *
 *  @param rightLabText 要显示的文字
 */
-(void)setRightLabText:(NSString *)rightLabText;
@end
