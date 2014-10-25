//
//  TaskTableView.h
//  91淘金
//
//  Created by keyrun on 14-7-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
//test
@protocol TaskTableViewDelegate <NSObject>
@required
//返回展开之后的cell
- (UITableViewCell *)tableView:(UITableView *)tableView extendedCellForRowAtIndexPath:(NSIndexPath *)indexPath;
//返回展开之后的cell的高度
- (CGFloat)tableView:(UITableView *)tableView extendedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TaskTableView : UITableView{
    //当前被展开的索引
    NSIndexPath *currentIndexPath;
    
    id<TaskTableViewDelegate> delegate_extend;
}

@property(nonatomic,retain)id delegate_extend;
@property(nonatomic,retain)NSIndexPath *currentIndexPath;
//将indexPath对应的row展开
- (void)extendCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated goToTop:(BOOL)goToTop;

//将展开的cell收起
- (void)shrinkCellWithAnimated:(BOOL)animated;

//查看传来的索引和当前被选中索引是否相同
- (BOOL)isEqualToSelectedIndexPath:(NSIndexPath *)indexPath;
@end
