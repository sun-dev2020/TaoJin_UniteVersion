//
//  TBFootView.h
//  91TaoJin
//
//  Created by keyrun on 14-3-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBFootView : UITableViewHeaderFooterView{
//    BOOL isOpen;
}

@property (nonatomic, strong) UILabel *titleLab;

- (id)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr;
/*
@property(nonatomic ,strong) UIButton* appButton;
@property(nonatomic ,strong) UILabel* tipLabel;
@property(nonatomic ,strong) UIView* bottomView;

-(void)setIsOpen:(BOOL)open;
-(BOOL)isOpen;
*/
@end
