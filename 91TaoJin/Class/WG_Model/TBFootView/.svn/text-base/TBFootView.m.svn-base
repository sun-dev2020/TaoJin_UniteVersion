//
//  TBFootView.m
//  91TaoJin
//
//  Created by keyrun on 14-3-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TBFootView.h"

@implementation TBFootView

@synthesize titleLab = _titleLab;

- (id)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr{
    self = [super initWithFrame:frame];
    if(self){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, frame.size.height)];
        view.backgroundColor = kBlockBackground2_0;
        [self addSubview:view];
        _titleLab = [self loadLabelWithFrame:CGRectMake(Spacing2_0, 0.0f, frame.size.width - 5.0f, frame.size.height) titleStr:titleStr];
        [self addSubview:_titleLab];
    }
    return self;
}

-(UILabel *)loadLabelWithFrame:(CGRect )frame titleStr:(NSString *)titleStr{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = KGrayColor2_0;
    label.text = titleStr;
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentLeft;
    return label;
}

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 5 - 12 - 40 - 14 - 11, kmainScreenWidth, 11)];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.font = [UIFont systemFontOfSize:11];
        _tipLabel.textColor = kRedColor;
        _tipLabel.text = @"该游戏支持每日签到，请勿随意下载";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.hidden = YES;
        _tipLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_tipLabel];
        
        _appButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _appButton.frame =CGRectMake(8, self.frame.size.height - 5 - 14 - 40, kmainScreenWidth - 16, 40);
        [_appButton setTitle:@"安装/打开" forState:UIControlStateNormal];
        [_appButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _appButton.backgroundColor = kGreenColor2;
        _appButton.hidden = YES;
//        [self addSubview:_appButton];
        
        _bottomView =[[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-5, kmainScreenWidth, 5)];
        _bottomView.backgroundColor =kSelectBGColor;
        [self addSubview:_bottomView];
    }
    return self;
}

-(void)setIsOpen:(BOOL)open{
    if (open != isOpen) {
        isOpen = open;
        if (isOpen) {
            _appButton.hidden =NO;
            _tipLabel.hidden = NO;
        }else{
            _appButton.hidden =YES;
            _tipLabel.hidden =YES;
        }
    }
}

-(BOOL)isOpen{
    return isOpen;
}
*/
@end
