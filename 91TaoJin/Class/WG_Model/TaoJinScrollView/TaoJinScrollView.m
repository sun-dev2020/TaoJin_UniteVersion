//
//  TaoJinScrollView.m
//  91TaoJin
//
//  Created by keyrun on 14-5-16.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TaoJinScrollView.h"
#import <QuartzCore/QuartzCore.h>
#define btnHeight                                       40.0f

@implementation TaoJinScrollView{
    NSArray *_btnStrAry;                                //按钮文案数组

    int currentPage;
    float btnWidth;                                       //单独一个button的宽度
    int oldBtnTag;                                      //上一次选中按钮的标示
}

@synthesize scrollView = _scrollView;
@synthesize slidView = _slidView;

- (id)initWithFrame:(CGRect)frame btnAry:(NSArray *)btnStrAry btnAction:(ButtonActionBlock)btnAction slidColor:(UIColor *)slidColor viewAry:(NSArray *)viewAry headView:(HeadToolBar *)headView{
    return [self initWithFrame:frame btnAry:btnStrAry btnAction:btnAction slidColor:slidColor viewAry:viewAry];
}

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
- (id)initWithFrame:(CGRect)frame btnAry:(NSArray *)btnStrAry btnAction:(ButtonActionBlock)btnAction slidColor:(UIColor *)slidColor viewAry:(NSArray *)viewAry{
    self = [super initWithFrame:frame];
    if (self) {
        btnWidth = kmainScreenWidth/btnStrAry.count;
        for(int i = 0 ; i < btnStrAry.count ; i ++){
            UIButton *btn = [self loadButtonWithFrame:CGRectMake(btnWidth * i, 0.0f, btnWidth, btnHeight) title:[btnStrAry objectAtIndex:i] tag:i + 1 btnHighlightedColor:slidColor];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if(i == 0){
                [btn setHighlighted:YES];
                oldBtnTag = btn.tag;
            }
            [self addSubview:btn];
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, btnHeight, kmainScreenWidth, frame.size.height - btnHeight)];
        CALayer *layer = [CALayer layer];
        [layer setBackgroundColor:[kLineColor2_0 CGColor]];
        [layer setFrame:CGRectMake(0.0f, btnHeight - LineWidth, kmainScreenWidth, LineWidth)];
        [self.layer addSublayer:layer];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
//        self.scrollView.clipsToBounds = NO;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * btnStrAry.count, self.scrollView.frame.size.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.delegate = self;
        
        [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f)];
        
        self.slidView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, btnHeight - 3.0f, btnWidth, 3.0f)];
        self.slidView.backgroundColor = slidColor;
        [self addSubview:self.slidView];
        
        for(int i = 0 ; i < viewAry.count ; i ++){
            UIView *view = [viewAry objectAtIndex:i];
            if(view.frame.size.width == 0){
                view.frame = CGRectMake(i * kmainScreenWidth, 0.0f, kmainScreenWidth, self.scrollView.frame.size.height - (kBatterHeight));
            }
            [self.scrollView addSubview:view];
        }
        [self addSubview:self.scrollView];
        //公用
        currentPage = 0;
        _btnAction = [btnAction copy];
    }
    return self;
}

/**
 *  返回上方横栏按钮的高度值
 *
 */
-(float)getButtonRowHeight{
    return btnHeight;
}

/**
 *  按钮事件的回调
 *
 */
-(void)buttonAction:(UIButton *)button{
    if(button.tag != oldBtnTag){
        UIButton *oldBtn = (UIButton *)[self viewWithTag:oldBtnTag];
        [oldBtn setHighlighted:NO];
        [_scrollView setContentOffset:CGPointMake((button.tag - 1) * kmainScreenWidth, 0.0f) animated:YES];
        _btnAction(button);
    }
    [self performSelector:@selector(highlightButton:) withObject:button afterDelay:0.0];
}

/**
 *  设置按钮处于高亮状态
 *
 */
- (void)highlightButton:(UIButton *)button{
    [button setHighlighted:YES];
}

/**
 *  初始化按钮
 *
 *  @param frame                    按钮尺寸
 *  @param title                    按钮文案
 *  @param tag                      按钮标识
 *  @param btnHighlightedColor      按钮高亮的颜色
 *
 */
-(UIButton *)loadButtonWithFrame:(CGRect )frame title:(NSString *)title tag:(int)tag btnHighlightedColor:(UIColor *)btnHighlightedColor{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundColor:KLightGrayColor2_0];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:KGrayColor2_0 forState:UIControlStateNormal];
    [button setTitleColor:btnHighlightedColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = tag;
    return button;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _slidView.frame = CGRectMake(scrollView.contentOffset.x/kmainScreenWidth * btnWidth, _slidView.frame.origin.y, btnWidth, _slidView.frame.size.height);
    [UIView commitAnimations];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    UIButton *oldBtn = (UIButton *)[self viewWithTag:oldBtnTag];
    [oldBtn setHighlighted:NO];
    
    currentPage = scrollView.contentOffset.x / kmainScreenWidth;
    UIButton *button = (UIButton *)[self viewWithTag:currentPage + 1];
    [self performSelector:@selector(highlightButton:) withObject:button afterDelay:0.0];
    _btnAction(button);
    oldBtnTag = currentPage + 1;
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    currentPage = scrollView.contentOffset.x / kmainScreenWidth;
    oldBtnTag = currentPage + 1;
   
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end







