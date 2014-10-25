//
//  ButtonRowView.h
//  91TaoJin
//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonRowActionBlock)(UIButton *button);

@interface ButtonRowView : UIView{
    ButtonRowActionBlock _btnAction;
}

- (id)initWithFrame:(CGRect )frame imgAry:(NSArray *)imgAry titleAry:(NSArray *)titleAry colorAry:(NSArray *)colorAry btnAction:(ButtonRowActionBlock)btnAction;
@end
