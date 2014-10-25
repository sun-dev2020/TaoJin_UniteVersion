//
//  TaskAppSubCell.h
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskAppSubCell : UITableViewCell

@property (nonatomic, strong) UILabel *beanLab;                         //左侧可赚金豆数量（若完成则显示【已完成】）
@property (nonatomic, strong) UILabel *inforLab;                        //右侧显示任务描述
@property (nonatomic, strong) UIButton *installBtn;                     //安装/打开按钮


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isShowSeparatedLine:(BOOL)isShowSeparatedLine isHideBeanLab:(BOOL)isHideBeanLab isShowBtn:(BOOL)isShowBtn isBlank:(BOOL)isBlank;

/**
 *  动态设置subCell的信息
 *
 *  @param beanNum          金豆数量
 *  @param rightTitleStr    右边文案
 *  @param state            表示正在完成还是已完成的状态(1：未完成；2：已完成；3：审核中)
 *  @param phoneTaskInfo    上传截图的任务说明
 */
-(void)setTaskAppSubCellWithBeanNum:(int )beanNum rightTitleStr:(NSString *)rightTitleStr state:(int)state phoneTaskInfo:(NSString *)phoneTaskInfo;

/**
 *  设置描述内容
 *
 *  @param description 描述的内容
 */
-(void)setTaskAppSubCellWithDescription:(NSString *)description;
@end
