//
//  TaskAppCell.h
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameGroup.h"
//test
@interface TaskAppCell : UITableViewCell

@property (nonatomic, strong) UIImageView *appIconImg;          //app图标
@property (nonatomic, strong) UILabel *appNameLab;              //app名称
@property (nonatomic, strong) UILabel *appInfoLab;              //app信息
@property (nonatomic, strong) UILabel *appBeanNumLab;           //金豆数量
@property (nonatomic, strong) UILabel *canSign;                 //【可签到】
@property (nonatomic, assign) BOOL isOpen;                      //标识是否已经打开任务列表

/**
 *  初始化Cell
 *
 *  @param style           样式
 *  @param reuseIdentifier 标识
 *  @param isSeparatedLine 是否有分割线
 *
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isSeparatedLine:(BOOL)isSeparatedLine cellHeight:(float)cellHeight;

/**
 *  不同的app对象显示不同的cell
 *
 *  @param group app对象
 */
-(void)setHeadViewByAppGroup:(GameGroup *)group;
@end
