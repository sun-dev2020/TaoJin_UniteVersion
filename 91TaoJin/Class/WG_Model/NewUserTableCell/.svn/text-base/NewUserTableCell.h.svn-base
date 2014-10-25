//
//  NewUserTableCell.h
//  91TaoJin
//
//  Created by keyrun on 14-5-24.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface NewUserTableCell : UITableViewCell


@property (nonatomic ,strong) UILabel *messageLabel;
@property (nonatomic ,strong) UILabel *erinnernLab;
@property (nonatomic ,strong) UILabel *userJdsLab;
@property (nonatomic ,strong) UIImageView *hotImage;
@property (nonatomic ,strong) UIImageView *userIcon;
@property (nonatomic ,strong) UILabel *coinLabel;

-(void)setCellViewByType:(int )type andWithImage:(UIImage*)image andCellTitle:(NSString* )title;
-(void)setImageFrame:(CGRect )imageFrame andTitleFrame:(CGRect)titleFrame ;

-(void)showCellCoinDetails:(id)coin withIncomeType:(int)type;
-(void)showCellMessageTip:(int)number;


-(void)initUserCenterHeadCell;      // 初始化头cell
@end
