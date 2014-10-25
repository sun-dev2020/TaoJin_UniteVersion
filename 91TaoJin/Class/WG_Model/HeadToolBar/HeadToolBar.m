//
//  HeadToolBar.m
//  91TaoJin
//
//  Created by keyrun on 14-5-7.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "HeadToolBar.h"
#import "NSString+IsEmply.h"
#import "UIImage+ColorChangeTo.h"

#define SpacingX                    20.0                 //x坐标的间距

@implementation HeadToolBar{
    UILabel *jindouStrLab;
}

@synthesize leftBtn = _leftBtn;
@synthesize rightBtn = _rightBtn;
@synthesize rightLab = _rightLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/**
 *  初始化只有title的顶部横栏
 *
 *  @param titleStr         title文案
 *  @param backgroundColor  背景颜色（目前只有三种：KOrangeColor2_0，KRedColor2_0，KPurpleColor2_0）
 *
 */
- (id)initWithTitle:(NSString *)titleStr backgroundColor:(UIColor *)backgroundColor{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kHeadViewHeigh + (kOriginY))];
    if(self){
        self.backgroundColor = backgroundColor;
        //title
        UILabel *titleLab = [self loadLabelWithFrame:CGRectMake(0.0f, kOriginY, 0.0f, 0.0f) titleStr:titleStr font:[UIFont boldSystemFontOfSize:18.0f]];
        titleLab.frame = CGRectMake(kmainScreenWidth/2 - titleLab.frame.size.width/2 , titleLab.frame.origin.y, titleLab.frame.size.width, kHeadViewHeigh);
        [self addSubview:titleLab];
    }
    return self;
}

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
- (id)initWithTitle:(NSString *)titleStr leftBtnTitle:(NSString *)leftBtnTitle leftBtnImg:(UIImage *)leftBtnImg leftBtnHighlightedImg:(UIImage *)leftBtnHighlightedImg rightBtnTitle:(NSString *)rightBtnTitle rightBtnImg:(UIImage *)rightBtnImg rightBtnHighlightedImg:(UIImage *)rightBtnHighlightedImg backgroundColor:(UIColor *)backgroundColor{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kHeadViewHeigh + (kOriginY))];
    if(self){
        self.backgroundColor = backgroundColor;
        //左侧按钮
        if(leftBtnImg != nil){
            self.leftBtn = [self loadLeftButtonWithFrame:CGRectMake(0.0f, kOriginY, 73.0f, kHeadViewHeigh) titleStr:leftBtnTitle image:leftBtnImg highlightedImg:leftBtnHighlightedImg backgroundColor:backgroundColor];
            self.leftBtn.frame = CGRectMake(self.leftBtn.frame.origin.x, self.leftBtn.frame.origin.y, self.leftBtn.frame.size.width, kHeadViewHeigh);
            [self addSubview:self.leftBtn];
        }
        
        //右侧按钮
//        if(rightBtnImg != nil){
            self.rightBtn = [self loadRightButtonWithFrame:CGRectMake(kmainScreenWidth - 75.0f, kOriginY, 75.0f, kHeadViewHeigh) titleStr:rightBtnTitle image:rightBtnImg highlightedImg:rightBtnHighlightedImg backgroundColor:backgroundColor];
            [self addSubview:self.rightBtn];
//        }
        
        //title
        UILabel *titleLab = [self loadLabelWithFrame:CGRectMake(0.0f, kOriginY, 0.0f, 0.0f) titleStr:titleStr font:[UIFont boldSystemFontOfSize:18.0f]];
        titleLab.frame = CGRectMake(kmainScreenWidth/2 - titleLab.frame.size.width/2, titleLab.frame.origin.y, titleLab.frame.size.width, kHeadViewHeigh);
        [self addSubview:titleLab];
    }
    return self;
}

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
- (id)initWithTitle:(NSString *)titleStr leftBtnTitle:(NSString *)leftBtnTitle leftBtnImg:(UIImage *)leftBtnImg leftBtnHighlightedImg:(UIImage *)leftBtnHighlightedImg rightLabTitle:(id)rightLabTitle backgroundColor:(UIColor *)backgroundColor{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, kHeadViewHeigh + (kOriginY))];
    if(self){
        self.backgroundColor = backgroundColor;
        //左侧按钮
        if(leftBtnImg != nil){
            self.leftBtn = [self loadLeftButtonWithFrame:CGRectMake(0.0f, kOriginY, 73.0f, kHeadViewHeigh) titleStr:leftBtnTitle image:leftBtnImg highlightedImg:leftBtnHighlightedImg backgroundColor:backgroundColor];
            self.leftBtn.frame = CGRectMake(self.leftBtn.frame.origin.x, self.leftBtn.frame.origin.y, self.leftBtn.frame.size.width, kHeadViewHeigh);
            [self addSubview:self.leftBtn];
        }
        
        if([rightLabTitle isKindOfClass:[NSString class]]){
            //说明是抽奖次数的文案
            self.rightLab = [self loadLabelWithFrame:CGRectMake(0.0f, kOriginY, 0.0f, 0.0f) titleStr:[NSString stringWithFormat:@"%@",rightLabTitle] font:[UIFont systemFontOfSize:14]];
            self.rightLab.frame = CGRectMake(kmainScreenWidth - self.rightLab.frame.size.width - 10.0f, self.rightLab.frame.origin.y, self.rightLab.frame.size.width, kHeadViewHeigh);
            [self addSubview:self.rightLab];
        }else if([rightLabTitle isKindOfClass:[NSNumber class]]){
            //说明是用户金豆数量的文案
            //【金豆】两字的文案
            jindouStrLab = [self loadLabelWithFrame:CGRectMake(0.0f, kOriginY, 0.0f, 0.0f) titleStr:@"金豆" font:[UIFont systemFontOfSize:11]];
            [jindouStrLab sizeToFit];
            jindouStrLab.frame = CGRectMake(kmainScreenWidth - jindouStrLab.frame.size.width - Spacing2_0, jindouStrLab.frame.origin.y + 2.0f, jindouStrLab.frame.size.width, kHeadViewHeigh);
            [self addSubview:jindouStrLab];
            self.rightLab = [self loadLabelWithFrame:CGRectMake(0.0f, kOriginY, 0.0f, 0.0f) titleStr:[NSString stringWithFormat:@"%@",rightLabTitle] font:[UIFont boldSystemFontOfSize:18]];
            self.rightLab.frame = CGRectMake(jindouStrLab.frame.origin.x - self.rightLab.frame.size.width - 3.0f, self.rightLab.frame.origin.y , self.rightLab.frame.size.width, kHeadViewHeigh);
            [self addSubview:self.rightLab];
        }
        //title
        UILabel *titleLab = [self loadLabelWithFrame:CGRectMake(0.0f, kOriginY, 0.0f, 0.0f) titleStr:titleStr font:[UIFont boldSystemFontOfSize:18.0f]];
        titleLab.frame = CGRectMake(kmainScreenWidth/2 - titleLab.frame.size.width/2, titleLab.frame.origin.y, titleLab.frame.size.width, kHeadViewHeigh);
        [self addSubview:titleLab];
    }
    return self;
}

