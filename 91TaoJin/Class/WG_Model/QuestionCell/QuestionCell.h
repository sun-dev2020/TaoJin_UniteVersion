//
//  QuestionCell.h
//  91TaoJin
//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic ,strong) UILabel *titleLab ;
@property (nonatomic ,strong) UILabel *contentLab ;
-(void) initCommonQuestionCellWith:(NSDictionary *)dic;
-(float) getQuestCellHeight;
@end
