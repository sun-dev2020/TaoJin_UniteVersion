//
//  ShakeCell.h
//  91TaoJin
//
//  Created by keyrun on 14-5-28.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharkContent.h"
#import "TaoJinLabel.h"
#import "TaoJinButton.h"
@interface ShareCell : UITableViewCell

-(void)showShareCellContent;
-(float )getShareCellHeight;

@property (nonatomic ,strong) SharkContent *shareContent;
@property (nonatomic ,strong) TaoJinButton *praiseBtn;
@property (nonatomic ,strong) TaoJinButton *shareBtn;
@end