/**
 *  设置右边Label文字的显示文字位置
 *
 *  @param rightLabText 要显示的文字
 */
-(void)setRightLabText:(NSString *)rightLabText{
    self.rightLab.text = rightLabText;
    [self.rightLab sizeToFit];
    if(jindouStrLab != nil){
        self.rightLab.frame = CGRectMake(jindouStrLab.frame.origin.x - self.rightLab.frame.size.width - 3.0f, self.rightLab.frame.origin.y , self.rightLab.frame.size.width, kHeadViewHeigh);
    }else{
         self.rightLab.frame = CGRectMake(kmainScreenWidth - self.rightLab.frame.size.width - Spacing2_0, self.rightLab.frame.origin.y , self.rightLab.frame.size.width, kHeadViewHeigh);
    }
}

/**
 *  显示文案
 *
 *  @param frame    文案大小
 *  @param titleStr 文案内容
 *  @param font     字体规格
 *
 */
-(UILabel *)loadLabelWithFrame:(CGRect)frame titleStr:(NSString *)titleStr font:(UIFont *)font{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentLeft;
    label.font = font;
    label.text = titleStr;
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    return label;
}

/**
 *  初始化右侧按钮
 *
 *  @param frame                按钮大小
 *  @param titleStr             按钮文案
 *  @param image                按钮图案
 *  @param backgroundColor      根据当前颜色判断按钮高亮的颜色
 *
 */
-(UIButton *)loadRightButtonWithFrame:(CGRect)frame titleStr:(NSString *)titleStr image:(UIImage *)image highlightedImg:(UIImage *)highlightedImg backgroundColor:(UIColor *)backgroundColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    if(image != nil){
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:highlightedImg forState:UIControlStateHighlighted];
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    if(![NSString isEmply:titleStr]){
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 0.0f);
    }
    if(CGColorEqualToColor(backgroundColor.CGColor, KRedColor2_0.CGColor)){
        [button setTitleColor:[UIColor colorWithRed:250.0/255.0 green:170.0/255.0 blue:180.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }else if(CGColorEqualToColor(backgroundColor.CGColor, KPurpleColor2_0.CGColor)){
        [button setTitleColor:[UIColor colorWithRed:200.0/255.0 green:190.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }else{
        [button setTitleColor:[UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }
    return button;
}

/**
 *  初始化左侧按钮
 *
 *  @param frame                按钮大小
 *  @param titleStr             按钮文案
 *  @param image                按钮图案
 *  @param backgroundColor      根据当前颜色判断按钮高亮的颜色
 *
 */
-(UIButton *)loadLeftButtonWithFrame:(CGRect)frame titleStr:(NSString *)titleStr image:(UIImage *)image highlightedImg:(UIImage *)highlightedImg backgroundColor:(UIColor *)backgroundColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    if(image != nil){
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:highlightedImg forState:UIControlStateHighlighted];
        button.imageEdgeInsets = UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 12.0f);
    }
    if(![NSString isEmply:titleStr]){
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.titleEdgeInsets = UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 5.0f);
    }
    if(CGColorEqualToColor(backgroundColor.CGColor, KRedColor2_0.CGColor)){
        [button setTitleColor:[UIColor colorWithRed:250.0/255.0 green:170.0/255.0 blue:180.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }else if(CGColorEqualToColor(backgroundColor.CGColor, KPurpleColor2_0.CGColor)){
        [button setTitleColor:[UIColor colorWithRed:200.0/255.0 green:190.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }else{
        [button setTitleColor:[UIColor colorWithRed:255.0/255.0 green:215.0/255.0 blue:140.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }
    return button;
}
@end






