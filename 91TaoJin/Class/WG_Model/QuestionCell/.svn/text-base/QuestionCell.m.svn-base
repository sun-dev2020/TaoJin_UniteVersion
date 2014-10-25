//
//  QuestionCell.m
//  91TaoJin
//
//  Created by keyrun on 14-5-21.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "QuestionCell.h"
#define cellSpace 8.0
#define cellOff_y 8.0
@implementation QuestionCell
{
    UILabel *_contentLab;
    UILabel *_titleLab ;
}
@synthesize contentLab =_contentLab ;
@synthesize titleLab = _titleLab ;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        self.backgroundView =nil;
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        
        _titleLab =[self loadLabelWith:CGRectMake(kOffX_float, 10.0, kmainScreenWidth -2*kOffX_float, 0) andText:@"" andTextColor:KBlockColor2_0 andFont:[UIFont fontWithName:@"Arial" size:14.0]];
       
        _contentLab =[self loadLabelWith:CGRectMake(kOffX_float, _titleLab.frame.origin.y +_titleLab.frame.size.height +cellSpace, kmainScreenWidth -2*kOffX_float, 0) andText:@"" andTextColor:KOrangeColor2_0 andFont:[UIFont fontWithName:@"Arial" size:14.0]];    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

-(UILabel *)loadLabelWith:(CGRect) frame andText:(NSString *)text andTextColor:(UIColor *)color andFont:(UIFont *)font{
    UILabel *lab =[[UILabel alloc] initWithFrame:frame];
    lab.font =font;
    lab.textColor =color;
    lab.numberOfLines =0;
    lab.text =text;
    lab.backgroundColor =[UIColor clearColor];
    lab.lineBreakMode =NSLineBreakByCharWrapping ;
    lab.adjustsLetterSpacingToFitWidth =YES;
    return  lab;
}
-(void) initCommonQuestionCellWith:(NSDictionary *)dic{
    _dataDic =dic;
    
    NSString *title =[_dataDic objectForKey:@"Title"];
    _titleLab.text =title ;
    [_titleLab sizeToFit];
    _titleLab.frame =CGRectMake(kOffX_float, 10.0, kmainScreenWidth -2*kOffX_float, _titleLab.frame.size.height);
    [self addSubview:_titleLab];
    
    NSString* content =[_dataDic objectForKey:@"Content"];
    _contentLab.text =content ;
    [_contentLab sizeToFit];
    _contentLab.frame =CGRectMake(kOffX_float, _titleLab.frame.origin.y + _titleLab.frame.size.height + cellSpace, kmainScreenWidth -2* kOffX_float, _contentLab.frame.size.height);
    [self addSubview:_contentLab];
    
    
}
-(float) getQuestCellHeight{
    return _contentLab.frame.origin.y +_contentLab.frame.size.height +cellOff_y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
