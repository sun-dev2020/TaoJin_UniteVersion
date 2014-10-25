//
//  CommentTipCell.h
//  91TaoJin
//
//  Created by keyrun on 14-6-10.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTipCell : UITableViewCell

/**
 *  初始化默认提示内容的cell
 *
 *  @param rowHeight       cell的高度
 *  @param content         文案内容
 *
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowHeight:(float)rowHeight content:(NSString *)content;
@end
