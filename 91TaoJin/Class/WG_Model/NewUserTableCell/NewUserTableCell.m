//
//  NewUserTableCell.m
//  91TaoJin
//
//  Created by keyrun on 14-5-24.
//  Copyright (c) 2014年 guomob. All rights reserved.
//

#import "NewUserTableCell.h"
#import "SDImageView+SDWebCache.h"
#import "MyUserDefault.h"
#define kLogoSize 29.0

@implementation NewUserTableCell
{
    UIImageView *nextImage;
    UIImageView *cellImage;
    UILabel *_cellTitle;
    UIImageView *_hotImage;
    UILabel *_coinLabel;
    UIImageView *messageTip ;
    UILabel *_messageLabel;
    UIView* line;
    CALayer *layer;
}
@synthesize hotImage =_hotImage;
@synthesize messageLabel =_messageLabel;
@synthesize coinLabel =_coinLabel;
@synthesize erinnernLab =_erinnernLab;
@synthesize userJdsLab =_userJdsLab;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        nextImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next.png"]];
        self.backgroundColor =[UIColor clearColor];
        [self addSubview:nextImage];
        
        layer =[CALayer layer];
        [layer setBackgroundColor:kGrayLineColor2_0.CGColor];
        
        [self.layer addSublayer:layer];
        
        self.selectedBackgroundView =[[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor =kBlockBackground2_0;
    }
    return self;
}
-(UILabel *)loadLabWithFrame:(CGRect) frame andText:(NSString *)text andTextColor:(UIColor *)color withFont:(UIFont *)font{
    UILabel *lab =[[UILabel alloc] initWithFrame:frame];
    lab.text =text;
    lab.textColor =color;
    lab.font =font;
    lab.backgroundColor =[UIColor clearColor];
    return lab;
}
-(UIImageView *)loadImageViewWithFrame :(CGRect) frame andImage:(UIImage *)image {
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:frame];
    imageView.image =image;
    return imageView;
}
-(void)setCellViewByType:(int )type andWithImage:(UIImage*)image andCellTitle:(NSString* )title{
    [layer setFrame:CGRectMake(kOffX_float, kCellHeight -0.5, self.frame.size.width -kOffX_float, 0.5)];
    
    cellImage = [self loadImageViewWithFrame:CGRectMake(kOffX_float, 12, kLogoSize, kLogoSize) andImage:image];
    nextImage.frame =CGRectMake(296, kCellHeight/2 -6.0, 8, 12);
    _cellTitle = [self loadLabWithFrame:CGRectMake(48, kCellHeight/2 -15, 100, 30) andText:title andTextColor:KBlockColor2_0 withFont:[UIFont systemFontOfSize:16.0]];
   
   
    _hotImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hot.png"]];
    _hotImage.frame=CGRectMake(238, kCellHeight/2 -10.0, 51, 20);
    _hotImage.alpha =0;
    
    _coinLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, kCellHeight/2 -7.0, 170, 14)];
    _coinLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    _coinLabel.backgroundColor = [UIColor clearColor];
    _coinLabel.textAlignment = NSTextAlignmentRight;
    
    messageTip =[self loadImageViewWithFrame:CGRectMake(263, kCellHeight/2 -13, 26, 26) andImage:GetImage(@"new@2x.png")];
    messageTip.hidden = YES;
   
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(263, kCellHeight/2 -7, 26, 14)];
    _messageLabel.numberOfLines = 0;
    _messageLabel.hidden = YES;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.font = [UIFont systemFontOfSize:14.0];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = KRedColor2_0;
    self.messageLabel = _messageLabel;
    
    if (image ==nil) {
        _cellTitle.frame =CGRectMake(13, kCellHeight/2 -8.0f, 240, 15);
    }
    [self.contentView addSubview:cellImage];
    [self.contentView addSubview:_cellTitle];
    [self.contentView addSubview:_coinLabel];
    [self.contentView addSubview:nextImage];
    [self.contentView addSubview:_hotImage];
    [self.contentView addSubview:_messageLabel];
    [self.contentView insertSubview:messageTip belowSubview:_messageLabel];
 
    
}
-(void)initUserCenterHeadCell{
    [layer setFrame:CGRectMake(0, 99.5, self.frame.size.width , 0.5)];
    
    _userIcon=[self loadImageViewWithFrame:CGRectMake(kOffX_float, kOffY_float, 65, 65) andImage:GetImage(@"touxiang.png")];
    
    nextImage.frame =CGRectMake(296, 44, 8, 12);
    
   
    //提示信息显示
    _erinnernLab = [self loadLabWithFrame:CGRectMake(_userIcon.frame.origin.x + _userIcon.frame.size.width + 11, _userIcon.frame.origin.y, 200, 17) andText:nil andTextColor:KGrayColor2_0 withFont:[UIFont systemFontOfSize:16.0]];
    
    //用户昵称
    UILabel *userNameLab = [self loadLabWithFrame:CGRectMake(_erinnernLab.frame.origin.x, _erinnernLab.frame.origin.y + _erinnernLab.frame.size.height +11, 180, 12) andText:[NSString stringWithFormat:@"淘金号:%@",[[MyUserDefault standardUserDefaults] getUserInvcode]] andTextColor:KGrayColor2_0 withFont:[UIFont systemFontOfSize:11.0]];
    
    //显示【金豆】文案
    UILabel *jinDouLab = [self loadLabWithFrame:CGRectMake(_erinnernLab.frame.origin.x, userNameLab.frame.origin.y + userNameLab.frame.size.height+11,36, 16) andText:@"金豆" andTextColor:KBlockColor2_0 withFont:[UIFont systemFontOfSize:16.0]];
    
    //显示金豆数量
    _userJdsLab = [self loadLabWithFrame:CGRectMake(jinDouLab.frame.origin.x+jinDouLab.frame.size.width, jinDouLab.frame.origin.y, 100, 16) andText:nil andTextColor:KOrangeColor2_0 withFont:[UIFont boldSystemFontOfSize:16.0]];
   
    [self.contentView addSubview:_userIcon];
    [self.contentView addSubview:_erinnernLab];
    [self.contentView addSubview:userNameLab];
    [self.contentView addSubview:jinDouLab];
    [self.contentView addSubview:_userJdsLab];
    self.contentView.backgroundColor =KLightGrayColor2_0;
}

