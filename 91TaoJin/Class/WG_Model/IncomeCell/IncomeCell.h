//
//  IncomeCell.h
//  TJiphone
//
//  Created by keyrun on 13-10-9.
//  Copyright (c) 2013年 keyrun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLog.h"
@interface IncomeCell : UITableViewCell

@property(nonatomic,strong) UserLog* userlog;

//@property (nonatomic, retain) UILabel *beanValue;                                   //金豆的变化值
//@property (nonatomic, retain) UILabel *commentLab;                                  //变化的内容
//@property (nonatomic, retain) UILabel *timeLab;                                        //时间

-(void)initIncomeCell;
-(float)getIncomeCellHeight;
@end
