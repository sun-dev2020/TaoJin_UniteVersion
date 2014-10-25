//
//  TaskAppCell.m
//  91TaoJin
//
//  Created by keyrun on 14-5-13.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "TaskAppCell.h"
#import "SDImageView+SDWebCache.h"
#import "TaoJinLabel.h"
//test
@implementation TaskAppCell{
    TaoJinLabel *beanLab;
}

@synthesize appIconImg = _appIconImg;
@synthesize appNameLab = _appNameLab;
@synthesize appInfoLab = _appInfoLab;
@synthesize appBeanNumLab = _appBeanNumLab;
@synthesize canSign = _canSign;
@synthesize isOpen = _isOpen;

/**
 *  初始化Cell
 *
 *  @param style           样式
 *  @param reuseIdentifier 标识
 *  @param isSeparatedLine 是否有分割线
 *
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isSeparatedLine:(BOOL)isSeparatedLine cellHeight:(float)cellHeight{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;
        UIView *view;
        if(isSeparatedLine){
            //分割线
            view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kmainScreenWidth, 5.0f)];
            view.backgroundColor = kBlockBackground2_0;
            [self addSubview:view];
        }
        float backgroundViewY = (view == nil ? 0.0f : view.frame.size.height);
        
        //app图标
        self.appIconImg = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, 12 + backgroundViewY, 50, 50)];
        [self addSubview:self.appIconImg];
        
        //app名称
        self.appNameLab = [self loadWithLabel:CGRectMake(self.appIconImg.frame.origin.x + self.appIconImg.frame.size.width + Spacing2_0, 21 + backgroundViewY, 145, 16) textColor:KBlockColor2_0 font:[UIFont systemFontOfSize:16.0]];
        [self addSubview:self.appNameLab];
        
        //app信息
        self.appInfoLab = [self loadWithLabel:CGRectMake(self.appNameLab.frame.origin.x, 49 + backgroundViewY, 236, 11) textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:12.0]];
        [self addSubview:self.appInfoLab];
        
        // 版本2.0以后新修改或新添加
        //可赚金豆
        self.appBeanNumLab = [self loadWithLabel:CGRectMake(0.0f, 21.0f + backgroundViewY, 100.0f, 14.0f) textColor:kOrangeColor font:[UIFont boldSystemFontOfSize:16.0]];
        [self addSubview:self.appBeanNumLab];
        
        self.canSign = [self loadWithLabel:CGRectMake(kmainScreenWidth - 56.0f - Spacing2_0, 35.0f + backgroundViewY, 56.0f, 15.0f) textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:12]];
        self.canSign.textAlignment = NSTextAlignmentCenter;
        self.canSign.backgroundColor = KOrangeColor2_0;
        self.canSign.text = @"可签到";
        self.canSign.hidden = YES;
        [self addSubview:self.canSign];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.isOpen = NO;
        
        beanLab = [[TaoJinLabel alloc] initWithFrame:CGRectZero text:@"" font:[UIFont boldSystemFontOfSize:11] textColor:kOrangeColor textAlignment:NSTextAlignmentRight numberLines:1];
        [self addSubview:beanLab];
    }
    return self;
}
//
//-(void)layoutSubviews{
//    if(_isOpen){
//        beanLab.hidden = NO;
//        beanLab.text = @"+1000";
//        beanLab.frame = CGRectMake(Spacing2_0, 75.0f + 3.0f, 50.0f, 11.0f);
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.4];
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 20.0f);
//        [UIView commitAnimations];
//    }else{
//    }
//}

//初始化各项Label
-(UILabel *)loadWithLabel:(CGRect )frame textColor:(UIColor *)textColor font:(UIFont *)font{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.font = font;
    return label;
}

/**
 *  不同的app对象显示不同的cell
 *
 *  @param group app对象
 */
-(void)setHeadViewByAppGroup:(GameGroup *)group{
    [_appIconImg setImageWithURL:[NSURL URLWithString:group.appIcon] refreshCache:NO needSetViewContentMode:false needBgColor:false placeholderImage:[UIImage imageNamed:@"appIcon.png"]];
    _appNameLab.text = group.appName;
    [_appNameLab sizeToFit];
    
    _appInfoLab.text = group.appInfor;
    [_appInfoLab sizeToFit];
    _appInfoLab.frame = CGRectMake(_appInfoLab.frame.origin.x, _appNameLab.frame.origin.y + _appNameLab.frame.size.height + 6.0f, kmainScreenWidth - _appInfoLab.frame.origin.x - 15.0f, _appInfoLab.frame.size.height);
    
    // 版本2.0以后新修改或新添加
    //可赚金豆
    if(group.giftBeanNum != 0){
        _appBeanNumLab.hidden = NO;
        int giftBeanNum = 0;
        for(int i = 0 ; i < group.subCells.count ; i ++){
            NSDictionary *subCell = [group.subCells objectAtIndex:i];
            int state = [[subCell objectForKey:@"State"] intValue];
            if(state != 2){
                giftBeanNum += [[subCell objectForKey:@"GiftBean"] intValue];
            }
        }
        if(giftBeanNum != 0){
            NSString *numStr = [@"+" stringByAppendingString:[NSString stringWithFormat:@"%d",giftBeanNum]];
            _appBeanNumLab.text = numStr;
            _appBeanNumLab.hidden = NO;
        }else{
            _appBeanNumLab.hidden = YES;
        }
        [_appBeanNumLab sizeToFit];
        _appBeanNumLab.frame = CGRectMake(kmainScreenWidth - _appBeanNumLab.frame.size.width - Spacing2_0, _appBeanNumLab.frame.origin.y, _appBeanNumLab.frame.size.width, _appBeanNumLab.frame.size.height);
    }else{
        _appBeanNumLab.hidden = YES;
    }
    //可签到
    if(group.signIn > 0){
        if(group.signInState == 0){
            _canSign.hidden = NO;
            _canSign.frame = CGRectMake(_canSign.frame.origin.x, _appInfoLab.frame.origin.y, 56.0f, 15.0f);
            _appInfoLab.frame = CGRectMake(_appInfoLab.frame.origin.x, _appInfoLab.frame.origin.y, _appInfoLab.frame.size.width - _canSign.frame.size.width, _appInfoLab.frame.size.height);
            self.canSign.backgroundColor = KOrangeColor2_0;
            self.canSign.text = @"可签到";
        }else if(group.signInState == 1){
            _canSign.hidden = NO;
            _canSign.frame = CGRectMake(_canSign.frame.origin.x, _appInfoLab.frame.origin.y, 56.0f, 15.0f);
            _appInfoLab.frame = CGRectMake(_appInfoLab.frame.origin.x, _appInfoLab.frame.origin.y, _appInfoLab.frame.size.width - _canSign.frame.size.width, _appInfoLab.frame.size.height);
            self.canSign.backgroundColor = KGreenColor2_0;
            self.canSign.text = @"已签到";
        }else{
            _canSign.hidden = YES;
        }
    }else{
        _canSign.hidden = YES;
        _appInfoLab.frame = CGRectMake(_appInfoLab.frame.origin.x, _appInfoLab.frame.origin.y, kmainScreenWidth - _appInfoLab.frame.origin.x - 15.0f, _appInfoLab.frame.size.height);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
