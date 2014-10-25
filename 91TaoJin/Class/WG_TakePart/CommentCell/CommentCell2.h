//
//  CommentCell.h
//  91TaoJin
//
//  Created by keyrun on 14-6-3.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell2 : UITableViewCell
@property (nonatomic, strong) UIImageView *comment_logo;            //评论头像
@property (nonatomic, strong) NSString *comment_name;               //评论Id
@property (nonatomic, strong) NSString *comment_time;               //评论时间
@property (nonatomic, strong) NSString *comment_content;            //评论内容
@property (nonatomic, strong) NSArray *comment_pictureAry;          //评论图片

/**
 *  设置点评内容的显示
 *
 *  @param comment 点评对象
 */
-(void)showComment:(Comment *)comment;


-(float) getCommentCellHeight;
@end
