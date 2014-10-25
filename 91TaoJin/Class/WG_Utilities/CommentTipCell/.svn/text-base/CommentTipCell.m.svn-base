//
//  CommentTipCell.m
//  91TaoJin
//
//  Created by keyrun on 14-6-10.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "CommentTipCell.h"
#import "ViewTip.h"

@implementation CommentTipCell

/**
 *  初始化默认提示内容的cell
 *
 *  @param rowHeight       cell的高度
 *  @param content         文案内容
 *
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowHeight:(float)rowHeight content:(NSString *)content{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ViewTip *tip = [[ViewTip alloc]initWithFrame:CGRectMake(0, 0, kmainScreenWidth, rowHeight)];
        [tip setImageViewWithSize:tip.frame.size image:[UIImage imageNamed:@"a3.png"]];
        [tip setViewTipByContent:content];
        [self addSubview:tip];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
