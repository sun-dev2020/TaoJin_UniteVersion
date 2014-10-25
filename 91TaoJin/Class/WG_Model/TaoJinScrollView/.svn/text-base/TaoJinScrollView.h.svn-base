//
//  TaoJinScrollView.h
//  91TaoJin
//
//  Created by keyrun on 14-5-16.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadToolBar.h"

typedef void (^ButtonActionBlock)(UIButton *button);

@interface TaoJinScrollView : UIView<UIScrollViewDelegate>{
    ButtonActionBlock _btnAction;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *slidView;                 //按钮底部指示

- (id)initWithFrame:(CGRect)frame btnAry:(NSArray *)btnStrAry btnAction:(ButtonActionBlock)btnAction slidColor:(UIColor *)slidColor viewAry:(NSArray *)viewAry headView:(HeadToolBar *)headView;

/**
 *  初始化滚动视图
 *
 *  @param frame     视图大小
 *  @param btnStrAry 视图上方按钮数组（该数组只存放NSString类型，即按钮的文案）
 *  @param btnAction 按钮事件的block（按钮的tag默认从1开始）
 *  @param slidColor 按钮下方颜色块的颜色
 *  @param viewAry   添加到滚动视图的子视图
 *
 */
- (id)initWithFrame:(CGRect)frame btnAry:(NSArray *)btnStrAry btnAction:(ButtonActionBlock)btnAction slidColor:(UIColor *)slidColor viewAry:(NSArray *)viewAry;

/**
 *  返回上方横栏按钮的高度值
 *
 */
-(float)getButtonRowHeight;

@end
