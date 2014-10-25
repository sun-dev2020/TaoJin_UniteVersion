//
//  TaskTableView.m
//  91淘金
//
//  Created by keyrun on 14-7-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TaskTableView.h"
#import "TaskAppCell.h"
@implementation TaskTableView

@synthesize delegate_extend;
@synthesize currentIndexPath;

//test
- (id)init
{
    currentIndexPath = nil;
    return [super init];
}

//重写设置代理的方法，使为UITableView设置代理时，将子类的delegate_extend同样设置
- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.delegate_extend = delegate;
    [super setDelegate:delegate];
}

/*
 
 将indexPath对应的row展开
 params:
 
 animated:是否要动画效果
 goToTop:展开后是否让到被展开的cell滚动到顶部
 
 */
- (void)extendCellAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated goToTop:(BOOL)goToTop
{
    float index = 0;
    if((IOS_Version) == 7.0){
        index = 1;
    }
    //被取消选中的行的索引
    NSIndexPath *unselectedIndex = [NSIndexPath indexPathForRow:currentIndexPath.row - index inSection:currentIndexPath.section];
    //取消选中的index的集合
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    //选中的index的集合
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    
    int tag = 0;
    //若当前index不为空
    if(currentIndexPath)
    {
        tag = 1;
        //被取消选中的行的索引
        if((IOS_Version) != 7.0){
            if(indexPath.section > unselectedIndex.section || (indexPath.section == unselectedIndex.section && indexPath.row > unselectedIndex.row)){
                [array2 addObject:unselectedIndex];
            }else{
                [array1 addObject:currentIndexPath];
            }
        }
    }else{
        tag = 0;
    }
    
    //若当前选中的行和入参的选中行不相同，说明用户点击的不是已经展开的cell
    if(![self isEqualToSelectedIndexPath:indexPath])
    {
        //被选中的行的索引
        [array2 addObject:indexPath];
    }
    
    //将当前被选中的索引重新赋值
    currentIndexPath = indexPath;
    NSLog(@"unselectedIndex = %@",unselectedIndex);
    if(animated){
        if(array1.count > 0){
            [self reloadRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationFade tag:0];
        }
        [self reloadRowsAtIndexPaths:array2 withRowAnimation:UITableViewRowAnimationFade tag:tag];
    }else{
        [self reloadRowsAtIndexPaths:array2 withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    if(goToTop)
    {
        //tableview滚动到新选中的行的高度
        CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
        CGPoint point = [self contentOffset];
        if(cellRect.origin.y + cellRect.size.height- point.y > self.frame.size.height)
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        else if(cellRect.origin.y - point.y < self.frame.origin.y)
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

//将展开的cell收起
- (void)shrinkCellWithAnimated:(BOOL)animated
{
    //要刷新的index的集合
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    
    if(currentIndexPath){
        //当前展开的cell的索引
        float index = 0;
        if((IOS_Version) == 7.0 ){
            index = 1;
        }
        index = 0;
        NSIndexPath *localPath = [NSIndexPath indexPathForRow:currentIndexPath.row - index  inSection:currentIndexPath.section];
        [array1 addObject:localPath];
        //将当前展开的cell的索引设为空
        currentIndexPath = nil;
        [self reloadRowsAtIndexPaths:array1 withRowAnimation:UITableViewRowAnimationFade tag:1];
        
    }
}

//查看传来的索引和当前被选中索引是否相同
- (BOOL)isEqualToSelectedIndexPath:(NSIndexPath *)indexPath
{
    if(currentIndexPath)
    {
        return ([currentIndexPath row] == [indexPath row]) && ([currentIndexPath section] == [indexPath section]);
    }
    return NO;
}

//- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if([currentIndexPath row] == [indexPath row])
//    {
//        return [self.delegate_extend tableView:self extendedCellForRowAtIndexPath:indexPath];
//    }
//    return [super cellForRowAtIndexPath:indexPath];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([currentIndexPath row] == [indexPath row])
    {
        return [self.delegate_extend tableView:self extendedHeightForRowAtIndexPath:indexPath];
    }
    return [super rowHeight];
}

-(void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation tag:(int)tag{
    
    [self beginUpdates];
    if(tag == 0 || (IOS_Version) <= 7.0){
        [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }else{
        [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    [self endUpdates];
}


@end
