//
//  ButtonRowView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "ButtonRowView.h"
#import "UIImage+ColorChangeTo.h"
#import <QuartzCore/QuartzCore.h>

#define kButtonHeight                           56.0f

@implementation ButtonRowView

- (id)initWithFrame:(CGRect )frame imgAry:(NSArray *)imgAry titleAry:(NSArray *)titleAry colorAry:(NSArray *)colorAry btnAction:(ButtonRowActionBlock)btnAction{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kButtonHeight)];
    if(self){
        float width = kmainScreenWidth/titleAry.count;
        for(int i = 0 ; i < titleAry.count ; i ++){
            UIView *view = [self loadButtonViewWithFrame:CGRectMake(i * width, 0.0f, width, kButtonHeight) imageStr:[imgAry objectAtIndex:i] titleStr:[titleAry objectAtIndex:i] textColor:[colorAry objectAtIndex:i] count:titleAry.count tag:i+1];
            view.backgroundColor = [UIColor whiteColor];
            [self addSubview:view];
        }
        _btnAction = [btnAction copy];
    }
    return self;
}


/**
 *  加载顶部单独按钮视图
 *
 *  @param frame     按钮大小
 *  @param imageStr  按钮Logo的图片名称
 *  @param titleStr  按钮的文案
 *  @param textColor 按钮的文案颜色
 *  @param count     总数
 *  @param tag       唯一标识
 *
 */
-(UIView *)loadButtonViewWithFrame:(CGRect )frame imageStr:(NSString *)imageStr titleStr:(NSString *)titleStr textColor:(UIColor *)textColor count:(int)count tag:(int)tag{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImage *logoImg = [UIImage imageNamed:imageStr];
    //图标logo
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, 35.0f)];
    logoView.image = logoImg;
    //文案
    UILabel *titleLab = [self loadLabelWithFrame:CGRectMake(0.0f, logoView.frame.origin.y + logoView.frame.size.height, frame.size.width, frame.size.height - logoView.frame.origin.y - logoView.frame.size.height) titleStr:titleStr textColor:textColor font:[UIFont systemFontOfSize:11.0f] textAlignment:NSTextAlignmentCenter];
    //隐藏按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage createImageWithColor:kBlockBackground2_0] forState:UIControlStateHighlighted];
    [button addSubview:logoView];
    [button addSubview:titleLab];
    //右分隔线
    if(tag != count){
        CALayer *rightLayer = [self loadLayerWithFrame:CGRectMake(frame.size.width - LineWidth, 0.0f, LineWidth, frame.size.height)];
        [button.layer addSublayer:rightLayer];
    }
    //下分隔线
    CALayer *bottomLayer = [self loadLayerWithFrame:CGRectMake(0.0f, frame.size.height - LineWidth, frame.size.width, LineWidth)];
    [button.layer addSublayer:bottomLayer];
    button.layer.borderColor = kLineColor2_0.CGColor;
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

-(CALayer *)loadLayerWithFrame:(CGRect)frame{
    CALayer *layer = [CALayer layer];
    [layer setBackgroundColor:[kLineColor2_0 CGColor]];
    [layer setFrame:frame];
    return layer;
}


/**
 *  加载Label
 *
 *  @param frame         大小
 *  @param titleStr      文案
 *  @param textColor     文案颜色
 *  @param font          字体
 *  @param textAlignment 文案的相对位置
 *
 */
-(UILabel *)loadLabelWithFrame:(CGRect )frame titleStr:(NSString *)titleStr textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = titleStr;
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}

/**
 *  按钮事件的回调
 *
 */
-(void)buttonAction:(UIButton *)button{
    _btnAction(button);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
