//
//  GarnishedCell.m
//  91TaoJin
//
//  Created by keyrun on 14-6-7.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "GarnishedCell.h"
#import "TaoJinLabel.h"

@implementation GarnishedCell{
    UIImageView *iconImg;                                                       //图标
    TaoJinLabel *titleLab;                                                      //title
    TaoJinLabel *subTitleLab;                                                   //子内容
    TaoJinLabel *jindouLab;                                                     //金豆数
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing2_0, 0.0f, 0.0f, 0.0f)];
        [self addSubview:iconImg];
        
        titleLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 16.0f) text:@"" font:[UIFont systemFontOfSize:16] textColor:KBlockColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:titleLab];
        
        subTitleLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 12.0f) text:@"" font:[UIFont systemFontOfSize:11] textColor:KGrayColor2_0 textAlignment:NSTextAlignmentLeft numberLines:1];
        [self addSubview:subTitleLab];
        
        jindouLab = [[TaoJinLabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f) text:@"+3000" font:[UIFont boldSystemFontOfSize:16] textColor:KOrangeColor2_0 textAlignment:NSTextAlignmentRight numberLines:1];
        [jindouLab sizeToFit];
        jindouLab.frame = CGRectMake(kmainScreenWidth - jindouLab.frame.size.width - Spacing2_0, 22.0f, jindouLab.frame.size.width, jindouLab.frame.size.height);
        [self addSubview:jindouLab];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 75.0f, kmainScreenWidth, 5.0f)];
        view.backgroundColor = kBlockBackground2_0;
        [self addSubview:view];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self; 
}

/**
 *  显示伪装内容
 *
 *  @param guise 伪装对象
 */
-(void)showGarnishContent:(Guise *)guise{
    iconImg.image = guise.guise_iconImg;
    iconImg.frame = CGRectMake(Spacing2_0, 75.0/2 - iconImg.image.size.height/2, iconImg.image.size.width, iconImg.image.size.height);
    
    titleLab.text = guise.guise_titleStr;
    [titleLab sizeToFit];
    titleLab.frame = CGRectMake(iconImg.frame.origin.x + iconImg.frame.size.width + 10.0f, 20.0f, titleLab.frame.size.width, titleLab.frame.size.height);
    
    subTitleLab.text = guise.guise_subTitleStr;
    [subTitleLab sizeToFit];
    subTitleLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.frame.size.height + 7.0f, subTitleLab.frame.size.width, subTitleLab.frame.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