//设置cell的金豆提示信息
-(void)showCellCoinDetails:(id)coin withIncomeType:(int)type{
    
    NSNumber* num =[NSNumber numberWithInt:0];
    if (_coinLabel.text) {
        _coinLabel.text=nil;
    }
    if ([coin isKindOfClass:[NSNull class]]) {
//        if (coinImage) {
//            [coinImage removeFromSuperview];
//        }
        
    }else{
        switch (type) {
                //绿色
            case 1:
            {
                if (coin == nil) {
//                    if (coinImage) {
//                        [coinImage removeFromSuperview];
//                    }
                }else{
                    _coinLabel.textColor=KGreenColor2_0;
                    if (coin ==num) {
                        
                    }else{
                        _coinLabel.text=[NSString stringWithFormat:@"%@",coin];
//                        [self insertSubview:coinImage belowSubview:nextImage];
                    }
                }
            }
                break;
                //红色
            case 2:
            {
                _coinLabel.textColor=KRedColor2_0;
                if (coin ==num) {
                    
                }else{
                    _coinLabel.text=[NSString stringWithFormat:@"+%@",coin];
//                    [self insertSubview:coinImage belowSubview:nextImage];
                }
            }
                break;
        }
    }
}
//设置cell的消息提示
-(void)showCellMessageTip:(int)number{
    if (number >0) {
        _messageLabel.text=[NSString stringWithFormat:@"%d",number];
        _messageLabel.hidden=NO;
        messageTip.hidden=NO;
    }else{
        _messageLabel.hidden=YES;
        messageTip.hidden=YES;
    }
}
-(void)setTitleLabFont:(float)size andTitleColor:(UIColor *)color{
    _cellTitle.font =[UIFont systemFontOfSize:size];
    _cellTitle.textColor =color;
}
-(void)setButtonFrame:(CGRect)buttonFrame{
   
}
-(void)setImageFrame:(CGRect )imageFrame andTitleFrame:(CGRect)titleFrame {
    cellImage.frame=imageFrame;
    _cellTitle.frame=titleFrame;
    
}
-(void)drawRect:(CGRect)rect{
    /*
     float height =self.frame.size.height;
     CGContextRef currentContext =UIGraphicsGetCurrentContext();
     //    CGContextBeginPath(currentContext);
     CGContextSetStrokeColorWithColor(currentContext, KGrayColor2_0.CGColor);
     CGContextSetLineWidth(currentContext, 0.5f);
     
     CGContextMoveToPoint(currentContext, 320, height-0.5f);
     CGContextAddLineToPoint(currentContext, kOffX_float, height-0.5f);
     CGContextStrokePath(currentContext);
     */
}



- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
