//
//  TakePartCell.h
//  91TaoJin
//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoJinLabel.h"
#import "TakePart.h"
@interface TakePartCell : UITableViewCell

@property (nonatomic, strong) UIImageView *logoImgView;                             //Logo图片
@property (nonatomic, strong) TaoJinLabel *titleLab;                                //内容
@property (nonatomic, strong) TaoJinLabel *commentCount;                            //评论数

/**
 *  动态设置【天天参与】列表的数据
 *
 *  @param titleStr         标题内容
 *  @param imageUrl         Logo
 *  @param commentCountStr  评论数量
 */
- (void)setTakePartCellContent:(NSString *)titleStr imageUrl:(NSString *)imageUrl commentCountStr:(NSString *)commentCountStr takeType:(int)type isPinLun:(int) isPl;

@end
