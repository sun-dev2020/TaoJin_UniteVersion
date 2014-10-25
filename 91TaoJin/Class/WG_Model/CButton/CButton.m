//
//  CButton.m
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "CButton.h"

@implementation CButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         // Initialization code
        [self addTarget:self action:@selector(changeColorClick) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(revertColor) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(cancelTouch) forControlEvents:UIControlEventTouchCancel];
    }
    return self;
}
-(void)getChangeColor{
    if (self.changeColor) {
        self.backgroundColor =self.changeColor;
    }
}
-(void)getRevertColor{
    if (self.nomalColor) {
        self.backgroundColor =self.nomalColor;
    }
}
-(void)changeColorClick{
    self.backgroundColor =kGrayLineColor2_0;
    [self getChangeColor];
}
-(void)revertColor{
    self.backgroundColor =[UIColor clearColor];
    [self getRevertColor];
}
-(void)onClickBtn{
    self.backgroundColor =[UIColor clearColor];
    [self getRevertColor];
}
-(void)cancelTouch{
    self.backgroundColor =[UIColor clearColor];
    [self getRevertColor];
}
@end
