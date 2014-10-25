//
//  NewJFQCell.h
//  91TaoJin
//
//  Created by keyrun on 14-3-20.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFQClass.h"

@protocol NewJFQCellDelegate <NSObject>

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface NewJFQCell : UITableViewCell

@property (nonatomic, retain) UIView *leftView;
@property (nonatomic, retain) UIView *rightView;

@property (nonatomic, retain) UIImageView *leftImage;                               //左边积分墙的Logo
@property (nonatomic, retain) UIImageView *rightImage;                              //右边积分墙的Logo

@property (nonatomic, assign) BOOL isDouble;

@property (nonatomic, retain) JFQClass* leftJFQ;
@property (nonatomic, retain) JFQClass* rightJFQ;

@property (nonatomic, retain) UIButton* leftButton;                                 //左边按钮
@property (nonatomic, retain) UIButton* rightButton;                                //右边按钮

@property (nonatomic, retain) UIImageView *leftAdGenXinImg;                         //左边积分墙的红点图标
@property (nonatomic, retain) UIImageView *rightAdGenXinImg;                        //右边积分墙的红点图标

@property (nonatomic, retain) UILabel *leftAdNumberLab;                             //左边积分墙红点上的数值
@property (nonatomic, retain) UILabel *rightAdNumberLab;                            //右边积分墙红点上的数值

@property (nonatomic, retain) UILabel *leftNameLab;                                 //左边积分墙的名字
@property (nonatomic, retain) UILabel *rightNameLab;                                //右边积分墙的名字

@property (nonatomic, retain) UILabel *leftBeanNumberLab;                           //左边显示可赚的金豆
@property (nonatomic, retain) UILabel *rightBeanNumberLab;                          //右边显示可赚的金豆

@property(nonatomic,assign) BOOL isFirst;
@property(nonatomic,strong) id<NewJFQCellDelegate>cellDelegate;

-(void)loadWithCellContent;

@end





